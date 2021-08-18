//
//  CustomTableViewCell.swift
//  lesson11
//
//  Created by Đại Nguyễn  on 8/16/21.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var name: UILabel! {
        didSet {
            var fontSize: CGFloat = 21
            if UIDevice.current.userInterfaceIdiom == .pad {
                fontSize = 24
            }
            name.font = .systemFont(ofSize: fontSize)
        }
    }
        
    
    @IBOutlet weak var des: UILabel! {
        didSet {
            var fontSize: CGFloat = 21
            if UIDevice.current.userInterfaceIdiom == .pad {
                fontSize = 24
            }
            des.font = .systemFont(ofSize: fontSize)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // layout
        NSLayoutConstraint.activate([
            img.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            img.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
