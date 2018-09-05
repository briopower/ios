//
//  BlogListTableViewCell.swift
//  ActionableHealth
//
//  Created by Vaibhav Singla on 8/3/18.
//  Copyright © 2018 Finoit Technologies. All rights reserved.
//

import UIKit

//MARK:- Protocols
protocol BlogListTableViewCellDelegate {
    func deleteButtonTapped()
}

class BlogListTableViewCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var blogTitleLabel: UILabel!
    
    @IBOutlet weak var blogAuthorNameLabel: UILabel!
    @IBOutlet weak var blogPublishedDateLabel: UILabel!
    @IBOutlet weak var deleteSelectionButton: UIButton!
    @IBOutlet weak var deleteSelectionBgView: UIView!
    
    
    //MARK:- variables
    class var cellNib: UINib{
        return UINib(nibName: String(describing: BlogListTableViewCell.self), bundle: nil)
    }
    class var cellIdentifier: String{
        return String(describing: BlogListTableViewCell.self)
    }
    var indexPath: IndexPath?
    var isEdtingMode = false
    var isDeleteSelected = false
    var delegate: BlogListTableViewCellDelegate?
    var blog: Blog?
    //MARK:- LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configCell(){
        //self.isEdtingMode ? (deleteSelectionBgView.isHidden = false) : (deleteSelectionBgView.isHidden = true)
        if (blog?.isCreatedByMe)! && self.isEdtingMode {
            deleteSelectionBgView.isHidden = false
            (self.blog?.isSelcetedForDelete)! ? (deleteSelectionButton.setImage(#imageLiteral(resourceName: "Selected-Circle"), for: .normal)) : (deleteSelectionButton.setImage(#imageLiteral(resourceName: "Blank-Circle"), for: .normal))
        }else {
            deleteSelectionBgView.isHidden = true
        }
        if let title = blog?.title{
            blogTitleLabel.text = title
        }else{
            blogTitleLabel.text = "No title found"
        }
        if (blog?.isCreatedByMe)!{
            blogAuthorNameLabel.text = "Me"
        }else if let author = blog?.author{
            blogAuthorNameLabel.text = author
        }else{
            blogAuthorNameLabel.text = "Anonymous"
        }
        if let date = self.blog?.createdDate{
          blogPublishedDateLabel.text = date.shortString
        }
    }
    
    
    //MARK:- button actions
    @IBAction func deleteSelectionButtonTapped(_ sender: Any) {
        
        self.blog?.isSelcetedForDelete = !(self.blog?.isSelcetedForDelete)!
        (self.blog?.isSelcetedForDelete)! ? (deleteSelectionButton.setImage(#imageLiteral(resourceName: "Selected-Circle"), for: .normal)) : (deleteSelectionButton.setImage(#imageLiteral(resourceName: "Blank-Circle"), for: .normal))
        
        self.delegate?.deleteButtonTapped()
    }
    
}
