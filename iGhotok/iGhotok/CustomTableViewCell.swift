//
//  CustomTableViewCell.swift
//  iGhotok
//
//  Created by kuet on 7/11/21.
//  Copyright © 2021 kuet. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var userPIc: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
