//
//  ViewController.swift
//  meteo
//
//  Created by Martin on 29/06/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var buttonShowForecast: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        buttonShowForecast.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}
