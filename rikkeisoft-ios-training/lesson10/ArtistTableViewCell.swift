//
//  ArtistTableViewCell.swift
//  lesson10
//
//  Created by Đại Nguyễn  on 8/15/21.
//

import UIKit

class ArtistTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var Country: UILabel!
    @IBOutlet weak var Ambi: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
