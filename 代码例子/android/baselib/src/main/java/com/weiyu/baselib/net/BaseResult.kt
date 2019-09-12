package com.weiyu.baselib.net

class BaseResult<T> {
    var code: Int? = null
    var msg: String? = null
    var orderid: Int? = null
    var data: T? = null
}