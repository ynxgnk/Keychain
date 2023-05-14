//
//  ViewController.swift
//  Keychain
//
//  Created by Nazar Kopeika on 14.05.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getPassword() /* 39 */
    }
    
    func getPassword() { /* 32 */
        guard let data = KeychainManager.get( /* 33 */
            service: "facebook.com",
            account: "nazar"
        ) else { /* 34 */
            print("Failed to read password") /* 35 */
            return /* 36 */
        }
        
        let password = String(decoding: data, as: UTF8.self) /* 37 */
        print("Read password: \(password)") /* 38 */ 
    }

    func save() { /* 31 */
        do { /* 15 */
            try KeychainManager.save(
                service: "facebook.com",
                account: "nazar",
                password: "something".data(using: .utf8) ?? Data() /* 16 */
            )
        }
        catch { /* 17 */
            print(error) /* 18 */
        }
    }
    
}

class KeychainManager { /* 1 */
    
    enum KeychainError: Error { /* 4 */
        case duplicateEntry /* 5 */
        case unknowm(OSStatus) /* 6 */
        
    }
    static func save(
        service: String,
        account: String,
        password: Data
    ) throws { /* 2 */
        print("Starting save") /* 19 */
        //service, account , password, class
        let query: [String: AnyObject] = [ /* 7 */
            kSecClass as String: kSecClassGenericPassword, /* 8 */
            kSecAttrService as String: service as AnyObject, /* 8 */
            kSecAttrAccount as String: account as AnyObject, /* 8 */
            kSecValueData as String: password as AnyObject, /* 8 */
        ]
        
        let status = SecItemAdd(
            query as CFDictionary,
            nil
        ) /* 9 */
        
        guard status != errSecDuplicateItem else { /* 10 */
            throw KeychainError.duplicateEntry /* 11 */
        }
        
        guard status == errSecSuccess else { /* 12 */
            throw KeychainError.unknowm(status) /* 13 */
        }
        
        print("Saved") /* 14 */
        
    }
    
    static func get(
        service: String,
        account: String
    ) -> Data? { /* 3 */
        //service, account, class, return-data, matchlimit

        print("Starting save") /* 20 */
        let query: [String: AnyObject] = [ /* 21 */
            kSecClass as String: kSecClassGenericPassword, /* 22 */
            kSecAttrService as String: service as AnyObject, /* 23 */
            kSecAttrAccount as String: account as AnyObject, /* 24 */
            kSecReturnData as String: kCFBooleanTrue, /* 25 */
            kSecMatchLimit as String: kSecMatchLimitOne /* 28 */
        ]
        
        var result: AnyObject? /* 29 */
        let status = SecItemCopyMatching(
            query as CFDictionary,
            &result
        ) /* 26 */
        
        print("Read status: \(status)") /* 27 */
        return result as? Data /* 30 */
        
    }

}
