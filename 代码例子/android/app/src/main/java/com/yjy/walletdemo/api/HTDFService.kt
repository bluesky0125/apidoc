package com.yjy.wallet.api

import com.weiyu.baselib.net.ApiManager
import com.yjy.wallet.bean.htdf.AccountInfo
import com.yjy.wallet.bean.htdf.Send
import com.yjy.wallet.bean.htdf.Transactions
import com.yjy.wallet.bean.htdf.TxRep
import com.yjy.walletdemo.bean.BroadCast
import com.yjy.walletdemo.bean.TransationsParams
import io.reactivex.Flowable
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.schedulers.Schedulers

class HTDFService() {


    val baseHtdf: String = "http://118.190.245.246:1317"//测试公网
    fun htdfApi(): HTDFApi {
        return ApiManager.instance.getService(baseHtdf, HTDFApi::class.java)
    }

    fun broadcast(params: BroadCast): Flowable<Send> = htdfApi().broadcast(params).subscribeOn(Schedulers.io()).observeOn(AndroidSchedulers.mainThread())
    fun getAccount(address: String): Flowable<AccountInfo> = htdfApi().getaccounts(address).subscribeOn(Schedulers.io()).observeOn(AndroidSchedulers.mainThread())
    fun transactions(transationsParams: TransationsParams): Flowable<Transactions> = htdfApi().transactions(transationsParams).subscribeOn(Schedulers.io()).observeOn(AndroidSchedulers.mainThread())
    fun gettx(hax: String): Flowable<TxRep> = htdfApi().gettx(hax).subscribeOn(Schedulers.io()).observeOn(AndroidSchedulers.mainThread())
}