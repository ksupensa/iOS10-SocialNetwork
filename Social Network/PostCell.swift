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
    
    func updateUI(_ usrName: String, postTxt: String, likeNumber: Int, heartImg: UIImage, postImg: UIImage = UIImage()) {
        
        usrNameLbl.text = usrName
        postTxtView.text = postTxt
        likeLbl.text = "\(likeNumber)"
        likeImgView.image = heartImg
        profileImgView.image = UIImage()
        postImgView.image = postImg
    }
    
    func setUsrImage(img: UIImage){
        profileImgView.image = img
    }
    
    func setLikeImg(img: UIImage) {
        likeImgView.image = img
    }
    
    func setPostImg(img: UIImage) {
        postImgView.image = img
    }
}
