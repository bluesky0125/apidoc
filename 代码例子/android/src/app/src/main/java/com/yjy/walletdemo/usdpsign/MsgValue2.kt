package com.yjy.wallet.usdp.usdpsign

data class MsgValue2(val Amount: List<AmountItem>?,
                     val From: String = "",
                     val To: String = "")