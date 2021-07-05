//
//  TownCell.swift
//  meteo
//
//  Created by Martin on 30/06/2021.
//

import UIKit

class TownCell: UITableViewCell, ImgDownloaderDelegate {
    
    @IBOutlet private weak var townName: UILabel!
    @IBOutlet private weak var townTemp: UILabel!
    @IBOutlet private weak var townClouds: UIImageView!
    
    var town: Town?
    lazy var imgDownloader: ImgDownloader = {
        let imgDownloader = ImgDownloader()
        imgDownloader.delegate = self
        return imgDownloader
    }()
    
    func setTown(town: Town) {
        guard let temp = town.main?.temp else {
            return
        }
        self.town = town
        let celcius = Int(temp)
        townName.text = town.name
        townTemp.text = String(celcius) + "°C"
        imgDownloader.getImage(town: town)
    }
    
    func downloadFinished(data: Data?, town: Town) {
        guard let data = data,
              self.town?.name == town.name
              else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.townClouds.image = UIImage(data: data)
        }
    }
}
