// 依赖引入
import axios from 'axios'
const ethereumjsUtil1 = require('ethereumjs-util')
const bech32 = require('bech32')
const RIPEMD160 = require('ripemd160')
const bitcoinLib = require('bitcoinjs-lib')

// 1、创建合约、合约签名
const GAS = 200000 // 默认值
const FEE = 20 // 默认值
const FROM = 'htdf1jrh6kxrcr0fd8gfgdwna8yyr9tkt99ggmz9ja2' // 付款方
const PRIVATE_KEY = '485de9a2ee4ed834272389617da915da9176bd5281ec5d261256e15be0c375f2' // 付款方私钥
const PRIVATE_KEY_HEX = Buffer.from(
  PRIVATE_KEY,
  'hex'
)
const TO = 'htdf1s6regu46mryfgjskxzfncuzcaj7za4uv2dsqta' // 收款方
const AMOUNT = 1 // 转账数量

/**
 *
 * @param {uint8 to string} arr
 */
const uint8ToStr = (arr) => {
  return String.fromCharCode(...arr)
}

/**
 *
 * @param {string to hex} str
 */
const stringToHex = (str) => {
  var val = ''
  for (var i = 0; i < str.length; i++) {
    if (val === '') {
      val = str.charCodeAt(i).toString(16) // 获取字符的Unicode码然后转16进制
    } else {
      val += str.charCodeAt(i).toString(16) // 获取字符的Unicode码然后转16进制再拼接,中间用逗号隔开
    }
  }
  return val
}

/**
 *
 * @param {需要签名字符串} str
 */
const ecsign = (str) => {
  const sha256 = ethereumjsUtil1.sha256(str)
  const signB = ethereumjsUtil1.ecsign(sha256, PRIVATE_KEY_HEX)
  const sign64 = Buffer.concat([signB.r, signB.s])
  const sign64Str = window.btoa(uint8ToStr(sign64))
  console.log('签名后string:', sign64Str)
  return sign64Str
}
/**
 * pub to address
 * private:'9900ef98d7e0cab2d0dd70f9594b2e2d89820f6ba9a4b08f698ff8cea135cfe5'
 * pub: '02969e61c6638ef41e4c21ed6b81c7ad9a1d876fe049eaba2556e0890fcae5d049'
 * addr:'htdf123e5e37s0rmfcr9akuju3kzu7vt4h2ys5uxkfl'
 * @param {公钥} pub
 */
let pub = '02969e61c6638ef41e4c21ed6b81c7ad9a1d876fe049eaba2556e0890fcae5d049'
const pubToAddr = (pub) => {
  let myPublicKey = Buffer.from(pub, 'hex')
  let publicKey256 = ethereumjsUtil1.sha256(myPublicKey)
  let publicKey160 = new RIPEMD160().update(publicKey256).digest()
  let HTDFAddress = bech32.encode('htdf', bech32.toWords(publicKey160))
  return HTDFAddress
}
console.log('pub to address:', pubToAddr(pub))

const privateKeyToPub = (key) => {
  if (!key) return
  const privateKeyHex = Buffer.from(
    key,
    'hex'
  )
  let myPublicKey = bitcoinLib.ECPair.fromPrivateKey(privateKeyHex).publicKey
  console.log('公钥base64:', window.btoa(uint8ToStr(myPublicKey)))
  return window.btoa(uint8ToStr(myPublicKey))
}

const PUBLICE_KEY = privateKeyToPub(PRIVATE_KEY) // 付款方公钥

/**
 *
 * @param {付款方} from
 * @param {收款方} to
 * @param {转账数量} amount
 */
const Transfer = async (from = FROM, to = TO, amount = AMOUNT) => {
  const { data } = await axios.get(`http://${window.location.hostname}:3000/auth/accounts?from=` + FROM)
  // console.log('resAccount:', JSON.parse(data))
  let resJson = null
  try {
    resJson = JSON.parse(data)
  } catch (error) {
    alert('获取账户信息失败')
    return
  }
  let accountNumber = resJson.value['account_number']
  let sequence = resJson.value.sequence
  console.log(`accountNumber:${accountNumber}, sequence: ${sequence}`)
  let beforeSignJson = `{
    "account_number": "${accountNumber}",
    "chain_id": "testchain",
    "fee": {
      "amount": [{
        "amount": "${FEE}",
        "denom": "satoshi"
      }],
      "gas": "${GAS}"
    },
    "memo": "",
    "msgs": [{
      "Amount": [{
        "amount": "${amount}",
        "denom": "satoshi"
      }],
      "From": "${from}",
      "To": "${to}"
    }],
    "sequence": "${sequence}"
  }`

  const beforeSignJsonStr = beforeSignJson.replace(/\s/g, '')
  console.log(`需签名字符串: ${beforeSignJsonStr}`)
  const sign64Str = ecsign(beforeSignJsonStr)

  // 2、构建广播数据
  let signJson = `{
    "type": "auth/StdTx",
    "value": {
      "msg": [{
        "type": "htdfservice/send",
        "value": {
          "From": "${from}",
          "To": "${to}",
          "Amount": [{
            "denom": "satoshi",
            "amount": "${amount}"
          }]
        }
      }],
      "fee": {
        "amount": [{
          "denom": "satoshi",
          "amount": "${FEE}"
        }],
        "gas": "${GAS}"
      },
      "signatures": [{
        "pub_key": {
          "type": "tendermint/PubKeySecp256k1",
          "value": "${PUBLICE_KEY}"
        },
        "signature": "${sign64Str}"
      }],
      "memo": ""
    }
  }`

  // 3、合约的广播
  const signJsonStr = signJson.replace(/\s/g, '')
  const tx = stringToHex(signJsonStr)
  console.log('广播需要的tx: ', tx)
  const res = await axios.post(`http://${window.location.hostname}:3000/hs/broadcast`, {tx})
  if (res.data.error) {
    console.log('Error:', res.data.error)
    return 'Error:' + res.data.error
  } else {
    console.log('txhash: ', res.data.txhash)
    return 'Tx Hash: ' + res.data.txhash
  }
}

export default Transfer
