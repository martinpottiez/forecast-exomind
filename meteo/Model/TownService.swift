//
//  TownService.swift
//  meteo
//
//  Created by Martin on 29/06/2021.
//

import Foundation
import UIKit

class TownService {

    static var shared = TownService()
    var towns = [6_432_801, 2_988_507, 2_990_969, 3_031_582, 2_996_944]
    private var task: URLSessionTask?
    private init() {}

    func getForecast(id: Int, callback: @escaping (Bool, Town?) -> Void) {


        guard let forecastUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=5bb8f2270611cba90d1e3c627ba750fc&id=\(TownService.shared.towns[id])&units=metric") else {
            return
        }
        var request = URLRequest(url: forecastUrl)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)

        task?.cancel()

        task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                let decoder = JSONDecoder()
                guard let responseJSON = try? decoder.decode(Town.self, from: data) else {
                    callback(false, nil)
                    return
                }
                let town = Town(name: responseJSON.name,
                                main: responseJSON.main,
                                weather: responseJSON.weather);                callback(true, town)
            }
        }
        task?.resume()
    }
}
