//
//  TVChanells.swift
//  TVPlayer
//
//  Created by Сперанский Никита on 15.09.2022.
//


import Foundation

// MARK: - "TvChanells" structure model
struct TvChannels: Codable {
    let channels: [Channel]
    let valid: Int
    let ckey: String
}



