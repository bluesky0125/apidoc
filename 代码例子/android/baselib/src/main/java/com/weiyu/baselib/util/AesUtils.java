package com.weiyu.baselib.util;

import android.annotation.SuppressLint;
import android.os.Build;
import android.text.TextUtils;
import android.util.Base64;

import java.io.UnsupportedEncodingException;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.Provider;
import java.security.SecureRandom;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

import static android.os.Build.VERSION_CODES.M;

/**
 * Created by weiweiyu
 * on 2019/5/15
 */
public class AesUtils {
    /**
     * 算法Key
     */
    private static final String KEY_ALGORITHM = "AES";
    /**
     * 加密算法
     */
    private static final String CIPHER_ALGORITHM = "AES";


    /**
     * 加密数据
     *
     * @param data 待加密内容
     * @param key  加密的密钥
     * @return 加密后的数据
     */
    public static String encrypt(String data, String key) {
        try {
            // 获得密钥
            Key desKey = keyGenerator(key);
            // 实例化一个密码对象
            Cipher cipher = Cipher.getInstance(CIPHER_ALGORITHM);
            // 密码初始化
            cipher.init(Cipher.ENCRYPT_MODE, desKey);
            // 执行加密
            byte[] bytes = cipher.doFinal(data.getBytes("UTF-8"));
            return Base64.encodeToString(bytes, Base64.DEFAULT);
        } catch (Exception e) {
            // 解析异常
            return "";
        }
    }

    /**
     * 解密数据
     *
     * @param data 待解密的内容
     * @param key  解密的密钥
     * @return 解密后的字符串
     */
    public static String decrypt(String data, String key) {
        try {
            // 生成密钥
            Key kGen = keyGenerator(key);
            // 实例化密码对象
            Cipher cipher = Cipher.getInstance(CIPHER_ALGORITHM);
            // 初始化密码对象
            cipher.init(Cipher.DECRYPT_MODE, kGen);
            // 执行解密
            byte[] bytes = cipher.doFinal(Base64.decode(data, Base64.DEFAULT));
            return new String(bytes);
        } catch (Exception e) {
            e.printStackTrace();
            // 解析异常
            return "";
        }
    }

    /**
     * 获取密钥
     *
     * @param key 密钥字符串
     * @return 返回一个密钥
     */
    @SuppressLint("DeletedProvider")
    private static Key keyGenerator(String key) {
        return new SecretKeySpec(InsecureSHA1PRNGKeyDerivator.deriveInsecureKey(key.getBytes(), 32), KEY_ALGORITHM);
    }
}

