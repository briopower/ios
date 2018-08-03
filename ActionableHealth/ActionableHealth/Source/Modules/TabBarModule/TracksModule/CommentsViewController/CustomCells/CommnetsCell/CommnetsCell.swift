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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK:- Addtional Methods
extension CommnetsCell{
    func configCell(_ comment:CommentsModel) {
        personImageView.image = nil
        if let id = comment.commentedBy {
            if let person = Person.getPersonWith(id) {
                if let personImage =  person.personImage{
                    if let url = URL(string: personImage) {
                        personImageView.sd_setImage(with: url)
                    }
                }else{
                    NetworkClass.sendRequest(URL: "\(Constants.URLs.profileImageURL)\(id ?? "")", RequestType: .get) {
                        (status, responseObj, error, statusCode) in
                        if status, let imageUrl = responseObj?["profileURL"] as? String{
                            if let url = NSURL(string: imageUrl) {
                                self.personImageView.sd_setImage(with: url as URL)
                            }
                        }
                    }
                }
                personNameLabel.text = person.personName ?? person.personId
            }
        }

        commentLabel.text = comment.comment

        if comment.commentedOn?.isEqualToDateIgnoringTime(Date()) ?? false{
            dateLabel.text = "\(comment.commentedOn?.shortTimeString ?? "")"
        }else{
            dateLabel.text = "\(comment.commentedOn?.mediumDateString ?? "")"
        }
    }
}
