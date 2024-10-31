import Foundation
import CryptoSwift
import KeychainAccess

final class SecurityService {
    static let shared = SecurityService()
    private let keychain = Keychain(service: "com.yukre.toolkit")
    
    private init() {}
    
    func encryptData(_ data: Data, using key: String) throws -> Data {
        let aes = try AES(key: Array(key.utf8), blockMode: CBC(iv: Array("YukreInitVector16".utf8)))
        let encrypted = try aes.encrypt(data.bytes)
        return Data(encrypted)
    }
    
    func decryptData(_ data: Data, using key: String) throws -> Data {
        let aes = try AES(key: Array(key.utf8), blockMode: CBC(iv: Array("YukreInitVector16".utf8)))
        let decrypted = try aes.decrypt(data.bytes)
        return Data(decrypted)
    }
    
    func storeSecureData(_ data: Data, forKey key: String) throws {
        try keychain.set(data, key: key)
    }
    
    func retrieveSecureData(forKey key: String) throws -> Data? {
        try keychain.getData(key)
    }
    
    func generateSecureKey() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<32).map { _ in letters.randomElement()! })
    }
}