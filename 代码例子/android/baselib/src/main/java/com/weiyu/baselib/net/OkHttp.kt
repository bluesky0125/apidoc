package com.weiyu.baselib.net

import com.lzy.okgo.interceptor.HttpLoggingInterceptor
import com.weiyu.baselib.BuildConfig
import java.security.cert.CertificateException
import java.security.cert.X509Certificate
import java.util.concurrent.TimeUnit
import java.util.logging.Level
import javax.net.ssl.*


/**
 *Created by weiweiyu
 *on 2019/5/28
 */

class OkHttp private constructor() {
    companion object {
        //设置连接超时的值
        private val CONNECT_TIMEOUT = 60L
        private val READ_TIMEOUT = 60L
        private val WRITE_TIMEOUT = 60L
        val builder: okhttp3.OkHttpClient.Builder by lazy(mode = LazyThreadSafetyMode.SYNCHRONIZED) {
            val builder = okhttp3.OkHttpClient.Builder()
            //新建一个文件用来缓存网络请求
            //        File cacheDirectory = new File(VinoApplication.getInstance()
            //                .getCacheDir().getAbsolutePath(), "HttpCache");
            //设置连接超时
            builder.retryOnConnectionFailure(true)
            builder.connectTimeout(CONNECT_TIMEOUT, TimeUnit.SECONDS) // 连接超时时间阈值
            builder.readTimeout(READ_TIMEOUT, TimeUnit.SECONDS)   // 数据获取时间阈值
            builder.writeTimeout(WRITE_TIMEOUT, TimeUnit.SECONDS)  // 写数据超时时间阈值
            // Install the all-trusting trust manager
            val trustAllCerts = arrayOf<TrustManager>(object : X509TrustManager {
                override fun getAcceptedIssuers(): Array<X509Certificate> {
                    return  arrayOf()
                }
                @Throws(CertificateException::class)
                override fun checkClientTrusted(chain: Array<java.security.cert.X509Certificate>, authType: String) {
                }

                @Throws(CertificateException::class)
                override fun checkServerTrusted(chain: Array<java.security.cert.X509Certificate>, authType: String) {
                }
            })

            val sslContext = SSLContext.getInstance("SSL")
            sslContext.init(null, trustAllCerts, java.security.SecureRandom())
            // Create an ssl socket factory with our all-trusting manager
            val sslSocketFactory = sslContext.socketFactory

            builder.sslSocketFactory(sslSocketFactory)
            builder.hostnameVerifier(object : HostnameVerifier{
                override fun verify(hostname: String?, session: SSLSession?): Boolean {
                    return true
                }
            })
            if (BuildConfig.DEBUG) {
                val interceptor = HttpLoggingInterceptor("WLog")
                interceptor.setPrintLevel(HttpLoggingInterceptor.Level.BODY)
                interceptor.setColorLevel(Level.INFO)
                builder.addInterceptor(interceptor)
            }
            //设置缓存文件
            //        builder.cache(new Cache(cacheDirectory, 10 * 1024 * 1024));
            builder.addInterceptor { chain ->
                val request = chain.request().newBuilder()
                        .addHeader("Content-Type", "application/json; charset=UTF-8")
                        .addHeader("Connection", "keep-alive")
                        .addHeader("Accept", "*/*")
//                    .addHeader("Authentication", "Basic ${Base64.getEncoder().encodeToString(("btcAndroidWallet:btcAndroidWallet").toByteArray())}")
                        .header("Cache-Control", String.format("public, max-age=%d", 60))
                        .removeHeader("Pragma")
                        .build()
                chain.proceed(request)
            }
            builder
        }
    }
}