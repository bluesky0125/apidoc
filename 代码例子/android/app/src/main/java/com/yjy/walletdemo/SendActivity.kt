package com.yjy.walletdemo

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.support.v7.widget.LinearLayoutManager
import android.text.TextUtils
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.lqr.adapter.LQRAdapterForRecyclerView
import com.lqr.adapter.LQRViewHolderForRecyclerView
import com.tbruyelle.rxpermissions2.RxPermissions
import com.weiyu.baselib.base.BaseActivity
import com.yjy.wallet.api.HTDFService
import com.yjy.wallet.api.TxService
import com.yjy.wallet.bean.htdf.AccountInfo
import com.yjy.wallet.bean.htdf.Send
import com.yjy.wallet.bean.htdftx.Trade
import com.yjy.wallet.bean.htdftx.TradeRep
import com.yjy.wallet.usdp.usdpsign.USDPSign
import com.yjy.walletdemo.bean.BroadCast
import io.reactivex.subscribers.ResourceSubscriber
import kotlinx.android.synthetic.main.activity_send.*
import org.bitcoinj.core.AddressFormatException
import org.bitcoinj.core.Bech32
import org.bitcoinj.core.ECKey
import org.bitcoinj.core.Utils
import org.json.JSONObject
import org.web3j.utils.Numeric
import retrofit2.HttpException

/**
 * weiweiyu
 * 2019/9/12
 * 575256725@qq.com
 * 13115284785
 */
class SendActivity : BaseActivity() {
    var adapter: LQRAdapterForRecyclerView<Trade>? = null
    override fun getContentLayoutResId(): Int = R.layout.activity_send

    override fun initializeContentViews() {
        adapter = object : LQRAdapterForRecyclerView<Trade>(this, arrayListOf(), R.layout.item) {
            override fun convert(helper: LQRViewHolderForRecyclerView?, item: Trade, position: Int) {
                helper?.setText(R.id.tv_tx, Gson().toJson(item))
            }
        }
        iv_scan.setOnClickListener {
            if (RxPermissions(this).isGranted(Manifest.permission.CAMERA)) {
                val intent = Intent(this@SendActivity, ScanActivity::class.java)
                startActivityForResult(intent, 0x01)
            } else {
                RxPermissions(this).request(Manifest.permission.CAMERA)
                    .subscribe {
                        if (it) {
                            val intent = Intent(this@SendActivity, ScanActivity::class.java)
                            startActivityForResult(intent, 0x01)
                        }
                    }
            }
        }
        rcv_record.layoutManager = LinearLayoutManager(this)
        rcv_record.adapter = adapter
        btn_send.setOnClickListener {
            val amount1 = et_price.text.toString()
            val address = et_address.text.toString()
            try {
                val toData = Bech32.decode(address)
                if (toData.hrp != "htdf") {
                    toast("地址无效")
                    return@setOnClickListener
                }
            } catch (e: AddressFormatException) {
                toast("地址无效")
                return@setOnClickListener
            }
            if (TextUtils.isEmpty(amount1)) {
                toast("请输入转账金额")
                return@setOnClickListener
            }
            if (amount1.toDouble() <= 0.0) {
                toast("转账金额必须大于0")
                return@setOnClickListener
            }
            val notSign = USDPSign.getNotSignTransaction(
                intent.getStringExtra("address"),
                et_address.text.toString(),
                et_price.text.toString(),
                "satoshi",
                "",
                "20"
            )
            HTDFService().getAccount(intent.getStringExtra("address"))
                .subscribe(object : ResourceSubscriber<AccountInfo>() {
                    override fun onComplete() {
                    }

                    @SuppressLint("SetTextI18n")
                    override fun onNext(t: AccountInfo) {
                        if (t.value.coins!!.isNotEmpty()) {
                            var amount = 0.0
                            for (b in t.value.coins) {
                                amount = amount.plus(b.amount.toDouble())
                            }
                            if (amount > et_price.text.toString().toDouble()) {
                                val ecKey =
                                    ECKey.fromPrivate(Numeric.hexStringToByteArray(intent.getStringExtra("key")))
                                val sign = USDPSign.getSignTransaction(
                                    t.value.account_number,
                                    t.value.sequence,
                                    false,
                                    ecKey,
                                    notSign
                                )
                                val gson = GsonBuilder().serializeNulls().disableHtmlEscaping().create()
                                val hex = Utils.HEX.encode(gson.toJson(sign).toByteArray())
                                showProgressDialog("正在广播")
                                HTDFService().broadcast(BroadCast(hex)).subscribe(object : ResourceSubscriber<Send>() {
                                    override fun onComplete() {

                                    }

                                    override fun onNext(t: Send) {
                                        dismissProgressDialog()
                                        if (!TextUtils.isEmpty(t.raw_log)) {
                                            val json = JSONObject(t.raw_log.replace("\\", ""))
                                            if (json.has("message")) {
                                                toast(json.getString("message"))
                                            } else {
                                                toast(t.raw_log)
                                            }
                                        } else {
                                            toast("广播成功")
                                            getData()
                                        }
                                    }

                                    override fun onError(t: Throwable) {
                                        dismissProgressDialog()
                                        when (t) {
                                            is HttpException -> try {
                                                val body = t.response().errorBody()
                                                val json = JSONObject(body?.string())
                                                if (json.has("message")) {
                                                    toast(json.getString("message"))
                                                } else {
                                                    toast(if (t.message!!.contains("500")) "服务器繁忙,请稍后再试" else t.message!!)
                                                }
                                            } catch (e: java.lang.Exception) {
                                                toast(if (t.message!!.contains("500")) "服务器繁忙,请稍后再试" else t.message!!)
                                            }
                                            else -> toast(t.message!!)
                                        }
                                    }
                                })
                            } else {
                                toast("余额不足")
                            }
                        }
                    }

                    override fun onError(t: Throwable?) {
                    }
                })
        }
        getData()
    }
    // Get the results:
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (resultCode == Activity.RESULT_OK) {
            if (requestCode == 0x01)
                if (data != null) {
                    runOnUiThread {
                        et_address.setText(data.getStringExtra("sacanurl"))
                    }
                }
            if (requestCode == 100) {
                runOnUiThread {
                    et_address.setText(data?.getStringExtra("sacanurl"))
                }
            }
        }
    }
    fun getData() {
        TxService().getTx(intent.getStringExtra("address"), "0")
            .subscribe(object : ResourceSubscriber<TradeRep>() {
                override fun onComplete() {
                }

                override fun onNext(t: TradeRep) {
                    adapter?.data = t.trade
                }

                override fun onError(t: Throwable?) {
                }
            })
    }
}