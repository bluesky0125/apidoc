package com.yjy.walletdemo

import android.annotation.SuppressLint
import android.content.Intent
import android.graphics.Bitmap
import android.text.TextUtils
import android.widget.Toast
import com.weiyu.baselib.base.BaseActivity
import com.weiyu.baselib.util.QRCodeUtil
import com.yjy.wallet.api.HTDFService
import com.yjy.wallet.bean.htdf.AccountInfo
import io.github.novacrypto.bip39.MnemonicValidator
import io.github.novacrypto.bip39.Validation.InvalidChecksumException
import io.github.novacrypto.bip39.Validation.InvalidWordCountException
import io.github.novacrypto.bip39.Validation.UnexpectedWhiteSpaceException
import io.github.novacrypto.bip39.Validation.WordNotFoundException
import io.github.novacrypto.bip39.wordlists.English
import io.reactivex.Flowable
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.schedulers.Schedulers
import io.reactivex.subscribers.ResourceSubscriber
import kotlinx.android.synthetic.main.activity_main.*
import org.bitcoinj.core.Bech32
import org.bitcoinj.core.ECKey
import org.bitcoinj.crypto.HDUtils
import org.web3j.utils.Numeric

class MainActivity : BaseActivity() {
    override fun getContentLayoutResId(): Int = R.layout.activity_main

    override fun initializeContentViews() {
        btn_words.setOnClickListener {
            var wallet = YJYWalletUtils.createWallet(this, "")
            var privateKey1 = wallet.activeKeyChain.getKeyByPath(HDUtils.parsePath("M/44H/346H/0H/0/0"), true)?.privKey
            var ecKey1 = ECKey.fromPrivate(privateKey1)
            val payloadBytes1 = BitcoinCashBitArrayConverter.convertBits(ecKey1.pubKeyHash, 8, 5, true)
            val addressHtdf = Bech32.encode("htdf", payloadBytes1)
            val str = StringBuffer()
            wallet.activeKeyChain.mnemonicCode!!.forEach {
                str.append(it).append(" ")
            }
            str.deleteCharAt(str.length - 1)
            et_words.setText(str.toString())
            et_key.setText(ecKey1.privateKeyAsHex)
            tv_pubKey.text = "htdf公钥:" + ecKey1.publicKeyAsHex
            tv_htdf.text = "$addressHtdf"
            setCode(addressHtdf)

        }
        btn_import.setOnClickListener {
            import()
        }
        btn_send.setOnClickListener {
            val intent = Intent(this, SendActivity::class.java)
            intent.putExtra("key", et_key.text.toString())
            intent.putExtra("address", tv_htdf.text.toString())
            startActivity(intent)
        }
        import()
        btn_import_key.setOnClickListener {
            if (et_key.text.length != 64 || !isHexNumber(et_key.text.toString())) {
                Toast.makeText(this, "输入的私钥格式不正确", Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }
            et_words.setText("")
            var key = Numeric.hexStringToByteArray(et_key.text.toString())
            var ecKey = ECKey.fromPrivate(key)
            val payloadBytes2 = BitcoinCashBitArrayConverter.convertBits(ecKey.pubKeyHash, 8, 5, true)
            val addressHtdf = Bech32.encode("htdf", payloadBytes2)
            et_key.setText(ecKey.privateKeyAsHex)
            tv_pubKey.text = "htdf公钥:" + ecKey.publicKeyAsHex
            tv_htdf.text = "$addressHtdf"
            setCode(addressHtdf)
        }
        btn_balance.setOnClickListener {
            if (TextUtils.isEmpty(tv_htdf.text)) {
                return@setOnClickListener
            }
            getBlance()
        }
        getBlance()
    }

    fun getBlance() {
        HTDFService().getAccount(tv_htdf.text.toString())
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
                        tv_balance.text = "$amount HTDF"
                    }
                }

                override fun onError(t: Throwable?) {
                }
            })
    }

    fun setCode(address: String) {
        Flowable.just(QRCodeUtil.createQRCode(address, 800, 0xff000000.toInt(), 0xfff5f5f5.toInt()))
            .subscribeOn(Schedulers.io())
            .observeOn(AndroidSchedulers.mainThread())
            .subscribe(object : ResourceSubscriber<Bitmap>() {
                override fun onComplete() {
                }

                override fun onNext(t: Bitmap?) {
                    iv_code.setImageBitmap(t)
                }

                override fun onError(t: Throwable?) {
                }
            })
    }

    fun import() {
        var boolean = false
        try {
            MnemonicValidator.ofWordList(English.INSTANCE).validate(et_words.text.toString())
            boolean = true
        } catch (e: InvalidChecksumException) {
            e.printStackTrace()
        } catch (e: InvalidWordCountException) {
            e.printStackTrace()
        } catch (e: WordNotFoundException) {
            e.printStackTrace()
        } catch (e: UnexpectedWhiteSpaceException) {
            e.printStackTrace()
        }
        if (!boolean) {
            Toast.makeText(this, "助记词格式不正确", Toast.LENGTH_SHORT).show()
            return
        }
        var wallet = YJYWalletUtils.createWallet(et_words.text.toString())
        var privateKey1 = wallet.activeKeyChain.getKeyByPath(HDUtils.parsePath("M/44H/346H/0H/0/0"), true)?.privKey
        var ecKey1 = ECKey.fromPrivate(privateKey1)
        val payloadBytes1 = BitcoinCashBitArrayConverter.convertBits(ecKey1.pubKeyHash, 8, 5, true)
        val addressHtdf = Bech32.encode("htdf", payloadBytes1)
        et_key.setText(ecKey1.privateKeyAsHex)
        tv_pubKey.text = "htdf公钥:" + ecKey1.publicKeyAsHex
        tv_htdf.text = "$addressHtdf"
        setCode(addressHtdf)
    }

    //十六进制
    fun isHexNumber(str: String): Boolean {
        var flag = false
        for (i in 0 until str.length) {
            val cc = str[i]
            if (cc == '0' || cc == '1' || cc == '2' || cc == '3' || cc == '4' || cc == '5' || cc == '6' || cc == '7' || cc == '8' || cc == '9' || cc == 'A' || cc == 'B' || cc == 'C' ||
                cc == 'D' || cc == 'E' || cc == 'F' || cc == 'a' || cc == 'b' || cc == 'c' || cc == 'c' || cc == 'd' || cc == 'e' || cc == 'f'
            ) {
                flag = true
            }
        }
        return flag
    }
}
