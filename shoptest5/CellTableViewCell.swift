//
//  CellTableViewCell.swift
//  shoptest5
//
//  Created by NguyenHai on 12/1/16.
//  Copyright © 2016 NguyenHai. All rights reserved.
//

import UIKit

class CellTableViewCell: UITableViewCell {
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var color: UILabel!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var des: UILabel!
    @IBOutlet weak var CellImage: UIImageView!
    @IBOutlet weak var headingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
