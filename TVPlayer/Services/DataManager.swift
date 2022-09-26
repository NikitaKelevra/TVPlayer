//
//  DataManager.swift
//  TVPlayer
//
//  Created by Сперанский Никита on 26.09.2022.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    private let userDefaults = UserDefaults.standard
    private let favChannelsKey = "newChannelsList"
    
    private init() {}
    
    func save(contact: Channel) {
        var channels = fetchChannels()
        channels.append(contact)
        
        guard let data = try? JSONEncoder().encode(channels) else { return }
        userDefaults.set(data, forKey: favChannelsKey)
    }
    
    func fetchChannels() -> [Channel] {
        guard let data = userDefaults.object(forKey: favChannelsKey) as? Data else { return [] }
        guard let contacts = try? JSONDecoder().decode([Channel].self, from: data) else { return [] }
        
        return contacts
    }
    
    func changeFavoriteStatus(at index: Int) {
        var channels = fetchChannels()
        var channel = channels.remove(at: index)
//        channel.favoriteStatus.toggle()
        channels.insert(channel, at: index)
        
        guard let data = try? JSONEncoder().encode(channels) else { return }
        userDefaults.set(data, forKey: favChannelsKey)
    }
}
