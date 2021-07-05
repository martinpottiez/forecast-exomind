//
//  Town.swift
//  meteo
//
//  Created by Martin on 29/06/2021.
//

import Foundation
import UIKit

struct Town: Decodable {
    var name: String
    var main: Main?
    var weather: [Weather]?
}
