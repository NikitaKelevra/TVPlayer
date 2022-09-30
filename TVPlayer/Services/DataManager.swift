//
//  DataManager.swift
//  TVPlayer
//
//  Created by Сперанский Никита on 26.09.2022.
//

import Foundation

class DataManager {
    // MARK: - Property
    static let shared = DataManager()
    
    private let userDefaults = UserDefaults.standard
    private let favChannelsKey = "newChannelsList"
    
    private init() {}
    
    // MARK: - Function
    /// Добавление/удаление элемента в массиве `Favorite Channels`
    func changeFavoriteStatus(at channel: Channel) {
        var channels = fetchChannels()
        if let index = channels.firstIndex(of: channel) {
            channels.remove(at: index)
        } else {
            channels.append(channel)
        }
        saveFavoriteChannelsArray(favChannels: channels)
    }
    /// Изменение места расположения элемента в массиве `Favorite Channels`
    func changePlaceInFavArray(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
        var channels = fetchChannels()
        let channel = channels[sourceIndexPath.row]
        channels.remove(at: sourceIndexPath.row)
        channels.insert(channel, at: destinationIndexPath.row)
        saveFavoriteChannelsArray(favChannels: channels)
    }
    /// Выгрузка массива `Favorite Channels`
    func fetchChannels() -> [Channel] {
        guard let data = userDefaults.object(forKey: favChannelsKey) as? Data else { return [] }
        guard let contacts = try? JSONDecoder().decode([Channel].self, from: data) else { return [] }
        return contacts
    }
    /// Сохранение массива `Favorite Channels`
    private func saveFavoriteChannelsArray(favChannels: [Channel]) {
        guard let data = try? JSONEncoder().encode(favChannels) else { return }
        userDefaults.set(data, forKey: favChannelsKey)
    }
}
