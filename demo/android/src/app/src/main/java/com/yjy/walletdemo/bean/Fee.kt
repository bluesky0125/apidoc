package com.yjy.wallet.bean.htdf

import com.yjy.wallet.usdp.usdpsign.AmountItem

data class Fee(val amount: List<AmountItem>?,
               val gas: String = "")