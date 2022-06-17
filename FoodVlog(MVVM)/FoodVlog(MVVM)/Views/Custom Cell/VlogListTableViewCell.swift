//
//  VlogListTableViewCell.swift
//  FoodVlog(MVVM)
//
//  Created by Isiah Parra on 6/15/22.
//

import UIKit

class VlogListTableViewCell: UITableViewCell {
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    

    func configureCell(with vlog: Vlog){
        foodNameLabel.text = vlog.name
        locationLabel.text = vlog.location
        dateLabel.text = vlog.date.stringValue()
        
    }
}
