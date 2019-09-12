package com.yjy.wallet.usdp.usdpsign

data class MsgValue(val Amount: List<AmountItem>?,
                    val From: String = "",
                    val To: String = "",
                    val Data: String = "",
                    val Gas: Long = 0,
                    val GasPrice:Long = 0,
                    val GasLimit :Long = 0)