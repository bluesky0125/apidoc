package com.yjy.walletdemo

import android.app.Activity
import android.os.Environment
import com.google.common.base.Splitter
import io.github.novacrypto.bip39.MnemonicGenerator
import io.github.novacrypto.bip39.Words
import io.github.novacrypto.bip39.wordlists.English
import org.bitcoinj.core.NetworkParameters
import org.bitcoinj.crypto.MnemonicCode
import org.bitcoinj.crypto.MnemonicException
import org.bitcoinj.params.MainNetParams
import org.bitcoinj.script.Script
import org.bitcoinj.wallet.DeterministicSeed
import org.bitcoinj.wallet.Wallet
import java.security.SecureRandom


class YJYWalletUtils {
    companion object {
        private var networkParams: NetworkParameters? = null
        var basePath = Environment.getExternalStorageDirectory().path + "/testdemo"
        fun getCurrentNetworkParams(): NetworkParameters {
            return if (networkParams == null) MainNetParams.get() else networkParams!!
        }
        fun getMnemoics(): String {
            var sb = StringBuilder()
            val entropy = ByteArray(Words.TWELVE.byteLength())
            Words.TWELVE.byteLength()
            SecureRandom().nextBytes(entropy)
            MnemonicGenerator(English.INSTANCE).createMnemonic(entropy) { sb.append(it) }
            return sb.toString()
        }

        //创建钱包
        fun createWallet(activity: Activity, passphrase: String): Wallet {
            var wallet: Wallet?

            //password为输入的钱包密码
            var seed: DeterministicSeed? = null
            try {
                seed = DeterministicSeed(Splitter.on(" ").splitToList(getMnemoics()), null, passphrase, MnemonicCode.BIP39_STANDARDISATION_TIME_SECS)
            } catch (e: MnemonicException.MnemonicLengthException) {
                e.printStackTrace()
            }
            wallet = Wallet.fromSeed(getCurrentNetworkParams(), seed, Script.ScriptType.P2PKH)
//            val walletFile = activity.getFileStreamPath("YJYWallet")
//            wallet.saveToFile(walletFile)
//            val walletFiles = wallet.autosaveToFile(walletFile, 3 * 1000, TimeUnit.MILLISECONDS, null)
            return wallet
        }

        fun createWallet(mnemonics: String): Wallet {
            var wallet: Wallet?

            //password为输入的钱包密码
            var seed: DeterministicSeed? = null
            try {
                seed = DeterministicSeed(Splitter.on(" ").splitToList(mnemonics), null, "", MnemonicCode.BIP39_STANDARDISATION_TIME_SECS)
            } catch (e: MnemonicException.MnemonicLengthException) {
                e.printStackTrace()
            }
            wallet = Wallet.fromSeed(getCurrentNetworkParams(), seed, Script.ScriptType.P2PKH)
//            val walletFile = activity.getFileStreamPath("YJYWallet")
//            wallet.saveToFile(walletFile)
//            val walletFiles = wallet.autosaveToFile(walletFile, 3 * 1000, TimeUnit.MILLISECONDS, null)
            return wallet
        }

    }
}