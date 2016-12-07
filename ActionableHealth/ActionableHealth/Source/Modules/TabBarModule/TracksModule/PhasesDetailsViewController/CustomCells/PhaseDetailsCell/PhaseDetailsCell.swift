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

    //MARK:- Outlets
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var completedOnlabel: UILabel!
    @IBOutlet weak var commentCountButton: UIButton!
    @IBOutlet weak var starRatingView: HCSStarRatingView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var rateTaskButton: UIButton!

    //MARK:- Variables
    static let statusCell = "PhaseDetailsCell_Status"
    weak var delegate:PhaseDetailsCellDelegate?
    var currentTask:TasksModel?

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
    func configureCell(obj:TasksModel) {
        currentTask = obj
        taskNameLabel.text = currentTask?.taskName ?? ""
        commentCountButton.setTitle("\(currentTask?.commentsCount ?? 0) Comments", forState: .Normal)
        starRatingView.value = CGFloat(currentTask?.rating ?? 0)
        ratingLabel.text = "\(currentTask?.rating ?? 0) Rating"

        if obj.parentPhase.parentTemplate.objectType == ObjectType.Track {
            completedOnlabel.text = "Completed on 12 Aug 2016"
            rateTaskButton.hidden = false
        }else{
            completedOnlabel.text = nil
            rateTaskButton.hidden = true
        }
    }
}
