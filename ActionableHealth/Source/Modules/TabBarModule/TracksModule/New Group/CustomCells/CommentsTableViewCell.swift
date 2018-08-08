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
    
    //MARK:- variables
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
    
}
