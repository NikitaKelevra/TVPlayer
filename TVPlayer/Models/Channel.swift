//
//  Channel.swift
//  TVPlayer
//
//  Created by Сперанский Никита on 26.09.2022.
//

import Foundation

// MARK: - Channel Model

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

/*
{"channels":[{
    "id":105,
    "epg_id":105,
    "name_ru":"Первый канал",
    "name_en":"Первый канал",
    "vitrina_events_url":"","is_federal":true,
    "address":"1kanal",
    "cdn":"http://limehd.cdnvideo.ru/streaming/1kanalott/324/1/index.m3u8?md5=8dabQHbB3DaJYgj8aGnSXw&e=1663237173",
    "url":"http://mhd.iptv2022.com/p/faSDdOftfp3iHNDj-Bnxdg,1663237173/streaming/1kanalott/324/1/index.m3u8",
    "url_sound":"http://mhd.iptv2022.com/p/faSDdOftfp3iHNDj-Bnxdg,1663237173/streaming/1kanalott/324/1/tracks-a1/mono.m3u8",
    "image":"https://assets.iptv2022.com/static/channel/105/logo_256_1655386697.png",
    "hasEpg":true,
    "current":{
        "timestart":1663146900,
        "timestop":1663156800,
        "title":"Информационный канал",
        "desc":"Получайте самую свежую информацию обо всём, что происходит!",
        "cdnvideo":0,
        "rating":16},"region_code":0,"tz":3,"is_foreign":false,"number":1,"drm_status":0,"owner":"lime","foreign_player_key":true},{"id":115,"epg_id":198,"name_ru":"Россия 1","name_en":"Россия 1","vitrina_events_url":"https://pl.iptv2021.com/api/v1/vitrina-config?id=115&tz=3","is_federal":true,"address":"rossia1","cdn":"http://limehd.cdnvideo.ru/streaming/rossia1ott/324/1/index.m3u8?md5=fHzFjVB29al6AKXcee6M_g&e=1663237173","url":"http://mhd.iptv2022.com/p/5VKJtqQZ6fzk5yDn9lmqYA,1663237173/streaming/rossia1ott/324/1/index.m3u8","url_sound":"http://mhd.iptv2022.com/p/5VKJtqQZ6fzk5yDn9lmqYA,1663237173/streaming/rossia1ott/324/1/tracks-a1/mono.m3u8","image":"https://assets.iptv2022.com/static/channel/115/logo_256_1655391177.png","hasEpg":true,"current":{"timestart":1663144200,"timestop":1663153200,"title":"60 минут","desc":"В ежедневной социально-политической программе ведущие и гости обсуждают главную тему текущего дня. В студию приглашаются политические и общественные деятели","cdnvideo":0,"rating":12},"region_code":0,"tz":3,"is_foreign":false,"number":2,"drm_status":0,"owner":"lime","foreign_player":{"url":"","sdk":"vitrinatv","valid_from":1603141200},"foreign_player_key":true},{"id":157,"epg_id":157,"name_ru":"Матч!","name_en":"Матч!","vitrina_events_url":"","is_federal":true,"address":"match","cdn":"http://limehd.cdnvideo.ru/streaming/matchott/324/1/index.m3u8?md5=fOf7wWDWGMG5MTJzQEU9ww&e=1663237173","url":"http://mhd.iptv2022.com/p/RlfnvhAJFsTd_r1Lnmry9Q,1663237173/streaming/matchott/324/1/index.m3u8","url_sound":"http://mhd.iptv2022.com/p/RlfnvhAJFsTd_r1Lnmry9Q,1663237173/streaming/matchott/324/1/tracks-a1/mono.m3u8","image":"https://assets.iptv2022.com/static/channel/157/logo_256_1655390359.png","hasEpg":true,"current":{"timestart":1663149300,"timestop":1663156500,"title":"Футбол. Фонбет Кубок России. \"Амкал\" (Москва) - \"Звезда\" (Санкт-Петербург)","desc":"","cdnvideo":0,"rating":0},"region_code":0,"tz":3,"is_foreign":false,"number":3,"drm_status":0,"owner":"lime","foreign_player_key":true},{"id":10100,"epg_id":99,"name_ru":"НТВ","name_en":"НТВ","vitrina_events_url":"","is_federal":true,"address":"ntv","cdn":"http://limehd.cdnvideo.ru/streaming/ntvnn/324/1/index.m3u8?md5=gr0mMf7XKdIttlEQBMOroQ&e=1663237173","url":"http://mhd.iptv2022.com/p/MXCwlCFMooA53OVTxmamrA,1663237173/streaming/ntvnn/324/1/index.m3u8","url_sound":"http://mhd.iptv2022.com/p/MXCwlCFMooA53OVTxmamrA,1663237173/streaming/ntvnn/324/1/tracks-a1/mono.m3u8","image":"https://assets.iptv2022.com/static/channel/10100/logo_256_1655385292.png","hasEpg":true,"current":{"timestart":1663149600,"timestop":1663151100,"title":"Сегодня","desc":"Десятки репортёров в России, постоянно действующие корпункты в Европе, США, странах СНГ, специальные корреспонденты, готовые немедленно отправиться в любую точку мира, - всё это для того, чтобы наши зрители узнавали самые актуальные новости","cdnvideo":0,"rating":16},"region_code":0,"tz":3,"is_foreign":false,"number":4,"drm_status":0,"owner":"lime","foreign_player":{"url":"","sdk":"vitrinatv","valid_from":0},"foreign_player_key":true},{"id":3,"epg_id":3,"name_ru":"Пятый канал","name_en":"Пятый канал","vitrina_events_url":"https://pl.iptv2021.com/api/v1/vitrina-config?id=3&tz=3","is_federal":true,"address":"5kanal","cdn":"http://limehd.cdnvideo.ru/streaming/5kanalott/324/1/index.m3u8?md5=dqNVjWuvvdjbZNcPqIaf3Q&e=1663237173","url":"http://mhd.iptv2022.com/p/6r36W6FRc1QMKBUgRbGgkg,1663237173/streaming/5kanalott/324/1/index.m3u8","url_sound":"http://mhd.iptv2022.com/p/6r36W6FRc1QMKBUgRbGgkg,1663237173/streaming/5kanalott/324/1/tracks-a1/mono.m3u8","image":"https://assets.iptv2022.com/static/channel/3/logo_256_1655391199.png","hasEpg":true,"current":{"timestart":1663143000,"timestop":1663146600,"title":"Группа \"Зета\". 7-я серия","desc":"У Магомета остались секретные планы атомной электростанции, поэтому его оставляют в живых. И он предлагает Камалу для осуществления террористического акта использовать своих бывших сокамерников вместо боевиков, ликвидированных спецслужбами","cdnvideo":0,"rating":16},"region_code":0,"tz":3,"is_foreign":false,"number":5,"drm_status":0,"owner":"lime","foreign_player":{"url":"","sdk":"vitrinatv","valid_from":1603141200},"foreign_player_key":true},{"id":83,"epg_id":83,"name_ru":"Россия К","name_en":"Россия К","vitrina_events_url":"https://pl.iptv2021.com/api/v1/vitrina-config?id=83&tz=3","is_federal":true,"address":"russiak","cdn":"http://limehd.cdnvideo.ru/streaming/rossiak/324/1/index.m3u8?md5=iqDtuF5cfjbHuBufsFOR7Q&e=1663237173","url":"http://mhd.iptv2022.com/p/la_8K8AVGfo5epPoDGCR0Q,1663237173/streaming/rossiak/324/1/index.m3u8","url_sound":"http://mhd.iptv2022.com/p/la_8K8AVGfo5epPoDGCR0Q,1663237173/streaming/rossiak/324/1/tracks-a1/mono.m3u8","image":"https://assets.iptv2022.com/static/channel/83/logo_256_1655391215.png","hasEpg":true,"current":{"timestart":1663147800,"timestop":1663151700,"title":"Спрут","desc":"В небольшом сицилийском городке убивают начальника уголовного розыска Маринео. Кажется, что это преступление мафии. В тот же день становится известно еще об одной смерти. Покончила с собой маркиза Печчи Шалойя","cdnvideo":0,"rating":16},"region_code":0,"tz":3,"is_foreign":false,"number":6,"drm_status":0,"owner":"lime","foreign_player_key":true},{"id":148,"epg_id":211,"name_ru":"Россия 24","name_en":"Россия 24","vitrina_events_url":"https://pl.iptv2021.com/api/v1/vitrina-config?id=148&tz=3","is_federal":true,"address":"rossia24","cdn":"http://limehd.cdnvideo.ru/streaming/rossia24nn/324/1/index.m3u8?md5=Jo2qTUPgFHjSsykehKlSVA&e=1663237173","url":"http://mhd.iptv2022.com/p/GilpW3V6R3dGCnTUaTTG2A,1663237173/streaming/rossia24nn/324/1/index.m3u8","url_sound":"http://mhd.iptv2022.com/p/GilpW3V6R3dGCnTUaTTG2A,1663237173/streaming/rossia24nn/324/1/tracks-a1/mono.m3u8","image":"https://assets.iptv2022.com/static/channel/148/logo_256_1655391326.png","hasEpg":true,"current":{"timestart":1663144380,"timestop":1663146600,"title":"Типичная Украина","desc":"Эта передача о том, что Украина сшита из разных лоскутов. Одна из основных тем - история Украины и то, как по-разному на эти страницы истории смотрят эксперты из России и Украины\"","cdnvideo":0,"rating":16},"region_code":0,"tz":3,"is_foreign":false,"number":7,"drm_status":0,"owner":"lime","foreign_player":{"url":null,"sdk":"vitrinatv","valid_from":1603141200},"foreign_player_key":true},{"id":78,"epg_id":78,"name_ru":"Карусель","name_en":"Карусель","vitrina_events_url":"","is_federal":true,"address":"karusel","cdn":"http://limehd.cdnvideo.ru/streaming/karusel/324/1/index.m3u8?md5=mrhdcaYH7nyBoiowWVN1VQ&e=1663237173","url":"http://mhd.iptv2022.com/p/6l8Jg1MDXz69nI9r0wsdhA,1663237173/streaming/karusel/324/1/index.m3u8","url_sound":"http://mhd.iptv2022.com/p/6l8Jg1MDXz69nI9r0wsdhA,1663237173/streaming/karusel/324/1/tracks-a1/mono.m3u8","image":"https://assets.iptv2022.com/static/channel/78/logo_256_1655391637.png","hasEpg":true,"current":{"timestart":1663149900,"timestop":1663153200,"title":"Дикие Скричеры. Сборник 95-й","desc":"Большой побег - Данное обещание","cdnvideo":0,"rating":6},"region_code":0,"tz":3,"is_foreign":false,"number":8,"drm_status":0,"owner":"lime","foreign_player_key":true},{"id":101,"epg_id":101,"name_ru":"ОТР","name_en":"ОТР","vitrina_events_url":"","is_federal":true,"address":"otr","cdn":"http://limehd.cdnvideo.ru/streaming/otr/324/1/index.m3u8?md5=1mzwttsBgqJee8azE0Y4Og&e=1663237173","url":"http://mhd.iptv2022.com/p/lS-bJAQnCFX0m0QQuSDToQ,1663237173/streaming/otr/324/1/index.m3u8","url_sound":"http://mhd.iptv2022.com/p/lS-bJAQnCFX0m0QQuSDToQ,1663237173/streaming/otr/324/1/tracks-a1/mono.m3u8","image":"https://assets.iptv2022.com/static/channel/101/logo_256_1655445073.png","hasEpg":true,"current":{"timestart":1663149600,"timestop":1663150800,"title":"Новости","desc":"Новости о жизни регионов России и событиях за рубежом - социальная сфера, культура, экономика, политика, наука и технологии","cdnvideo":0,"rating":12},"region_code":0,"tz":3,"is_foreign":false,"number":9,"drm_status":0,"owner":"lime","foreign_player_key":true},{"id":129,"epg_id":129,"name_ru":"ТВ Центр","name_en":"ТВ Центр","vitrina_events_url":"","is_federal":true,"address":"tvc","cdn":"http://limehd.cdnvideo.ru/streaming/tvc/324/1/index.m3u8?md5=ug6lFv55A3JVFgcH9vy42w&e=1663237173","url":"http://mhd.iptv2022.com/p/GzmF-DgWLC7OlxexaEvVqw,1663237173/streaming/tvc/324/1/index.m3u8","url_sound":"http://mhd.iptv2022.com/p/GzmF-DgWLC7OlxexaEvVqw,1663237173/streaming/tvc/324/1/tracks-a1/mono.m3u8","image":"https://assets.iptv2022.com/static/channel/129/logo_256_1655445000.png","hasEpg":true,"current":{"timestart":1663148760,"timestop":1663152000,"title":"Практика. 22-я серия","desc":"Грачёв вызывает к себе Илью и предлагает ему начать работать над диссертацией. Накануне своего дня рождения Вера разговаривает с отцом: ведь когда ей исполнится
*/
