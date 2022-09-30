//
//  NetworkManager.swift
//  TVPlayer
//
//  Created by Сперанский Никита on 15.09.2022.
//

import Foundation

struct NetworkManager {
    // MARK: - Property
    typealias RailCompletionClosure = ((TvChannels?, Error?) -> Void)
    
    static let shared = NetworkManager()
    
    private let tvChannelsAPI = "http://limehd.online/playlist/channels.json" /// API загрузки каналов
    
    private init() {}
    
    // MARK: - Function
    // Получаем данные из tvChanellsAPI
    public func fetchChannelsData(completion: RailCompletionClosure?) {
        guard let request = createRequest(for: tvChannelsAPI) else {
            completion?(nil, NetworkError.invalidUrl)
            return
        }
        executeRequest(request: request, completion: completion)
    }
    
    // Создаем настраиваем URLRequest из строки URL
    private func createRequest(for url: String) -> URLRequest? {
        guard let url = URL(string: url) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    // Выполняем сетевой запрос, используя URLRequest через URLSession
    private func executeRequest<T: Codable>(request: URLRequest, completion: ((T?, Error?) -> Void)?) {
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion?(nil, error)
                return
            }
            // Преобразовываем данные согласно поступившей модели данных
            if let decodedResponse = try? JSONDecoder().decode(T.self, from: data) {
                DispatchQueue.main.async {
                    completion?(decodedResponse, nil)
                }
            } else {
                completion?(nil, NetworkError.invalidData)
            }
        }
        dataTask.resume()
    }
}
    
// MARK: - Обработка ошибок интернет запросов
enum NetworkError: Error {
    case invalidUrl
    case invalidData
}
    
    
