package com.yjy.wallet.bean.htdf

data class TxRep(val tx: Tx,
                 val log: MutableList<TxLog> = mutableListOf(),
                 val gasUsed: String = "",
                 val gasWanted: String = "",
                 val height: String = "",
                 val txhash: String = "",
                 val tags: List<TagsItem>?)