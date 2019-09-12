package com.yjy.wallet.bean.htdf

import com.yjy.wallet.usdp.usdpsign.AmountItem

data class MsgItem(val amount: List<AmountItem>?,
                   val from: String = "",
                   val to: String = "",
                   val hash: String = "")