//
//  Channel.swift
//  TVPlayer
//
//  Created by Сперанский Никита on 26.09.2022.
//

import Foundation
import UniformTypeIdentifiers

// MARK: - "Channel" structure model
final class Channel: NSObject, Codable, NSItemProviderWriting  {

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
    
    init(id: Int, epgID: Int, nameRu: String, nameEn: String, vitrinaEventsURL: String, isFederal: Bool, address: String,
         cdn: String, url: String, urlSound: String, image: String, hasEpg: Bool, current: Current, regionCode: Int,
         tz: Int, isForeign: Bool, number: Int, drmStatus: Int, owner: Owner, foreignPlayerKey: Bool, foreignPlayer: ForeignPlayer?)
    {
        self.id = id
        self.epgID = epgID
        self.nameRu = nameRu
        self.nameEn = nameEn
        self.vitrinaEventsURL = vitrinaEventsURL
        self.isFederal = isFederal
        self.address = address
        self.cdn = cdn
        self.url = url
        self.urlSound = urlSound
        self.image = image
        self.hasEpg = hasEpg
        self.current = current
        self.regionCode = regionCode
        self.tz = tz
        self.isForeign = isForeign
        self.number = number
        self.drmStatus = drmStatus
        self.owner = owner
        self.foreignPlayerKey = foreignPlayerKey
        self.foreignPlayer = foreignPlayer
    }
    
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
    // MARK: - Conform NSItemProviderWriting
    var image2D:Data?
    static var writableTypeIdentifiersForItemProvider = [UTType.data.identifier as String]
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        let data = image2D
        completionHandler(data, nil)
        return nil
    }
}

// MARK: - "Current"  structure model
struct Current: Codable, Hashable {
    let timestart, timestop: Int
    let title, desc: String
    let cdnvideo, rating: Int
}

// MARK: - "ForeignPlayer" structure model
struct ForeignPlayer: Codable, Hashable {
    let url: String?
    let sdk: String
    let validFrom: Int

    enum CodingKeys: String, CodingKey {
        case url, sdk
        case validFrom = "valid_from"
    }
}
// MARK: - "Owner" enum model
enum Owner: String, Codable, Hashable {
    case lime = "lime"
    case vitrina = "vitrina"
}
