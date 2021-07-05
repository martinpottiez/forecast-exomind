//
//  ImgDownloader.swift
//  meteo
//
//  Created by Martin on 05/07/2021.
//

import Foundation

protocol ImgDownloaderDelegate: AnyObject {
    func downloadFinished(data: Data?, town: Town)
}

class ImgDownloader {
    weak var delegate: ImgDownloaderDelegate?
    
    func getImage(town: Town) {
        guard let icon = town.weather?.first?.icon else {
            return
        }
        let session = URLSession(configuration: .default)
        guard let iconUrl = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") else { return
        }
        let download = session.dataTask(with: iconUrl) { [weak self] data, response, error in
            if let _ = error {
                print("error 1")
            } else {
                if (response as? HTTPURLResponse) != nil {
                    self?.delegate?.downloadFinished(data: data, town: town)
                }
            }
        }
        download.resume()
    }
}
