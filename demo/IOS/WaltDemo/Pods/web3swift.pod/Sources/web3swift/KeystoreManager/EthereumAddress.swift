//
//  Address.swift
//  web3swift
//
//  Created by Alexander Vlasov on 07.01.2018.
//  Copyright © 2018 Bankex Foundation. All rights reserved.
//

import BigInt
import Foundation

/// Address error
public enum AddressError: Error {
    /// Provided address is not valid (\(string))
    case invalidAddress(String)
    /// Printable / user displayable description
    public var localizedDescription: String {
        switch self {
        case let .invalidAddress(string):
            return "Provided address is not valid (\(string))"
        }
    }
}

/**
 Address class (20 byte data) used for most library
 
 To init address you can do this:
 ```
 let addressString = "0x45245bc59219eeaaf6cd3f382e078a461ff9de7b"
 let address1 = Address(addressString)
 let address2 = Address("0x45245bc59219eeaaf6cd3f382e078a461ff9de7b")
 ```
 
 If user enters the address you need to check if address is in valid format. To do that use:
 ```
 let inputString = "0x45245bc59219eeaaf6cd3f382e078a461ff9de7b"
 guard inputString.isValid else { return }
 // or
 let address = Address("0x45245bc59219eeaaf6cd3f382e078a461ff9de7b")
 guard address.isValid else { return }
 // or
 try address.check() // will throw AddressError.invalidAddress if its invalid
 ```
 
 Also Address is confirmed to ExpressibleByStringLiteral so you can do this
 ```
 let address: Address = "0x45245bc59219eeaaf6cd3f382e078a461ff9de7b"
 ```
 
 This is very usabe for test cases like if you want to test function (like read ERC20 balance)
 you can just run
 ```
 let balance = try ERC20("0x45245bc59219eeaaf6cd3f382e078a461ff9de7b").balance(of: "0x6a6a0b4aaa60E97386F94c5414522159b45DEdE8")
 print(balance)
 
 ```
 */

public enum CreateWalletType {
    case htdf
    case usdp
    case eth
    case het
    case bit
}

public struct Address {
 
    var walletType = CreateWalletType.htdf
    
    /// Address type
    public enum AddressType {
        /// Any ethereum address
        case normal
        /// Address for contract deployment
        case contractDeployment
    }
    
    /// Checks if address size is 20 bytes long.
    /// Always returns true for contractDeployment address
    public var isValid: Bool {
        switch type {
        case .normal:
            return addressData.count == 20
        case .contractDeployment:
            return true
        }
    }
    
    var _address: String
    /// Address type
    public var type: AddressType = .normal
    
    /// Binary representation of address
    public var addressData: Data {
        switch type {
        case .normal:
            return Data.fromHex(_address) ?? Data()
        case .contractDeployment:
            return Data()
        }
    }
    
    /// Address string converted to checksum
    /// returns 0x for contractDeployment address
    public var address: String {
        //NSLog("fwerwrwafasfrasrwarwer: \(addressData.count) \(walletType) \(_address)")
        if addressData.count == 20 && walletType == .eth {
            return Address.toChecksumAddress(_address)!.lowercased()
        }

        guard addressData.count != 0 && addressData.count != 20 else {
            return _address.lowercased()
        }
        
        switch type {
        case .normal:
            switch walletType {
            case .usdp:
               // NSLog("1111111111fdrwrwrwerfsfffadsf13213123: \(getUSDPAddress())")
                return getUSDPAddress()
            case .htdf:
                 //NSLog("1111111111fdrwrwrwerfsfffadsf13213123: \(getHTDFAddress())")
                return  getHTDFAddress()
            case .het:
                //NSLog("1111111111fdrwrwrwerfsfffadsf13213123: \(getHTDFAddress())")
                return  getHETAddress()
            case .eth:
                 //NSLog("1111111111111111fdrwrwrwerfsfffadsf13213123: \(Address.toChecksumAddress(_address)!)")
                return Address.toChecksumAddress(_address)!
            default:
                return getHTDFAddress()
            }
        
        case .contractDeployment:
            return "0x"
        }
    }
    
    private func getUSDPAddress() -> String {
        let compressData = try! SECP256K1.combineSerializedPublicKeys(keys: [addressData], outputCompressed: true)
        let sourceData = Data(hexStr: "PubKeySecp256k1") + Data(bytes: compressData.bytesWeb)
        
        let data = RIPEMD160.hash(message: sourceData.sha256())
        let covertData = Bech32().covertBits(data: data, fromBits: 8, toBits: 5, pad: true)
        return Bech32().encode(hrp: "usdp", data: covertData)
    }
    
    public func getHTDFAddress() -> String {
        let compressData = try! SECP256K1.combineSerializedPublicKeys(keys: [addressData], outputCompressed: true)
        let sourceData = Data(hexStr: "PubKeySecp256k1") + Data(bytes: compressData.bytesWeb)
        let data = RIPEMD160.hash(message: sourceData.sha256())
        let covertData = Bech32().covertBits(data: data, fromBits: 8, toBits: 5, pad: true)
        return Bech32().encode(hrp: "htdf", data: covertData)
    }
    public func getHETAddress() -> String {
        let compressData = try! SECP256K1.combineSerializedPublicKeys(keys: [addressData], outputCompressed: true)
        let sourceData = Data(hexStr: "PubKeySecp256k1") + Data(bytes: compressData.bytesWeb)
        let data = RIPEMD160.hash(message: sourceData.sha256())
        let covertData = Bech32().covertBits(data: data, fromBits: 8, toBits: 5, pad: true)
        return Bech32().encode(hrp: "0x", data: covertData)
    }
    
    /// Converts address to checksum address
    public static func toChecksumAddress(_ addr: String) -> String? {
        let address = addr.lowercased().withoutHex
        guard let hash = address.data(using: .ascii)?.keccak256().hex else { return nil }
        var ret = "0x"
        
        for (i, char) in address.enumerated() {
            let startIdx = hash.index(hash.startIndex, offsetBy: i)
            let endIdx = hash.index(hash.startIndex, offsetBy: i + 1)
            let hashChar = String(hash[startIdx ..< endIdx])
            let c = String(char)
            guard let int = Int(hashChar, radix: 16) else { return nil }
            if int >= 8 {
                ret += c.uppercased()
            } else {
                ret += c
            }
        }
        return ret
    }
    
    /// Init with addressString and type
    /// - Parameter addressString: Hex string of address
    /// - Parameter type: Address type. default: .normal
    /// Automatically adds 0x prefix if its not found
    public init(_ addressString: String, type: AddressType = .normal, walletType: CreateWalletType = CreateWalletType.htdf) {
        self.walletType = walletType
        
        switch type {
        case .normal:
            // check for checksum
            ///NSLog("11111111111111111111111111: \(addressString.withHex) \(addressString)")
            _address = addressString.withHex
            self.type = .normal
        case .contractDeployment:
            _address = "0x"
            self.type = .contractDeployment
        }
    }
    
    /// - Parameter addressData: Address data
    /// - Parameter type: Address type. default: .normal
    /// - Important: addressData is not the utf8 format of hex string
    public init(_ addressData: Data, type: AddressType = .normal) {
        _address = addressData.hex.withHex
        self.type = type
    }
    
    /// checks if address is valid
    /// - Throws: AddressError.invalidAddress if its not valid
    public func check() throws {
        guard isValid else { throw AddressError.invalidAddress(_address) }
    }
    
    /// - Returns: "0x" address
    public static var contractDeployment: Address {
        return Address("0x", type: .contractDeployment)
    }
    
    //    public static func fromIBAN(_ iban: String) -> Address {
    //
    //    }
}

extension Address: Equatable {
    /// Compares address checksum representation. So there won't be a conflict with string casing
    public static func == (lhs: Address, rhs: Address) -> Bool {
        //NSLog("r3r32423434123213123; lhs.address.withHex\(lhs.address.withHex) rhs.address.withHex: \(rhs.address.withHex)")
        return lhs.address.withHex == rhs.address.withHex && lhs.type == rhs.type
    }
}

extension Address: Hashable {
    public var hashValue: Int {
        return address.hashValue
    }
}

extension Address: CustomStringConvertible {
    /// - Returns: Address hex string formatted to checksum
    public var description: String {
        return address
    }
}

extension Address: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
}

public extension String {
    /// - Returns: true if string is contract address
    var isContractAddress: Bool {
        return hex.count > 0
    }
    
    /// - Returns: true is address is 20 bytes long
    var isAddress: Bool {
        return hex.count == 20
    }
    
    /// - Returns: Contract deployment address.
    var contractAddress: Address {
        return Address(self, type: .contractDeployment)
    }
}
