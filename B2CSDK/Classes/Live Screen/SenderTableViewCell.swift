//
//  SenderTableViewCell.swift
//  B2CSDK
//
//  Created by Raj Kadam on 17/05/22.
//

import UIKit

class SenderTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureUI(){
        profileImage.layer.cornerRadius = profileImage.frame.size.height/2
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.primaryColor.cgColor
    }
    func setupCellData(comment: CommentsModel) {
        messageLabel.text = comment.message
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
