package com.yjy.wallet.usdp.usdpsign

import java.io.Serializable

data class UsdpTransaction(var type: String, var value: UsdpValue):Serializable