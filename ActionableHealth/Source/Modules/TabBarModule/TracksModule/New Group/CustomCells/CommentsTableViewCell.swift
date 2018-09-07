//
//  CommentsTableViewCell.swift
//  ActionableHealth
//
//  Created by Vaibhav Singla on 8/8/18.
//  Copyright © 2018 Finoit Technologies. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    //MARK:- outlets
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var commentDescriptionLabel: UILabel!
    
    //MARK:- variables
    var blogComment = BlogComment()
    
    class var cellNib: UINib{
        return UINib(nibName: String(describing: CommentsTableViewCell.self), bundle: nil)
    }
    class var cellIdentifier: String{
        return String(describing: CommentsTableViewCell.self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configCell(){
        commentDescriptionLabel.text = self.blogComment.description ?? ""
        if let createdBy = self.blogComment.createdBy , !createdBy.trimmingCharacters(in: NSCharacterSet.whitespaces).isEmpty{
            createdByLabel.text = createdBy
        }else{
            createdByLabel.text = "Anonymous"
        }
        //createdByLabel.text = self.blogComment.createdBy ?? "Anonymous"
        
    }
    
}
