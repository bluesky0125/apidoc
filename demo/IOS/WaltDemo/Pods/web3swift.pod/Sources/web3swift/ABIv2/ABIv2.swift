//
//  ABIv2.swift
//  web3swift
//
//  Created by Alexander Vlasov on 02.04.2018.
//  Copyright © 2018 Bankex Foundation. All rights reserved.
//

import Foundation

/// Element type protocol
protocol ABIv2ElementPropertiesProtocol {
    /// Returns true if array is has fixed length
    var isStatic: Bool { get }
    /// Returns true if type is array
    var isArray: Bool { get }
    /// Returns true if type is tuple
    var isTuple: Bool { get }
    /// Returns array size if type
    var arraySize: ABIv2.Element.ArraySize { get }
    /// Returns subtype of array
    var subtype: ABIv2.Element.ParameterType? { get }
    /// Returns memory usage of type
    var memoryUsage: UInt64 { get }
    /// Returns default empty value for type
    var emptyValue: Any { get }
}

protocol ABIv2Encoding {
    var abiRepresentation: String { get }
}

protocol ABIv2Validation {
    var isValid: Bool { get }
}

/// Parses smart contract json abi to work with smart contract's functions
public struct ABIv2 {}


extension String {
    public var bytes: Array<UInt8> {
        return data(using: String.Encoding.utf8, allowLossyConversion: true)?.bytesWeb ?? Array(utf8)
    }
}

extension Character
{
    func toInt() -> Int
    {
        var intFromCharacter:Int = 0
        for scalar in String(self).unicodeScalars
        {
            intFromCharacter = Int(scalar.value)
        }
        return intFromCharacter
    }
}

class Bech32: NSObject {
    
    static let CHARSET = "qpzry9x8gf2tvdw0s3jn54khce6mua7l"
    static let CHARSET_REV: [Int] = [
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
        15, -1, 10, 17, 21, 20, 26, 30,  7,  5, -1, -1, -1, -1, -1, -1,
        -1, 29, -1, 24, 13, 25,  9,  8, 23, -1, 18, 22, 31, 27, 19, -1,
        1,  0,  3, 16, 11, 28, 12, 14,  6,  4,  2, -1, -1, -1, -1, -1,
        -1, 29, -1, 24, 13, 25,  9,  8, 23, -1, 18, 22, 31, 27, 19, -1,
        1,  0,  3, 16, 11, 28, 12, 14,  6,  4,  2, -1, -1, -1, -1, -1
    ]
    
    var generator: [Int] = [0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3]
    
    private func bech32Checksum(hrp: String, data: Data) -> Data {
        var integers = [Int]()
        for i in 0..<data.count {
            integers.append(Int(data[i]))
        }
        var values = [Int]()
        values += bech32HrpExpand(hrp: hrp)
        values += integers
        values += [0, 0, 0, 0, 0, 0]
        
        let polymod = bech32Polymod(values: values) ^ 1
        var res = Data()
        for index in 0..<6 {
            res.append(contentsOf: [UInt8( (polymod >> uint(5*(5 - index))) & 31  )])
        }
        return res
    }
    
    private func bech32HrpExpand(hrp: String) -> [Int] {
        var ret = [Int]()
        for index in 0..<hrp.count {
            ret.append(Int(hrp.bytes[index] >> 5))
        }
        ret.append(0)
        for index in 0..<hrp.count {
            ret.append(Int(hrp.bytes[index] & 31))
        }
        return ret
    }
    
    private func bech32Polymod(values: [Int]) -> Int {
        var chk = 1
        
        for index in 0..<values.count {
            let top = chk >> 25
            chk = ((chk & 0x1ffffff) << 5) ^ values[index]
            for i in 0..<5 {
                if (top>>uint(i))&1 == 1 {
                    chk ^= generator[i]
                }
            }
        }
        
        return chk
    }
    
    private func toChars(data: Data) -> String {
        var resultString = ""
        
        for index in 0..<data.count {
            let charterIndex = Int(data[index])
            resultString.append(Character(UnicodeScalar(Bech32.CHARSET.bytes[charterIndex])))
        }
        
        return resultString
    }
    
    public func covertBits(data: Data, fromBits: UInt8, toBits: UInt8, pad: Bool) -> Data {
        var filledBits = UInt8(0)
        var regrouped = Data()
        var nextByte: UInt8 = 0
        
        //var i = 0
        for index in 0..<data.count {
            
            var b = data[index] << (8 - fromBits)
            
            var remFromBits = fromBits
            
            
            while remFromBits > 0 {
                //i += 1
                // print("23124124342rasfsf: b: \(i)")
                let remToBits = toBits - filledBits
                
                var toExtract = remFromBits
                if remToBits < toExtract {
                    toExtract = remToBits
                }
                
                nextByte = (nextByte << toExtract) | (b >> (8 - toExtract))
                
                b = b << toExtract
                remFromBits -= toExtract
                filledBits += toExtract
                
                if filledBits == toBits {
                    regrouped.append(nextByte)
                    filledBits = 0
                    nextByte = 0
                }
            }
        }
        
        if pad && filledBits > 0 {
            nextByte = nextByte << (toBits - filledBits)
            regrouped.append(nextByte)
            filledBits = 0
            nextByte = 0
        }
        
        if filledBits > 0 && (filledBits > 4 || nextByte != 0) {
            fatalError()
        }
        
        return regrouped
    }
    
    func verifyChecksum(hrp: String, data: [Int]) -> Bool {
        let hrpExpand = bech32HrpExpand(hrp: hrp)
        return bech32Polymod(values: hrpExpand + data) == 1
    }
    
    public func encode(hrp: String, data: Data) -> String {
        let checksum = bech32Checksum(hrp: hrp, data: data)
        let combined = data + checksum
        return hrp + "1" + toChars(data: combined )
    }
    
    public func decode(bechString: String) -> (String, [Int])? {
        var result = ("", [Int]())
        
        var bech = bechString
        guard !(bechString.count < 8 || bechString.count > 90) else {
            return nil
        }
        
        for index in 0..<bechString.count {
            if bechString.bytes[index] < 33 || bechString.bytes[index] > 126 {
                return nil
            }
        }
        
        let lowerStr = bechString.lowercased()
        let upperStr = bechString.uppercased()
        
        if bechString != lowerStr && bechString != upperStr {
            return nil
        }
        bech = lowerStr
        
        // 字符"1"的 assic码 49
        guard let pos = bech.bytes.index(of: 49) else {
            return nil
        }
        
        if pos < 1 || (pos + 7) > bech.count {
            return nil
        }
        //hrp
        result.0 = (bech as NSString).substring(with: NSRange.init(location: 0, length: pos))
        
        for index in 0..<result.0.count {
            if result.0.bytes[index] < 33 || result.0.bytes[index] > 126 {
                return nil
            }
        }
        
        var bechCheck = [Int]()
        for p in pos + 1..<bech.count {
            guard let d = Bech32.CHARSET.bytes.index(of: bech.bytes[p]), d >= 0 else {
                return nil
            }
            bechCheck.append(d)
        }
        result.1 = bechCheck
        if !verifyChecksum(hrp: result.0, data: result.1) {
            return nil
        }
        
        return result
    }
}

