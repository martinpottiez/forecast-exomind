//
//  ShowForecastController.swift
//  meteo
//
//  Created by Martin on 29/06/2021.
//

import UIKit

class ShowForecastController: UIViewController {

    @IBOutlet private weak var labelLoading: UILabel!
    @IBOutlet private weak var progressBar: UIProgressView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var reloadButton: UIButton!

    var towns: [Town] = []
    var labelLoadingMsg = ["Nous téléchargeons les données...", "C'est presque fini...", "Plus que quelques secondes..."]
    var progressTimer: Timer!
    var labelTimer: Timer!
    var townServiceTimer: Timer!
    var inc = 1
    var idTown = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "BackgroundColor")
        tableView.tableFooterView = UIView()
        reloadButton.layer.cornerRadius = 5
        tableView.layer.isHidden = true
        reloadButton.layer.isHidden = true
        progressTimer = Timer.scheduledTimer(timeInterval: 1,
                                             target: self,
                                            selector: #selector(ShowForecastController.updateProgressBar),
                                            userInfo: nil,
                                            repeats: true)
        labelTimer = Timer.scheduledTimer(timeInterval: 6,
                                          target: self,
                                            selector: #selector(ShowForecastController.updateLabelLoading),
                                            userInfo: nil,
                                            repeats: true)
        getTownForecast()
        townServiceTimer = Timer.scheduledTimer(timeInterval: 2,
                                                target: self,
                                            selector: #selector(ShowForecastController.getTownForecast),
                                            userInfo: nil,
                                            repeats: true)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc
    private func getTownForecast() {
        TownService.shared.getForecast(id: idTown) { success, town
        in
            if success, let town = town {
                self.update(town: town)
            }
        }
        idTown += 1
        if idTown == 5 {
            townServiceTimer.invalidate()
        }
    }

    private func update(town: Town) {
        towns.append(town)
        tableView.reloadData()
    }

    @objc
    private func updateProgressBar() {
        progressBar.progress += 1 / 10
        progressBar.setProgress(progressBar.progress, animated: true)
        if progressBar.progress == 1.0 {
            progressTimer.invalidate()
            progressBar.layer.isHidden = true
            reloadButton.layer.isHidden = false
            labelLoading.layer.isHidden = true
            tableView.layer.isHidden = false
        }
    }

    @objc
    private func updateLabelLoading() {
        labelLoading.text = labelLoadingMsg[inc]
        inc += 1
        if inc == 3 {
            inc = 0
        }
    }
    
    @IBAction private func tappedReloadButton() {
        inc = 0
        idTown = 0
        progressBar.progress = 0
        towns.removeAll()
        labelLoading.layer.isHidden = false
        progressBar.layer.isHidden = false
        viewDidLoad()
    }
}

extension ShowForecastController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        towns.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let town = towns[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TownCell") as? TownCell
        cell?.setTown(town: town)
        return cell ?? UITableViewCell()
    }
}
