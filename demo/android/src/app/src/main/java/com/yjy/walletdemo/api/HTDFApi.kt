package com.yjy.wallet.api

import com.yjy.wallet.bean.htdf.AccountInfo
import com.yjy.wallet.bean.htdf.Send
import com.yjy.wallet.bean.htdf.Transactions
import com.yjy.wallet.bean.htdf.TxRep
import com.yjy.walletdemo.bean.BroadCast
import com.yjy.walletdemo.bean.TransationsParams
import io.reactivex.Flowable
import retrofit2.http.Body
import retrofit2.http.GET
import retrofit2.http.POST
import retrofit2.http.Path

interface HTDFApi {

    @GET("/auth/accounts/{address}")
    fun getaccounts(@Path("address") address: String): Flowable<AccountInfo>

    //广播交易
    @POST("/hs/broadcast")
    fun broadcast(@Body params: BroadCast): Flowable<Send>

    //
    @POST("/accounts/transactions")
    fun transactions(@Body params: TransationsParams): Flowable<Transactions>

    @GET("/transaction/{hax}")
    fun gettx(@Path("hax") hax: String): Flowable<TxRep>

}
