//
//  Environment.swift
//  Next
//
//  Created by Guilherme Souza on 07/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation

protocol Environment {
    func getCurrentUser() -> User?
    func saveCurrentUser(_ currentUser: User)
    func removeCurrentUser()
}

struct UserDefaultsEnvironment: Environment {

    private enum Keys: String {
        case currentUser
    }

    private let userDefaults = UserDefaults.standard

    func getCurrentUser() -> User? {
        return object(User.self, forKey: Keys.currentUser.rawValue)
    }

    func saveCurrentUser(_ currentUser: User) {
        set(currentUser, forKey: Keys.currentUser.rawValue)
    }

    func removeCurrentUser() {
        removeObject(forKey: Keys.currentUser.rawValue)
    }

    private func set<T>(_ object: T, forKey key: String) where T : Codable {
        guard let data = try? JSONEncoder().encode(object) else {
            return
        }
        userDefaults.set(data, forKey: key)
    }

    private func object<T>(_: T.Type, forKey key: String) -> T? where T : Codable {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    private func removeObject(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
