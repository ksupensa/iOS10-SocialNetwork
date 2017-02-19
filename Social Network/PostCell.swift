//
//  PostCell.swift
//  Social Network
//
//  Created by Spencer Forrest on 18/02/2017.
//  Copyright © 2017 Spencer Forrest. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var usrNameLbl: UILabel!
    @IBOutlet var likeLbl: UILabel!
    @IBOutlet weak var postTxtView: UITextView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var likeImgView: UIImageView!
    @IBOutlet weak var postImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUI(_ usrName: String, postTxt: String, likeNumber: Int, profileImg: UIImage, likeImg: UIImage, postImg: UIImage) {
        
        usrNameLbl.text = usrName
        postTxtView.text = postTxt
        likeLbl.text = "\(likeNumber)"
        profileImgView.image = profileImg
        likeImgView.image = likeImg
        profileImgView.image = profileImg
    }
}
