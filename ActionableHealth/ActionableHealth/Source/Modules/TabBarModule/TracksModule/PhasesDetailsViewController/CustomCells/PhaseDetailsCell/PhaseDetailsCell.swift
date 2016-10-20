//
//  PhaseDetailsCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 20/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
protocol PhaseDetailsCellDelegate:NSObjectProtocol {
    func commentsTapped(tag:Int, obj:AnyObject?)
    func rateTaskTapped(tag:Int, obj:AnyObject?)
}
class PhaseDetailsCell: UITableViewCell {

    //MARK:- Variables
    static let statusCell = "PhaseDetailsCell_Status"
    weak var delegate:PhaseDetailsCellDelegate?

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

//MARK:- Button Action
extension PhaseDetailsCell{
    @IBAction func commentsAction(sender: AnyObject) {
        delegate?.commentsTapped(self.tag, obj: nil)
    }
    @IBAction func rateTaskAction(sender: AnyObject) {
        delegate?.rateTaskTapped(self.tag, obj: nil)
    }
    
}
//MARK:- Additional methods
extension PhaseDetailsCell{

}