//
//  CommnetsCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 19/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class CommnetsCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!


    //MARK:- -------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK:- Addtional Methods
extension CommnetsCell{
    func configCell(comment:CommentsModel) {
        personImageView.image = nil
        if let url = NSURL(string: comment.commentedBy?.profileImage ?? "") {
            personImageView.sd_setImageWithURL(url)
        }
        personNameLabel.text = comment.commentedBy?.name ?? comment.commentedBy?.userID
        commentLabel.text = comment.comment
        
        if comment.commentedOn?.isEqualToDateIgnoringTime(NSDate()) ?? false{
            dateLabel.text = "\(comment.commentedOn?.shortTimeString ?? "")"
        }else{
            dateLabel.text = "\(comment.commentedOn?.mediumDateString ?? "")"
        }
    }
}
