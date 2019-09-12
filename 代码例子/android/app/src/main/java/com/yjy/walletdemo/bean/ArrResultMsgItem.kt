package com.yjy.wallet.bean.htdf

import com.yjy.wallet.usdp.usdpsign.AmountItem
import java.io.Serializable

class ArrResultMsgItem(var Height: String,
                       var Hash: String,
                       var From: String,
                       var To: String,
                       var Amount: List<AmountItem> = arrayListOf(),
                       var Time: String = "",
                       var Memo: String = "") : Serializable