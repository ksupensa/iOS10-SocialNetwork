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
    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var postTxtView: UITextView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var likeImgView: UIImageView!
    @IBOutlet weak var postImgView: UIImageView!
    
    var delegate: PostCellDelegate! = nil
    private var id: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(PostCell.likeImgTapped))
        tap.numberOfTapsRequired = 1
        
        likeImgView.addGestureRecognizer(tap)
    }
    
    func likeImgTapped() {
        if delegate != nil {
            delegate.likeImgTapped(id)
        }
    }
    
    func updateUI(_ postId: String, usrName: String, postTxt: String, likeNumber: Int, heartImg: UIImage, postImg: UIImage = UIImage()) {
        
        id = postId
        
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
