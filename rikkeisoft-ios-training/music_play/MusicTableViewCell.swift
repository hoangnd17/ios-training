//
//  MusicTableViewCell.swift
//  music_play
//
//  Created by Đại Nguyễn  on 8/23/21.
//

import UIKit

class MusicTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var artist: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
}
