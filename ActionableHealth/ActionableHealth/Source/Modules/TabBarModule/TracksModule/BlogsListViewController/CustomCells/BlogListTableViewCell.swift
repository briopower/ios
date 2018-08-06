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
    
    //MARK:- LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configCell(){
        self.isEdtingMode ? (deleteSelectionBgView.isHidden = false) : (deleteSelectionBgView.isHidden = true)
    }
    
    
    //MARK:- button actions
    @IBAction func deleteSelectionButtonTapped(_ sender: Any) {
        self.isDeleteSelected = !self.isDeleteSelected
        isDeleteSelected ? (deleteSelectionButton.setImage(#imageLiteral(resourceName: "Selected-Circle"), for: .normal)) : (deleteSelectionButton.setImage(#imageLiteral(resourceName: "Blank-Circle"), for: .normal))
        self.delegate?.deleteButtonTapped()
    }
    
}
