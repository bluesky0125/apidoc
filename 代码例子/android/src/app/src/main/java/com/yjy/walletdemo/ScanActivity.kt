package com.yjy.walletdemo

import android.annotation.SuppressLint
import android.content.Intent
import android.graphics.Bitmap
import android.text.TextUtils
import com.jaeger.library.StatusBarUtil
import com.lzy.imagepicker.ImagePicker
import com.lzy.imagepicker.bean.ImageItem
import com.lzy.imagepicker.ui.ImageGridActivity
import com.uuzuche.lib_zxing.activity.CaptureFragment
import com.uuzuche.lib_zxing.activity.CodeUtils
import com.weiyu.baselib.base.BaseActivity
import com.weiyu.baselib.util.QRCodeDecoder
import io.reactivex.Flowable
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.schedulers.Schedulers
import io.reactivex.subscribers.ResourceSubscriber
import java.util.*


/**
 *Created by weiweiyu
 *on 2019/4/29
 */
class ScanActivity : BaseActivity() {
    val IMAGE_PICKER = 100

    override fun getContentLayoutResId(): Int = R.layout.activity_scan1

    override fun initializeContentViews() {

        val captureFragment = CaptureFragment()
        captureFragment.analyzeCallback = object : CodeUtils.AnalyzeCallback {
            override fun onAnalyzeSuccess(mBitmap: Bitmap, result: String) {
                handleResult(result)
            }

            override fun onAnalyzeFailed() {

            }
        }
        supportFragmentManager.beginTransaction().replace(R.id.fl_zxing_container, captureFragment).commit()
    }

    fun start() {
        ImagePicker.getInstance().isMultiMode = false
        ImagePicker.getInstance().isCrop = false
        ImagePicker.getInstance().isShowCamera = false
        val intent = Intent(this, ImageGridActivity::class.java)
        startActivityForResult(intent, IMAGE_PICKER)
    }


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (resultCode == ImagePicker.RESULT_CODE_ITEMS && requestCode == IMAGE_PICKER) {
            val images = data?.getSerializableExtra(ImagePicker.EXTRA_RESULT_ITEMS) as ArrayList<ImageItem>
            if (images.isNotEmpty()) {
                //取第一张照片
                Flowable.just(images[0].path)
                    .observeOn(Schedulers.io())
                    .map {
                        var s =
                            if (QRCodeDecoder.syncDecodeQRCode(it) == null) "" else QRCodeDecoder.syncDecodeQRCode(it)
                        s
                    }
                    .observeOn(AndroidSchedulers.mainThread())
                    .subscribe(object : ResourceSubscriber<String>() {
                        override fun onError(t: Throwable?) {
                            toast(getString(R.string.scan_no_result))
                        }

                        override fun onComplete() {

                        }

                        override fun onNext(t: String?) {
                            if (TextUtils.isEmpty(t)) {
                                toast(getString(R.string.scan_no_result2))
                            } else {
                                handleResult(t)
                            }
                        }

                    })

            }
        }
    }


    @SuppressLint("NewApi")
    private fun handleResult(result: String?) {
        result ?: return
        val intent = Intent()
        intent.putExtra("sacanurl", result)
        setResult(RESULT_OK, intent)
        finish()

    }

    fun check(s: String): Boolean {
        s.forEach {
            if (it == '0' || it == '1' || it == '2' || it == '3' || it == '4' || it == '5' || it == '6' || it == '7' || it == '8' || it == '9') {

            } else {
                return false
            }
        }
        return true
    }

    override fun setStatusBar() {
        super.setStatusBar()
        StatusBarUtil.setDarkMode(this)
    }
}