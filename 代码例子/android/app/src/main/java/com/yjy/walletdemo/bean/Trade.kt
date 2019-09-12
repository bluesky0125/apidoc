package com.yjy.wallet.bean.htdftx

/**
 *Created by weiweiyu
 *on 2019/5/22
 */
data class Trade(
    val money: String = "",
    val memo: String = "",
    val from: String = "",
    val id: Int = 0,
    val tradehash: String = "",
    val to: String = "",
    val type: String = "",
    val blockheight: Long = 0,
    var inval: Int = 0,
    val tradetime: String = ""
)