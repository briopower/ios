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
enum TaskStatus:String {
    case New, InProgress, Paused, Complete, InComplete

    static func getNibName(status:String) -> String{
        switch status {
        case "Complete", "In Complete":
            return PhaseDetailsCell.completedCell
        default:
            return PhaseDetailsCell.statusCell
        }
    }
    static func getStatus(status:String) -> String {
        switch status {
        case "Complete":
            return TaskStatus.Complete.rawValue.uppercaseString
        case "In progress":
            return "IN PROGRESS"
        default:
            return TaskStatus.New.rawValue.uppercaseString
        }
    }
}

class PhaseDetailsCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var completedOnlabel: UILabel!
    @IBOutlet weak var commentCountButton: UIButton!
    @IBOutlet weak var starRatingView: HCSStarRatingView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var rateTaskButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var taskCompleted: UITextField!

    //MARK:- Variables
    static var statusCell = "PhaseDetailsCell_Status"
    static var completedCell = "PhaseDetailsCell_Completed"

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
        delegate?.commentsTapped(self.tag, obj: currentTask?.key)
    }
    @IBAction func rateTaskAction(sender: AnyObject) {
        delegate?.rateTaskTapped(self.tag, obj: currentTask)
    }
    @IBAction func sliderValueChanged(sender: UISlider) {
        updateCompleted()
    }
    @IBAction func sliderTouchUpInside(sender: UISlider) {
        updateCompleted()
    }
    @IBAction func sliderTouchUpOutside(sender: UISlider) {
        updateCompleted()
    }
}

//MARK:- Additional methods
extension PhaseDetailsCell{
    func configureCell(obj:TasksModel) {
        currentTask = obj
        taskNameLabel.text = currentTask?.taskName.uppercaseString ?? ""
        starRatingView.value = CGFloat(currentTask?.rating ?? 0)
        ratingLabel.text = "\(currentTask?.rating ?? 0) Rating"

        if obj.parentPhase.parentTemplate.objectType == ObjectType.Track {
            commentCountButton.setTitle("\(currentTask?.commentsCount ?? 0) Comment(s)", forState: .Normal)
            commentCountButton.hidden = currentTask?.key.getValidObject() == nil
            rateTaskButton.hidden = commentCountButton.hidden

            statusLabel.text = TaskStatus.getStatus(obj.status)
        }
    }

    func updateCompleted() {
        taskCompleted.text = "\(Int(round(slider.value)))%"
    }
}
