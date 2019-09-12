package com.yjy.walletdemo

import android.app.Application
import android.support.multidex.MultiDex

/**
 *Created by weiweiyu
 *on 2019/5/23
 */
class App:Application(){
    override fun onCreate() {
        super.onCreate()
        MultiDex.install(this)
    }
}