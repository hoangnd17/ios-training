//
//  EmployTableViewCell.swift
//  lesson13
//
//  Created by Đại Nguyễn  on 8/18/21.
//

import UIKit

class EmployTableViewCell: UITableViewCell {

    @IBOutlet weak var id: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var fsu: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
