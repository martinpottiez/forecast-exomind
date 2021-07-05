//
//  Main.swift
//  meteo
//
//  Created by Martin on 30/06/2021.
//

import Foundation

struct Main: Decodable {
    enum CodingKeys: String, CodingKey {
        case temp,
             pressure,
             humidity
        case tempMax = "temp_max"
    }
    var temp: Float?
    var pressure: Int?
    var tempMax: Float?
    var humidity: Int?
}
