//
//  JournalListTableViewCell.swift
//  ActionableHealth
//
//  Created by Vaibhav Singla on 8/10/18.
//  Copyright © 2018 Finoit Technologies. All rights reserved.
//

import UIKit
//MARK:- Protocols
protocol JournalListTableViewCellDelegate {
    func deleteSelectionButtonTapped(_ isSelectedForDelete: Bool)
}

class JournalListTableViewCell: UITableViewCell {

    //MARK:- Outlets
    
    @IBOutlet weak var deleteSelectionButton: UIButton!
    @IBOutlet weak var journalTitleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var buttonBgView: UIView!
    
    //MARK:- variables
    class var cellNib: UINib{
        return UINib(nibName: String(describing: JournalListTableViewCell.self), bundle: nil)
    }
    class var cellIdentifier: String{
        return String(describing: JournalListTableViewCell.self)
    }
    var indexPath: IndexPath?
    var isEdtingMode = false
    var journal = Journal()
    var delegate: JournalListTableViewCellDelegate?
    
    //MARK:- View LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Button Actions
    @IBAction func selectionButtonTapped(_ sender: UIButton) {
        journal.isSelcetedForDelete = !journal.isSelcetedForDelete
        journal.isSelcetedForDelete ? (deleteSelectionButton.setImage(#imageLiteral(resourceName: "Selected-Circle"), for: .normal)) : (deleteSelectionButton.setImage(#imageLiteral(resourceName: "Blank-Circle"), for: .normal))
        self.delegate?.deleteSelectionButtonTapped(self.journal.isSelcetedForDelete)
    }
    
}

//MARK:- userDefined functions
extension JournalListTableViewCell{
    func configCell(){
        journalTitleLabel.text =  self.journal.description ?? "No description Available"
        dateLabel.text = self.journal.createdDate?.shortString ?? ""
        self.isEdtingMode ? (buttonBgView.isHidden = false) : (buttonBgView.isHidden = true)
        journal.isSelcetedForDelete ? (deleteSelectionButton.setImage(#imageLiteral(resourceName: "Selected-Circle"), for: .normal)) : (deleteSelectionButton.setImage(#imageLiteral(resourceName: "Blank-Circle"), for: .normal))
    }
}

