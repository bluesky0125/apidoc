package com.yjy.wallet.api

import com.yjy.wallet.bean.htdftx.TradeRep
import io.reactivex.Flowable
import retrofit2.http.GET
import retrofit2.http.Query

/**
 *Created by weiweiyu
 * 575256725@qq.com
 *on 2019/7/5
 *
 * USDP HTDF 查询历史记录api
 */
interface TxApi {
    @GET("/api/getRecord")
    fun getTx(@Query("address") address: String, @Query("height") height: String, @Query("type") type: String): Flowable<TradeRep>

    @GET("/api/getHistory")
    fun getHistory(@Query("address") address: String, @Query("height") height: String, @Query("type") type: String): Flowable<TradeRep>

}
