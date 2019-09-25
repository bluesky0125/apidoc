<?php
/**
 * Title：交易Demo
 * Author：何梓凡
 * Description：支持secp256k1签名，转账，私钥获取公钥
 * Time：2019/09/25
 */

define('HZF',str_replace('\\','/',__DIR__));
//引入第三方类库
require_once HZF."/vendor/autoload.php";

use Mdanter\Ecc\EccFactory;

//打印报错信息
$whoops = new \Whoops\Run;
$errorTitle = '程序出错了';
$option = new \Whoops\Handler\PrettyPageHandler();
$option->setPageTitle($errorTitle);
$whoops->pushHandler($option);
$whoops->register();
ini_set('display_error', 'on');

class EthDemo{
    // 1、创建合约、合约签名
    private static $GAS = "200000"; // 默认值
    private static $FEE = "20"; // 默认值
    private $PRIVATE_KEY = "485de9a2ee4ed834272389617da915da9176bd5281ec5d261256e15be0c375f2"; // 付款方私钥


    /**
     * 获取数据 
     * @param string
     * @param string
     * @param string
     * @return string
     * */
    public function http_curl($url,$content='',$type='get'){
        if($type=='post'){
            $ch = curl_init();
            curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE); 
            curl_setopt($ch, CURLOPT_POST, TRUE); 
            curl_setopt($ch, CURLOPT_POSTFIELDS, $content); 
            curl_setopt($ch, CURLOPT_URL, $url);
            $ret = curl_exec($ch);
            curl_close($ch);
        }else{
            // 1. 初始化
            $ch = curl_init();
            // 2. 设置选项，包括URL
            curl_setopt($ch,CURLOPT_URL,$url);
            curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE); 
            curl_setopt($ch,CURLOPT_HEADER,0);
            // 3. 执行并获取HTML文档内容
            $ret = curl_exec($ch);
            // 4. 释放curl句柄
            curl_close($ch);
        }
        return $ret;
    }


    /**
     * 获取地址详情
     * @param string
     * @return array
     */
    public function getAddress($userhash,$ip){
        $url =  $ip.'/auth/accounts/'.$userhash;
        $data = json_decode($this->http_curl($url),true);
        return $data;
    }  

    /**
     * 广播交易（离线广播，常用）
     * @param tx 广播需要的tx
     */
    public function tradeBroadcast($tx,$ip){
        $url =  $ip.'/hs/broadcast';
        $content = json_encode(array(
            'tx' => bin2hex($tx)
        ));
        $data = json_decode($this->http_curl($url,$content,'post'),true);
        return $data;
    }

    /**
     * 椭圆曲线加密算法签名
     * @param str 待签名字符串
     */
    public function ecsign($str){
        $secp256k1 = new \kornrunner\Secp256k1();
        // message and privateKey are hex strings
        $signature = $secp256k1->sign(hash('sha256',$str), $this->PRIVATE_KEY);
        // encode to hex
        $serializer = new \kornrunner\Serializer\HexSignatureSerializer();
        $signatureString = $serializer->serialize($signature);
        //十六进制转字符串
        return base64_encode(hex2bin($signatureString));
    }

    /**
     * Hex Decode
     * @param    string $hex
     * @return    int
     */
    public static function hex_decode($hex){
        return gmp_init($hex, 16);
    }

    /**
     * 私钥推出公钥
     * @param privateKey 私钥
     */
    public function privateToPublic($privateKey){
        $math = EccFactory::getAdapter();
        $g = EccFactory::getSecgCurves($math)->generator256k1();
        //转换为GMP对象
        $privKey = self::hex_decode($privateKey);
        $secretG = $g->mul($privKey);
        $r = $secretG->getX();
        $s = $secretG->getY();
        $xHex = str_pad(gmp_strval($r, 16), 64, '0', STR_PAD_LEFT);
        $yHex = str_pad(gmp_strval($s, 16), 64, '0', STR_PAD_LEFT);
        $public_key = '03' . $xHex . $yHex;
        $x_hex = substr($public_key, 2, 64);
        $y = $math->hexDec(substr($public_key, 66, 64));
        $parity = $math->mod(self::hex_decode($y), self::hex_decode(2));
        $publicKey = (($parity == 0) ? '02' : '03') . $x_hex;
        //十六进制转字符串
        return base64_encode(hex2bin($publicKey));
    }

    /**
     *  运行
     * @param 付款方 from
     * @param 收款方 to
     * @param 转账数量 amount
     */
    public function Run(){
        $from = "htdf1jrh6kxrcr0fd8gfgdwna8yyr9tkt99ggmz9ja2";
        $to = "htdf1s6regu46mryfgjskxzfncuzcaj7za4uv2dsqta";
        $amount = '1';
        //获取from地址详情
        $data = $this->getAddress($from,"118.190.245.246:1317");
        if(isset($data['error'])){
            dd($data['error']);
        }
        //生成待签名字符串
        $beforeSignJson = json_encode(array(
            "account_number" => $data['value']['account_number'],
            "chain_id" => "testchain",
            "fee" => array(
                "amount" => [array(
                    "amount" => self::$FEE,
                    "denom" => "satoshi"
                )],
                "gas" => self::$GAS
            ),
            "memo" => "",
            "msgs" => [[
                "Amount" => [[
                    "amount" => $amount,
                    "denom" => "satoshi"
                ]],
                "From" => $from,
                "To" => $to
            ]],
            "sequence" => $data['value']['sequence']
        ));
        //椭圆曲线加密算法签名
        $sign64Str = $this->ecsign($beforeSignJson);

        //私钥推出公钥
        $publicKey = $this->privateToPublic($this->PRIVATE_KEY);
        // 2、构建广播数据
        $signJson = json_encode(array(
            "type" => "auth/StdTx",
            "value" => [
                "msg" => [[
                    "type" => "htdfservice/send",
                    "value" => [
                        "From" => $from,
                        "To" => $to,
                        "Amount" => [[
                            "denom" => "satoshi",
                            "amount" => $amount
                        ]]
                    ]
                ]],
                "fee" => [
                    "amount" => [[
                        "denom" => "satoshi",
                        "amount" => self::$FEE
                    ]],
                    "gas" => self::$GAS
                ],
                "signatures" => [[
                    "pub_key" => [
                        "type" => "tendermint/PubKeySecp256k1",
                        "value" => $publicKey
                    ],
                    "signature" => $sign64Str
                ]],
                "memo" => ""
            ]
        ));
        //广播交易（离线广播，常用）
        $res = $this->tradeBroadcast($signJson,"118.190.245.246:1317");
        if(!isset($res['txhash'])){
            dd($res);
        }
        echo "广播成功！txhash：".$res['txhash'].PHP_EOL;
    }
}

//运行程序
$eth = new EthDemo();
$eth->Run();