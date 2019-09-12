package com.yjy.wallet.api

import com.weiyu.baselib.net.ApiManager
import com.yjy.wallet.bean.htdftx.TradeRep
import io.reactivex.Flowable
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.schedulers.Schedulers

//节点切换不能用单例
class TxService() {

    val htdf: String =  "http://test-system.htdfscan.com"
    fun txApi(): TxApi {
        return ApiManager.instance.getService(htdf, TxApi::class.java)
    }

    fun getTx(address: String, height: String): Flowable<TradeRep> = txApi().getTx(address, height, "yes").subscribeOn(Schedulers.io()).observeOn(AndroidSchedulers.mainThread())

    fun getHistory(address: String, height: String): Flowable<TradeRep> = txApi().getHistory(address, height, "yes").subscribeOn(Schedulers.io()).observeOn(AndroidSchedulers.mainThread())
}