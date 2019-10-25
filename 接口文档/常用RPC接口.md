# htdf常用RPC接口
rpc接口均以http方式调用，本文使用的为ubuntu16.04,访问本地节点,例子均以curl方式调用http服务。当然使用浏览器直接访问同样结果      

****

## cosmos-sdk
****
####  余额查询
  
**方法**：   GET

**url**：   /bank/balances/{address}

**说明**：   {address} 为账户地址

**例子**：  

```
~$ curl http://localhost:1317/bank/balances/htdf1d8walt2k5824v4zxz6wp6n0mk7z6ml7f2mdagn
```

**返回** :

```
[
  {
    "denom": "htdf",
    "amount": "1000000000"
  },
  {
    "denom": "stake",
    "amount": "10000000000000000"
  }
]
```
****
####  查看账户信息
**方法**：   GET    

**url**：    /auth/accounts/{address}

**说明**：   {address} 为账户地址

**例子**：  

```
~$ curl http://localhost:1317/auth/accounts/htdf1d8walt2k5824v4zxz6wp6n0mk7z6ml7f2mdagn
```
**返回** :
```
{
  "type": "auth/Account",
  "value": {
    "address": "htdf1d8walt2k5824v4zxz6wp6n0mk7z6ml7f2mdagn",
    "coins": [
      {
        "denom": "htdf",
        "amount": "1000000000"
      },
      {
        "denom": "stake",
        "amount": "10000000000000000"
      }
    ],
    "public_key": null,
    "account_number": "1",
    "sequence": "0"
  }
}
```
****
####  新建账户
**方法**：   post   

**url**：    /accounts/newaccount
**标注**：   仅限于DEBUG 模式
**说明**：   参数password是为新账户设置的密码

**例子**：  

```
~$ curl -X POST "http://localhost:1317/accounts/newaccount" -H "accept: application/json" -d "{\"password\": \"12345678\"}"
```
**返回** :
```
{"address": "htdf1g9jlhyu07jjm4gfus52l28r29y4m063gmtxcx0"}
```
****
####  查账户列表
**方法**：    GET   

**url**：   /auth/accounts/list

**例子**：  

```
~$curl http://localhost:1317/accounts/list
```
**返回** :
```
Account #0: {htdf1gy5lwx2zmfhk22amuudqu5etlflrdx93r0dmeh}
Account #1: {htdf1d8walt2k5824v4zxz6wp6n0mk7z6ml7f2mdagn}
Account #2: {htdf14ev6dr4y5ms46h8jw8rwmrpnt8wl9clme29am6}
Account #3: {htdf1jduyhyensy5helsezcdpnd8qja5xhgs5cmq5ts}
Account #4: {htdf1xm9g53mc0m0dyj807h2rtxw3y39zq4z0cs0nde}
Account #5: {htdf1g9jlhyu07jjm4gfus52l28r29y4m063gmtxcx0}
```
####  查询最新区块
**方法**：    GET   

**url**：   /blocks/latest

**例子**：  

```
~$curl http://localhost:1317/blocks/latest
```
**返回** :
{
  "block_meta": {
    "block_id": {
      "hash": "9AA37C8011DD1E2046951E36CC41B9FB8273AF79C198C4F4EC1CE97C731A15D4",
      "parts": {
        "total": "1",
        "hash": "0EAD2228A6408EFEEC90780227AFFE4A4867B1AFBA0596E9BFA730C0A8D42803"
      }
    },
    "header": {
      "version": {
        "block": "10",
        "app": "0"
      },
      "chain_id": "testchain",
      "height": "3361",
      "time": "2019-09-20T07:22:19.206881171Z",
      "num_txs": "0",
      "total_txs": "9",
      "last_block_id": {
        "hash": "FE0AB858A88142C5D21929B30ABCB3307225971F4961743D4ABA9AF11765662C",
        "parts": {
          "total": "1",
          "hash": "9DD6A664DCF9E527DF720576FC7D2B4249F0EC9E34E54957DFCC487027B947EE"
        }
      },
      "last_commit_hash": "D15156E590D6C89A8782E32A5EA13889D3724B437F385D2CA5A9EBDFBA9DC462",
      "data_hash": "",
      "validators_hash": "ED2CBAD61C7D2DFD336FF8A49892D9E73F9FE6539B704427C33B4CF1041F72C7",
      "next_validators_hash": "ED2CBAD61C7D2DFD336FF8A49892D9E73F9FE6539B704427C33B4CF1041F72C7",
      "consensus_hash": "048091BC7DDC283F77BFBF91D73C44DA58C3DF8A9CBC867405D8B7F3DAADA22F",
      "app_hash": "5AC57573161FFF216B79A4805BF8454C969DCA8A2DCC1498BD44E343C238B306",
      "last_results_hash": "",
      "evidence_hash": "",
      "proposer_address": "390949686A41E0B186AE52A47732F33B5DE88D3A"
    }
  },
  "block": {
    "header": {
      "version": {
        "block": "10",
        "app": "0"
      },
      "chain_id": "testchain",
      "height": "3361",
      "time": "2019-09-20T07:22:19.206881171Z",
      "num_txs": "0",
      "total_txs": "9",
      "last_block_id": {
        "hash": "FE0AB858A88142C5D21929B30ABCB3307225971F4961743D4ABA9AF11765662C",
        "parts": {
          "total": "1",
          "hash": "9DD6A664DCF9E527DF720576FC7D2B4249F0EC9E34E54957DFCC487027B947EE"
        }
      },
      "last_commit_hash": "D15156E590D6C89A8782E32A5EA13889D3724B437F385D2CA5A9EBDFBA9DC462",
      "data_hash": "",
      "validators_hash": "ED2CBAD61C7D2DFD336FF8A49892D9E73F9FE6539B704427C33B4CF1041F72C7",
      "next_validators_hash": "ED2CBAD61C7D2DFD336FF8A49892D9E73F9FE6539B704427C33B4CF1041F72C7",
      "consensus_hash": "048091BC7DDC283F77BFBF91D73C44DA58C3DF8A9CBC867405D8B7F3DAADA22F",
      "app_hash": "5AC57573161FFF216B79A4805BF8454C969DCA8A2DCC1498BD44E343C238B306",
      "last_results_hash": "",
      "evidence_hash": "",
      "proposer_address": "390949686A41E0B186AE52A47732F33B5DE88D3A"
    },
    "data": {
      "txs": null
    },
    "evidence": {
      "evidence": null
    },
    "last_commit": {
      "block_id": {
        "hash": "FE0AB858A88142C5D21929B30ABCB3307225971F4961743D4ABA9AF11765662C",
        "parts": {
          "total": "1",
          "hash": "9DD6A664DCF9E527DF720576FC7D2B4249F0EC9E34E54957DFCC487027B947EE"
        }
      },
      "precommits": [
        {
          "type": 2,
          "height": "3360",
          "round": "0",
          "block_id": {
            "hash": "FE0AB858A88142C5D21929B30ABCB3307225971F4961743D4ABA9AF11765662C",
            "parts": {
              "total": "1",
              "hash": "9DD6A664DCF9E527DF720576FC7D2B4249F0EC9E34E54957DFCC487027B947EE"
            }
          },
          "timestamp": "2019-09-20T07:22:19.206881171Z",
          "validator_address": "390949686A41E0B186AE52A47732F33B5DE88D3A",
          "validator_index": "0",
          "signature": "sk1EPNmmGGd32N8ubhGSgcavd1PbT9dPNONLeaFiLtOkyBBFjp/giN8e0MdLUz1/ciADDRc4Q5e9GZG58XulBw=="
        }
      ]
    }
  }
}
```
****
****
####  最新区块明细
**方法**：    GET   

**url**：   /block_detail/latest
**标注**：   后续版本实现；
**例子**：  

```
~$curl http://localhost:1317/block_detail/latest
```
**返回** :
```
{
  "block_meta": {
    "block_id": {
      "hash": "188AA5120E7164817FEBA2904ECB1F7EA3A3361D885F0A1F92CEC8BBF3E861BA",
      "parts": {
        "total": "1",
        "hash": "933954CFEEB186A7CBBED26EAC23EC98D097A10E1AE2230220770D2C465160C3"
      }
    },
    "header": {
      "version": {
        "block": "10",
        "app": "0"
      },
      "chain_id": "testchain",
      "height": "4355",
      "time": "2019-08-08T08:59:47.304635192Z",
      "num_txs": "0",
      "total_txs": "0",
      "last_block_id": {
        "hash": "2084857FDFE3452D94F91D87798FA2AE3F2EBF150A131D84EFDEC3482968BA66",
        "parts": {
          "total": "1",
          "hash": "30A83B4574B4C578BFC2FB61880D0CDC71B6D8AB26ACD0D3A0693393794FC3C0"
        }
      },
      "last_commit_hash": "2E645BCBAE7927FF2BD1E63EC514F0B367B8A9E36FAA27DCC57250BE3B4C76BC",
      "data_hash": "",
      "validators_hash": "CF1761357F59F515E321AC59F5A7C868EE16DA76BE4D34781966621272C7549C",
      "next_validators_hash": "CF1761357F59F515E321AC59F5A7C868EE16DA76BE4D34781966621272C7549C",
      "consensus_hash": "048091BC7DDC283F77BFBF91D73C44DA58C3DF8A9CBC867405D8B7F3DAADA22F",
      "app_hash": "CA9B537AD3655B30A70CEC888DD49AD17293D66380A543EBC487A5A93D4F0582",
      "last_results_hash": "",
      "evidence_hash": "",
      "proposer_address": "960C6246D5CFB6C2E5BD40E45831765CCCFB5E64"
    }
  },
  "block": {
    "txs": null,
    "evidence": {
      "evidence": null
    },
    "last_commit": {
      "block_id": {
        "hash": "2084857FDFE3452D94F91D87798FA2AE3F2EBF150A131D84EFDEC3482968BA66",
        "parts": {
          "total": "1",
          "hash": "30A83B4574B4C578BFC2FB61880D0CDC71B6D8AB26ACD0D3A0693393794FC3C0"
        }
      },
      "precommits": [
        {
          "type": 2,
          "height": "4354",
          "round": "0",
          "block_id": {
            "hash": "2084857FDFE3452D94F91D87798FA2AE3F2EBF150A131D84EFDEC3482968BA66",
            "parts": {
              "total": "1",
              "hash": "30A83B4574B4C578BFC2FB61880D0CDC71B6D8AB26ACD0D3A0693393794FC3C0"
            }
          },
          "timestamp": "2019-08-08T08:59:47.304635192Z",
          "validator_address": "960C6246D5CFB6C2E5BD40E45831765CCCFB5E64",
          "validator_index": "0",
          "signature": "sn9U/vJviu7QYvtFk+TmkNhoWULW+mU6W/aBIekQwdf/ibe8AFQK1ECNEr6ZLdomq2YyfLm8onazFSWPuW7uBg=="
        }
      ]
    }
  },
  "time": "2019-08-08 16:59:47" 
}
```
****
 ####  查任意高度区块明细
**方法**：    GET   

**url**：   /block_detail/{height}

**说明**：   height：要查询的区块高度

**例子**：  

```
~$ curl http://localhost:1317/block_detail/100
```
**返回** :
```
{
  "block_meta": {
    "block_id": {
      "hash": "14933AC1EFA3BA1D96E5F7194931A8C078D3498ADFEAD3A6322C17E054B16439",
      "parts": {
        "total": "1",
        "hash": "CBD69AF783CB9286715B08E3616FFD5BB2D1456451E12DDC993F79551B64F9F7"
      }
    },
    "header": {
      "version": {
        "block": "10",
        "app": "0"
      },
      "chain_id": "testchain",
      "height": "100",
      "time": "2019-08-07T06:22:29.796678433Z",
      "num_txs": "0",
      "total_txs": "0",
      "last_block_id": {
        "hash": "EDF8605805CD96438A8C221AD0C712AB4528279F192618B4BCFB55D454BB3121",
        "parts": {
          "total": "1",
          "hash": "70384FBE32273A549703359411E132135BCEB0BAB7EBC3B9BEB8BB80A4114BB0"
        }
      },
      "last_commit_hash": "18F91AA62E1400C2CEB2531B06A9D9051F835F9972FDED8AC792ECE221B3C920",
      "data_hash": "",
      "validators_hash": "CF1761357F59F515E321AC59F5A7C868EE16DA76BE4D34781966621272C7549C",
      "next_validators_hash": "CF1761357F59F515E321AC59F5A7C868EE16DA76BE4D34781966621272C7549C",
      "consensus_hash": "048091BC7DDC283F77BFBF91D73C44DA58C3DF8A9CBC867405D8B7F3DAADA22F",
      "app_hash": "0BADBA2437F499D3ECF77276CEB5782645A7308AE3D5954A9F6230D1BFEEA7D8",
      "last_results_hash": "",
      "evidence_hash": "",
      "proposer_address": "960C6246D5CFB6C2E5BD40E45831765CCCFB5E64"
    }
  },
  "block": {
    "txs": null,
    "evidence": {
      "evidence": null
    },
    "last_commit": {
      "block_id": {
        "hash": "EDF8605805CD96438A8C221AD0C712AB4528279F192618B4BCFB55D454BB3121",
        "parts": {
          "total": "1",
          "hash": "70384FBE32273A549703359411E132135BCEB0BAB7EBC3B9BEB8BB80A4114BB0"
        }
      },
      "precommits": [
        {
          "type": 2,
          "height": "99",
          "round": "0",
          "block_id": {
            "hash": "EDF8605805CD96438A8C221AD0C712AB4528279F192618B4BCFB55D454BB3121",
            "parts": {
              "total": "1",
              "hash": "70384FBE32273A549703359411E132135BCEB0BAB7EBC3B9BEB8BB80A4114BB0"
            }
          },
          "timestamp": "2019-08-07T06:22:29.796678433Z",
          "validator_address": "960C6246D5CFB6C2E5BD40E45831765CCCFB5E64",
          "validator_index": "0",
          "signature": "owJLjORDfrbgSWj8zGsSQXOEaC5uB+M+jTsJsK4G9PEFPA9k8xHoCSW2WCMdPZYtGbc49mF4nZMm2NRkrAiYBA=="
        }
      ]
    }
  },
  "time": "2019-08-07 14:22:29"
}
```
****
####  查看节点信息
**方法**：    GET   

**url**：   /node_info

**例子**：  

```
~$ curl http://localhost:1317/node_info
```
**返回** :
```
{
  "protocol_version": {
    "p2p": "7",
    "block": "10",
    "app": "0"
  },
  "id": "007e8043c33e216643ce96988eaa945b0bd6abb8",
  "listen_addr": "tcp://0.0.0.0:26656",
  "network": "testchain",
  "version": "0.31.5",
  "channels": "4020212223303800",
  "moniker": "htdf_dev_net",
  "other": {
    "tx_index": "on",
    "rpc_address": "tcp://0.0.0.0:26657"
  }
}
```
****
  
####  查看验证节点信息
**方法**：    GET   

**url**：    /validatorsets/latest

**例子**：  

```
~$ curl http://localhost:1317/validatorsets/latest
```
**返回** :
```
{
  "block_height": "4494",
  "validators": [
    {
      "address": "htdfvalcons1jcxxy3k4e7mv9edagrj9svtktnx0khnyqgpc4v",
      "pub_key": "htdfvalconspub1zcjduepqrnpf2jkfrn20rwvwavxut9va36rjxrxrnxz6e3teagnumvzqr0qqrakqmf",
      "proposer_priority": "0",
      "voting_power": "100"
    }
  ]
}
```
****
  ####  转账/创建并发布智能合约
**方法**：    post   

**url**：     /hs/send
**标注**：   仅限于DEBUG 模式;智能合约后续版本实现；
**说明**：   from: 发送者地址，memo：备注， password ：密码，chain_id：链id， account_number：账户编号， sequence：序列号，fees：交易费怎么交，amount：发送者信息， to：接收者地址

**例子 1 转账**：  

```
~$curl -X POST "http://localhost:1317/hs/send" -H "accept: application/json" -H "Content-Type: application/json" -d "{ \"base_req\": { \"from\": \"htdf1r4qym85hmx6ul4tcgcn0xatla86l8ff3uzg5zm\", \"memo\": \"Sent via Cosmos Voyager \",\"password\": \"12345678\", \"chain_id\": \"testchain\", \"account_number\": \"0\", \"sequence\": \"0\", \"gas\": \"0.002\", \"gas_adjustment\": \"1.2\", \"fees\": [ { \"denom\": \"htdf\", \"amount\": \"0.0001\" } ], \"simulate\": false }, \"amount\": [ { \"denom\": \"htdf\", \"amount\": \"0.1\" } ],\"to\": \"htdf1cvkwrsp8nkfevnry93xt2cygtu433q7m6a2hd5\"}"
```
**返回** :
```
{"height":"0","txhash":"0B1B5197C0FAE0C7E0FE12C8767EF4501576E65E2D24B5D813DBDD829FA442E8"}
```
**例子 2 智能合约**：  

```
 curl http://127.0.0.1:1317/hs/send     -H 'Content-Type: application/json'     -X POST     --data '{
                 "base_req": {
                     "from": "htdf1rgvdld8je70yyez34n34tvk6649777lrfuaeey",
                     "memo": "",
                    "password": "12345678",
                     "chain_id": "testchain",
                    "account_number": "0",
                   "sequence": "0",
                   "gas": "40000",
                  "fees": [{
                        "denom": "htdf",
                        "amount": "0.0000002"
                    }],
                    "simulate": false
                 },
                "amount": [{
                     "denom": "htdf",
                    "amount": "0"
                 }],
                 "to": "",
                 "data": "6060604052341561000f57600080fd5b336000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555061042d8061005e6000396000f300606060405260043610610062576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff168063075461721461006757806327e235e3146100bc57806340c10f1914610109578063d0679d341461014b575b600080fd5b341561007257600080fd5b61007a61018d565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b34156100c757600080fd5b6100f3600480803573ffffffffffffffffffffffffffffffffffffffff169060200190919050506101b2565b6040518082815260200191505060405180910390f35b341561011457600080fd5b610149600480803573ffffffffffffffffffffffffffffffffffffffff169060200190919080359060200190919050506101ca565b005b341561015657600080fd5b61018b600480803573ffffffffffffffffffffffffffffffffffffffff16906020019091908035906020019091905050610277565b005b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b60016020528060005260406000206000915090505481565b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff1614151561022557610273565b80600160008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600082825401925050819055505b5050565b80600160003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205410156102c3576103fd565b80600160003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000828254039250508190555080600160008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600082825401925050819055507f3990db2d31862302a685e8086b5755072a6e2b5b780af1ee81ece35ee3cd3345338383604051808473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020018373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001828152602001935050505060405180910390a15b50505600a165627a7a72305820f3c54d8cf0c62d5295ef69e3fc795fa1886b4de4d3d58f50f83c70ed26b99d890029",
                  "gas_price": "0.0000001", 
                 "gas_limit": "90000000000"
             }'
```
**返回** :
```
{
  "height": "0",
  "txhash": "2F7B060935C70BFB474C4A4DDD1692B019CF3DED9A412C2362ABD7E76F31EB59"
}
```
****

  ####  查看交易信息
**方法**：    GET   

**url**：     /transaction/{hash}

**说明**：   {hash}:要查看的交易hash 

**例子**：  

```
~$ curl http://localhost:1317/transaction/30B2D681459610E7BDA731B1009FAFDF5D3080D9E94D15AE245C3A717039075
```
**返回** :
```
{
  "height": "4680",
  "txhash": "30B2D681459610E7BDA731B1009FAFDF5D3080D9E94D15AE245C3A71A7039075",
  "log": [
    {
      "msg_index": "0",
      "success": true,
      "log": ""
    }
  ],
  "gas_wanted": "200000",
  "gas_used": "32970",
  "tags": [
    {
      "key": "action",
      "value": "sendfrom"
    },
    {
      "key": "sender",
      "value": "htdf1d8walt2k5824v4zxz6wp6n0mk7z6ml7f2mdagn"
    },
    {
      "key": "recipient",
      "value": "htdf1g9jlhyu07jjm4gfus52l28r29y4m063gmtxcx0"
    }
  ],
  "tx": {
    "msg": [
      {
        "From": "htdf1d8walt2k5824v4zxz6wp6n0mk7z6ml7f2mdagn",
        "To": "htdf1g9jlhyu07jjm4gfus52l28r29y4m063gmtxcx0",
        "Amount": [
          {
            "denom": "htdf",
            "amount": "10"
          }
        ],
        "Hash": "",
        "Memo": ""
      }
    ],
    "fee": {
      "amount": [
        {
          "denom": "htdf",
          "amount": "20"
        }
      ],
      "gas": "0.002"
    },
    "signatures": [
      {
        "pub_key": {
          "type": "tendermint/PubKeySecp256k1",
          "value": "A0BzWlukxj28cCB0MhN8ioZzPUoF/zkTGBHzb1jDkX1d"
        },
        "signature": "9k3UY5yfSxIVfyPrLoh8C6rrCs/tDHd89kmNwiIEJEhRIbmlTkbnvCN62PuXwEQbNyaTzxGBmPe7U/9nHMteHA=="
      }
    ],
    "memo": "Sent via Cosmos Voyager"
  }
}
```
****



  ####  创建原始交易 / 创建智能合约
**方法**：    post   

**url**：    /hs/create
**标注**：   仅限于DEBUG 模式;智能合约后续版本实现；
**说明**：   参数说明见转账 /hs/send ，返回值：创建原始交易返回就是单纯的一段16进制的代码段

**例子 1 原始交易（raw）**：  

```
~$ curl -X POST "http://localhost:1317/hs/create" -H "accept: application/json" -H "Content-Type: pplication/json" -d "{ \"base_req\": { \"from\": \"htdf1d8walt2k5824v4zxz6wp6n0mk7z6ml7f2mdagn\", \"memo\": \"Sent via Cosmos Voyager \",\"password\": \"12345678\", \"chain_id\": \"testchain\", \"account_number\": \"0\", \"sequence\": \"0\", \"gas\": \"200000\", \"gas_adjustment\": \"1.2\", \"fees\": [ { \"denom\": \"htdf\", \"amount\": \"20\" } ], \"simulate\": false }, \"amount\": [ { \"denom\": \"htdf\", \"amount\": \"10\" } ],\"to\": \"htdf1g9jlhyu07jjm4gfus52l28r29y4m063gmtxcx0\",\"encode\":true}“
```
**返回** :

```
7b2274797065223a22617574682f5374645478222c2276616c7565223a7b226d7367223a5b7b2274797065223a2268746466736572766963652f73656e64222c2276616c7565223a7b2246726f6d223a226874646631643877616c74326b3538323476347a787a367770366e306d6b377a366d6c3766326d6461676e222c22546f223a22687464663165787078706b336b307737637065303630376b75686a6e6d78786c78347174633866637a3775222c22416d6f756e74223a5b7b2264656e6f6d223a227361746f736869222c22616d6f756e74223a2231303030303030303030227d5d7d7d5d2c22666565223a7b22616d6f756e74223a5b7b2264656e6f6d223a227361746f736869222c22616d6f756e74223a2232303030303030303030227d5d2c22676173223a223230303030303030303030303030227d2c227369676e617475726573223a6e756c6c2c226d656d6f223a2253656e742076696120436f736d6f7320566f7961676572227d7d
```
****

**例子 2 创建智能合约（raw）**：  

```
curl http://127.0.0.1:1317/hs/create     -H 'Content-Type: application/json' -X POST  --data '{ "base_req": {"from": "htdf1rgvdld8je70yyez34n34tvk6649777lrfuaeey",  "memo": "",   
 "password": "12345678",   "chain_id": "testchain",      "account_number": "0",    "sequence": "0",  
 "gas": "12345678",   
 "fees": [{  
 "denom": "htdf",  
 "amount": "0.2" 
 }], 
 "simulate": false  
 },  
 "amount": [{ 
 "denom": "htdf",  
 "amount": "0"    
 }],   
 "to": "",
 "data": "6060604052341561000f57600080fd5b336000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555061042d8061005e6000396000f300606060405260043610610062576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff168063075461721461006757806327e235e3146100bc57806340c10f1914610109578063d0679d341461014b575b600080fd5b341561007257600080fd5b61007a61018d565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b34156100c757600080fd5b6100f3600480803573ffffffffffffffffffffffffffffffffffffffff169060200190919050506101b2565b6040518082815260200191505060405180910390f35b341561011457600080fd5b610149600480803573ffffffffffffffffffffffffffffffffffffffff169060200190919080359060200190919050506101ca565b005b341561015657600080fd5b61018b600480803573ffffffffffffffffffffffffffffffffffffffff16906020019091908035906020019091905050610277565b005b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b60016020528060005260406000206000915090505481565b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff1614151561022557610273565b80600160008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600082825401925050819055505b5050565b80600160003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205410156102c3576103fd565b80600160003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000828254039250508190555080600160008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600082825401925050819055507f3990db2d31862302a685e8086b5755072a6e2b5b780af1ee81ece35ee3cd3345338383604051808473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020018373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001828152602001935050505060405180910390a15b50505600a165627a7a72305820f3c54d8cf0c62d5295ef69e3fc795fa1886b4de4d3d58f50f83c70ed26b99d890029",
                 "gas_price": "0.00001", 
                 "gas_limit": "12345699","encode":true
             }'
```
**返回** :

```
7b2274797065223a22617574682f5374645478222c2276616c7565223a7b226d7367223a5b7b2274797065223a2268746466736572766963652f73656e64222c2276616c7565223a7b2246726f6d223a226874646631726776646c64386a6537307979657a33346e333474766b363634393737376c72667561656579222c22546f223a22222c22416d6f756e74223a5b7b2264656e6f6d223a227361746f736869222c22616d6f756e74223a2230227d5d2c2244617461223a2236303630363034303532333431353631303030663537363030303830666435623333363030303830363130313030306138313534383137336666666666666666666666666666666666666666666666666666666666666666666666666666666630323139313639303833373366666666666666666666666666666666666666666666666666666666666666666666666666666666313630323137393035353530363130343264383036313030356536303030333936303030663330303630363036303430353236303034333631303631303036323537363030303335376330313030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030393030343633666666666666666631363830363330373534363137323134363130303637353738303633323765323335653331343631303062633537383036333430633130663139313436313031303935373830363364303637396433343134363130313462353735623630303038306664356233343135363130303732353736303030383066643562363130303761363130313864353635623630343035313830383237336666666666666666666666666666666666666666666666666666666666666666666666666666666631363733666666666666666666666666666666666666666666666666666666666666666666666666666666663136383135323630323030313931353035303630343035313830393130333930663335623334313536313030633735373630303038306664356236313030663336303034383038303335373366666666666666666666666666666666666666666666666666666666666666666666666666666666313639303630323030313930393139303530353036313031623235363562363034303531383038323831353236303230303139313530353036303430353138303931303339306633356233343135363130313134353736303030383066643562363130313439363030343830383033353733666666666666666666666666666666666666666666666666666666666666666666666666666666663136393036303230303139303931393038303335393036303230303139303931393035303530363130316361353635623030356233343135363130313536353736303030383066643562363130313862363030343830383033353733666666666666666666666666666666666666666666666666666666666666666666666666666666663136393036303230303139303931393038303335393036303230303139303931393035303530363130323737353635623030356236303030383039303534393036313031303030613930303437336666666666666666666666666666666666666666666666666666666666666666666666666666666631363831353635623630303136303230353238303630303035323630343036303030323036303030393135303930353035343831353635623630303038303930353439303631303130303061393030343733666666666666666666666666666666666666666666666666666666666666666666666666666666663136373366666666666666666666666666666666666666666666666666666666666666666666666666666666313633333733666666666666666666666666666666666666666666666666666666666666666666666666666666663136313431353135363130323235353736313032373335363562383036303031363030303834373366666666666666666666666666666666666666666666666666666666666666666666666666666666313637336666666666666666666666666666666666666666666666666666666666666666666666666666666631363831353236303230303139303831353236303230303136303030323036303030383238323534303139323530353038313930353535303562353035303536356238303630303136303030333337336666666666666666666666666666666666666666666666666666666666666666666666666666666631363733666666666666666666666666666666666666666666666666666666666666666666666666666666663136383135323630323030313930383135323630323030313630303032303534313031353631303263333537363130336664353635623830363030313630303033333733666666666666666666666666666666666666666666666666666666666666666666666666666666663136373366666666666666666666666666666666666666666666666666666666666666666666666666666666313638313532363032303031393038313532363032303031363030303230363030303832383235343033393235303530383139303535353038303630303136303030383437336666666666666666666666666666666666666666666666666666666666666666666666666666666631363733666666666666666666666666666666666666666666666666666666666666666666666666666666663136383135323630323030313930383135323630323030313630303032303630303038323832353430313932353035303831393035353530376633393930646232643331383632333032613638356538303836623537353530373261366532623562373830616631656538316563653335656533636433333435333338333833363034303531383038343733666666666666666666666666666666666666666666666666666666666666666666666666666666663136373366666666666666666666666666666666666666666666666666666666666666666666666666666666313638313532363032303031383337336666666666666666666666666666666666666666666666666666666666666666666666666666666631363733666666666666666666666666666666666666666666666666666666666666666666666666666666663136383135323630323030313832383135323630323030313933353035303530353036303430353138303931303339306131356235303530353630306131363536323761376137323330353832306633633534643863663063363264353239356566363965336663373935666131383836623464653464336435386635306638336337306564323662393964383930303239222c22476173223a223132333435363738222c224761735072696365223a2231303030222c224761734c696d6974223a223132333435363939227d7d5d2c22666565223a7b22616d6f756e74223a5b7b2264656e6f6d223a227361746f736869222c22616d6f756e74223a223230303030303030227d5d2c22676173223a223132333435363738227d2c227369676e617475726573223a6e756c6c2c226d656d6f223a22227d7d
```
****

  ####  对 原始交易/原始智能合约 进行签名
**方法**：    post   

**url**：    /hs/sign
**标注**：   仅限于DEBUG 模式
**说明**：    参数“tx”：由创建原始交易返回的16进制代码段，“passphrase”：账户密码，返回：同样是一段16进制代码，只是加入了签名信息

**例子**：  

```
curl -X POST "http://localhost:1317/hs/sign" -H "accept: application/json" -H "Content-Type: application/json" -d "{\"tx\":\"7b2274797065223a22617574682f5374645478222c2276616c7565223a7b226d7367223a5b7b2274797065223a2268746466736572766963652f73656e64222c2276616c7565223a7b2246726f6d223a22687464663165787078706b336b307737637065303630376b75686a6e6d78786c78347174633866637a3775222c22546f223a226874646631787774713775326d6b68793935677576786d3473326879306561307061726c796a74756c6736222c22416d6f756e74223a5b7b2264656e6f6d223a227361746f736869222c22616d6f756e74223a2231303030303030303030227d5d7d7d5d2c22666565223a7b22616d6f756e74223a5b7b2264656e6f6d223a227361746f736869222c22616d6f756e74223a2232303030303030303030227d5d2c22676173223a223230303030303030303030303030227d2c227369676e617475726573223a6e756c6c2c226d656d6f223a2253656e742076696120436f736d6f7320566f7961676572227d7d\", \"passphrase\":\"12345678\",\"offline\":false,\"encode\":true}"
```
**返回** :
```
7b0a20202274797065223a2022617574682f5374645478222c0a20202276616c7565223a207b0a20202020226d7367223a205b0a2020202020207b0a20202020202020202274797065223a202268746466736572766963652f73656e64222c0a20202020202020202276616c7565223a207b0a202020202020202020202246726f6d223a2022687464663165787078706b336b307737637065303630376b75686a6e6d78786c78347174633866637a3775222c0a2020202020202020202022546f223a20226874646631787774713775326d6b68793935677576786d3473326879306561307061726c796a74756c6736222c0a2020202020202020202022416d6f756e74223a205b0a2020202020202020202020207b0a20202020202020202020202020202264656e6f6d223a20227361746f736869222c0a202020202020202020202020202022616d6f756e74223a202231303030303030303030220a2020202020202020202020207d0a202020202020202020205d0a20202020202020207d0a2020202020207d0a202020205d2c0a2020202022666565223a207b0a20202020202022616d6f756e74223a205b0a20202020202020207b0a202020202020202020202264656e6f6d223a20227361746f736869222c0a2020202020202020202022616d6f756e74223a202232303030303030303030220a20202020202020207d0a2020202020205d2c0a20202020202022676173223a20223230303030303030303030303030220a202020207d2c0a20202020227369676e617475726573223a205b0a2020202020207b0a2020202020202020227075625f6b6579223a207b0a202020202020202020202274797065223a202274656e6465726d696e742f5075624b6579536563703235366b31222c0a202020202020202020202276616c7565223a2022417774656833714255664630304855796450722b78326f354c79676c4f5a2f4e36372b414c66685a7a4e7672220a20202020202020207d2c0a2020202020202020227369676e6174757265223a20224c38684b56454f467435586a4c754770496939503533496b4f4d66593064516f4e786532656d397945534e70334a476a747767365a61733261576954716f556b4a763659446d33524e4a4d592f2b37424c76346c56413d3d220a2020202020207d0a202020205d2c0a20202020226d656d6f223a202253656e742076696120436f736d6f7320566f7961676572220a20207d0a7d
```
****
  ####  广播签名后的原始交易 --上链
**方法**：    post   

**url**：     /hs/broadcast 

**说明**：    参数“tx”：签名之后的原始交易16进制返回值

**例子**：  

```
~$ curl -X POST "http://localhost:1317/hs/broadcast" -H "accept: aplication/json" -H "Content-Type: application/json" -d "{\"tx\":\"7b0a20202274797065223a2022617574682f5374645478222c0a20202276616c7565223a207b0a20202020226d7367223a205b0a2020202020207b0a20202020202020202274797065223a202268746466736572766963652f73656e64222c0a20202020202020202276616c7565223a207b0a202020202020202020202246726f6d223a2022687464663165787078706b336b307737637065303630376b75686a6e6d78786c78347174633866637a3775222c0a2020202020202020202022546f223a20226874646631787774713775326d6b68793935677576786d3473326879306561307061726c796a74756c6736222c0a2020202020202020202022416d6f756e74223a205b0a2020202020202020202020207b0a20202020202020202020202020202264656e6f6d223a20227361746f736869222c0a202020202020202020202020202022616d6f756e74223a202231303030303030303030220a2020202020202020202020207d0a202020202020202020205d0a20202020202020207d0a2020202020207d0a202020205d2c0a2020202022666565223a207b0a20202020202022616d6f756e74223a205b0a20202020202020207b0a202020202020202020202264656e6f6d223a20227361746f736869222c0a2020202020202020202022616d6f756e74223a202232303030303030303030220a20202020202020207d0a2020202020205d2c0a20202020202022676173223a20223230303030303030303030303030220a202020207d2c0a20202020227369676e617475726573223a205b0a2020202020207b0a2020202020202020227075625f6b6579223a207b0a202020202020202020202274797065223a202274656e6465726d696e742f5075624b6579536563703235366b31222c0a202020202020202020202276616c7565223a2022417774656833714255664630304855796450722b78326f354c79676c4f5a2f4e36372b414c66685a7a4e7672220a20202020202020207d2c0a2020202020202020227369676e6174757265223a20224c38684b56454f467435586a4c754770496939503533496b4f4d66593064516f4e786532656d397945534e70334a476a747767365a61733261576954716f556b4a763659446d33524e4a4d592f2b37424c76346c56413d3d220a2020202020207d0a202020205d2c0a20202020226d656d6f223a202253656e742076696120436f736d6f7320566f7961676572220a20207d0a7d\"}"
```
**返回** :
```
{
  "height": "0",
  "txhash": "9538E311F3CACD94749D60721A3B5460E35C86FB3AEBB66778A3A980E3DD1925"
}
```
****
  ####  指定账户一定高度上的相关交易
**方法**：    post   

**url**：     /accounts/transactions 

**说明**：    参数“address”：指定的账户地址，“fromHeight” ：起始高度，“endHeight”：结束高度。若“fromHeight”“endHeight” 全为0,则，查询指定账户地址近1000个块范围内相关交易

**例子**：  

```
~$ curl -X POST "http://localhost:1317/accounts/transactions" -H "accept: application/json" -d "{\"address\": \"htdf1d8walt2k5824v4zxz6wp6n0mk7z6ml7f2mdagn\",\"fromHeight\":100,\"endHeight\":1000,\"Flag\":0}"
```

**返回** :
```
{
  "ChainHeight": "5745",
  "FromHeight": "100",
  "EndHeight": "1000",
  "ArrTx": null
}
````
****

## tendermint
  tendermint的端口和cosmos-sdk不一样需要注意
  ****
####  状态
**方法**：    GET 

**url**：     /status

**例子**：  

```
~$curl http://localhost:26657/status
```
**返回** :
```
{
  "jsonrpc": "2.0",
  "id": "",
  "result": {
    "node_info": {
      "protocol_version": {
        "p2p": "7",
        "block": "10",
        "app": "0"
      },
      "id": "007e8043c33e216643ce96988eaa945b0bd6abb8",
      "listen_addr": "tcp://0.0.0.0:26656",
      "network": "testchain",
      "version": "0.31.5",
      "channels": "4020212223303800",
      "moniker": "htdf_dev_net",
      "other": {
        "tx_index": "on",
        "rpc_address": "tcp://0.0.0.0:26657"
      }
    },
    "sync_info": {
      "latest_block_hash": "0E76BE3052BA472579EDC9D9D931C3919F78D40265B3D2E4928508271F595B64",
      "latest_app_hash": "CF65AF3BDD7357FD7A9EB77B675AFA4929367BE671708B440904761E6ABBCF69",
      "latest_block_height": "4877",
      "latest_block_time": "2019-08-08T09:43:24.24609424Z",
      "catching_up": false
    },
    "validator_info": {
      "address": "960C6246D5CFB6C2E5BD40E45831765CCCFB5E64",
      "pub_key": {
        "type": "tendermint/PubKeyEd25519",
        "value": "HMKVSskc1PG5jusNxZWdjocjDMOZhazFeeonzbBAG8A="
      },
      "voting_power": "100"
    }
  }
}
```
****
  ####  验证者
**方法**：    GET 

**url**：     /validators

**例子**： 

```
~$curl http://localhost:26657/validators
```
**返回** :
```
{
  "jsonrpc": "2.0",
  "id": "",
  "result": {
    "block_height": "5070",
    "validators": [
      {
        "address": "960C6246D5CFB6C2E5BD40E45831765CCCFB5E64",
        "pub_key": {
          "type": "tendermint/PubKeyEd25519",
          "value": "HMKVSskc1PG5jusNxZWdjocjDMOZhazFeeonzbBAG8A="
        },
        "voting_power": "100",
        "proposer_priority": "0"
      }
    ]
  }
}
```
****
  ####  导出共识规定
**方法**：    GET 

**url**：     /dump_consensus_state

**例子**：  

```
~$curl http://localhost:26657/dump_consensus_state
```
**返回** :
```
{
  "jsonrpc": "2.0",
  "id": "",
  "result": {
    "round_state": {
      "height": "5113",
      "round": "0",
      "step": 1,
      "start_time": "2019-08-08T10:03:12.422187231Z",
      "commit_time": "2019-08-08T10:03:07.422187231Z",
      "validators": {
        "validators": [
          {
            "address": "960C6246D5CFB6C2E5BD40E45831765CCCFB5E64",
            "pub_key": {
              "type": "tendermint/PubKeyEd25519",
              "value": "HMKVSskc1PG5jusNxZWdjocjDMOZhazFeeonzbBAG8A="
            },
            "voting_power": "100",
            "proposer_priority": "0"
          }
        ],
        "proposer": {
          "address": "960C6246D5CFB6C2E5BD40E45831765CCCFB5E64",
          "pub_key": {
            "type": "tendermint/PubKeyEd25519",
            "value": "HMKVSskc1PG5jusNxZWdjocjDMOZhazFeeonzbBAG8A="
          },
          "voting_power": "100",
          "proposer_priority": "0"
        }
      },
      "proposal": null,
      "proposal_block": null,
      "proposal_block_parts": null,
      "locked_round": "-1",
      "locked_block": null,
      "locked_block_parts": null,
      "valid_round": "-1",
      "valid_block": null,
      "valid_block_parts": null,
      "votes": [
        {
          "round": "0",
          "prevotes": [
            "nil-Vote"
          ],
          "prevotes_bit_array": "BA{1:_} 0/100 = 0.00",
          "precommits": [
            "nil-Vote"
          ],
          "precommits_bit_array": "BA{1:_} 0/100 = 0.00"
        }
      ],
      "commit_round": "-1",
      "last_commit": {
        "votes": [
          "Vote{0:960C6246D5CF 5112/00/2(Precommit) E54D048BC8D6 00A8376F0B9B @ 2019-08-08T10:03:07.419583284Z}"
        ],
        "votes_bit_array": "BA{1:x} 100/100 = 1.00",
        "peer_maj_23s": {}
      },
      "last_validators": {
        "validators": [
          {
            "address": "960C6246D5CFB6C2E5BD40E45831765CCCFB5E64",
            "pub_key": {
              "type": "tendermint/PubKeyEd25519",
              "value": "HMKVSskc1PG5jusNxZWdjocjDMOZhazFeeonzbBAG8A="
            },
            "voting_power": "100",
            "proposer_priority": "0"
          }
        ],
        "proposer": {
          "address": "960C6246D5CFB6C2E5BD40E45831765CCCFB5E64",
          "pub_key": {
            "type": "tendermint/PubKeyEd25519",
            "value": "HMKVSskc1PG5jusNxZWdjocjDMOZhazFeeonzbBAG8A="
          },
          "voting_power": "100",
          "proposer_priority": "0"
        }
      },
      "triggered_timeout_precommit": false
    },
    "peers": []
  }
}
```
****
  ####  未验证tx数量
**方法**：    GET 

**url**：     /num_unconfirmed_txs

**例子**：  

```
~$curl http://localhost:26657/num_unconfirmed_txs
```
**返回** :
```
{
  "jsonrpc": "2.0",
  "id": "",
  "result": {
    "n_txs": "0",
    "total": "0",
    "total_bytes": "0",
    "txs": null
  }
}
```
****
  ####  未验证tx
**说明**：    若没有未验证的tx 则 “txs” 字段为空

**方法**：    GET 

**url**：    /unconfirmed_txs

**例子**：  

```
~$curl http://localhost:26657/unconfirmed_txs
```
**返回** :
```
{
  "jsonrpc": "2.0",
  "id": "",
  "result": {
    "n_txs": "0",
    "total": "0",
    "total_bytes": "0",
    "txs": []
  }
}
```


