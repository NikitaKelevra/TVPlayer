//
//  TVChanellsModel.swift
//  TVPlayer
//
//  Created by Сперанский Никита on 15.09.2022.
//


import Foundation

// MARK: - TvChanells
struct TvChannels: Codable {
    let channels: [Channel]
    let valid: Int
    let ckey: String
}

// MARK: - Channel
struct Channel: Codable, Hashable {
    let id, epgID: Int
    let nameRu, nameEn: String
    let vitrinaEventsURL: String
    let isFederal: Bool
    let address: String
    let cdn, url, urlSound: String
    let image: String
    let hasEpg: Bool
    let current: Current
    let regionCode, tz: Int
    let isForeign: Bool
    let number, drmStatus: Int
    let owner: Owner
    let foreignPlayerKey: Bool
    let foreignPlayer: ForeignPlayer?

    enum CodingKeys: String, CodingKey {
        case id
        case epgID = "epg_id"
        case nameRu = "name_ru"
        case nameEn = "name_en"
        case vitrinaEventsURL = "vitrina_events_url"
        case isFederal = "is_federal"
        case address, cdn, url
        case urlSound = "url_sound"
        case image, hasEpg, current
        case regionCode = "region_code"
        case tz
        case isForeign = "is_foreign"
        case number
        case drmStatus = "drm_status"
        case owner
        case foreignPlayerKey = "foreign_player_key"
        case foreignPlayer = "foreign_player"
    }
}

// MARK: - Current
struct Current: Codable, Hashable {
    let timestart, timestop: Int
    let title, desc: String
    let cdnvideo, rating: Int
}

// MARK: - ForeignPlayer
struct ForeignPlayer: Codable, Hashable {
    let url: String?
    let sdk: String
    let validFrom: Int

    enum CodingKeys: String, CodingKey {
        case url, sdk
        case validFrom = "valid_from"
    }
}

enum Owner: String, Codable, Hashable {
    case lime = "lime"
    case vitrina = "vitrina"
}

