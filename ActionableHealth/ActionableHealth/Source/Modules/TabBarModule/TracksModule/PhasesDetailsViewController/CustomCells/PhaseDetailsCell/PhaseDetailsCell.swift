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
    case New, InProgress, Paused, Complete, InComplete, Late

    static func getNibName(status:String) -> String{
        if let currentStatus = TaskStatus(rawValue: status) {
            switch currentStatus{
            case .Complete, .InComplete:
                return PhaseDetailsCell.completedCell
            default:
                return PhaseDetailsCell.statusCell
            }
        }
        return ""
    }

    static func getConfig(currentTask:TasksModel) -> (status:String, sliderEnabled:Bool, sliderValue:Double, startStopImage:UIImage?, detailsString:String) {
        if  let status = TaskStatus(rawValue: currentTask.status) {
            switch status {
            case .New:
                return (status.rawValue.uppercaseString, false, 0, UIImage(named: "Start"), "New as on \(NSDate().mediumDateString)")
            case .Paused:
                let date = NSDate.dateWithTimeIntervalInMilliSecs(currentTask.pausedDate)
                return (status.rawValue.uppercaseString, false, currentTask.progress, UIImage(named: "Start"), "Paused on \(date.mediumDateString)")
            case .InProgress:
                return ("IN PROGRESS", true, currentTask.progress, UIImage(named: "Pause"), "In Progress as on \(NSDate().mediumDateString)")
            case .Complete:
                let date = NSDate.dateWithTimeIntervalInMilliSecs(currentTask.completedDate)
                return (status.rawValue.uppercaseString, false, currentTask.progress, nil, "Completed on \(date.mediumDateString)")
            case .InComplete:
                let date = NSDate.dateWithTimeIntervalInMilliSecs(currentTask.completedDate)
                return (status.rawValue.uppercaseString, false, currentTask.progress, nil, "Marked Incomplete on \(date.mediumDateString)")
            default:
                break
            }
        }
        return ("", false, 0, nil, "")
    }
}

class PhaseDetailsCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var topView: UIView?
    @IBOutlet weak var taskNameLabel: UILabel?
    @IBOutlet weak var completedOnlabel: UILabel?
    @IBOutlet weak var commentCountButton: UIButton?
    @IBOutlet weak var starRatingView: HCSStarRatingView?
    @IBOutlet weak var ratingLabel: UILabel?
    @IBOutlet weak var rateTaskButton: UIButton?
    @IBOutlet weak var statusLabel: UILabel?
    @IBOutlet weak var slider: UISlider?
    @IBOutlet weak var taskCompleted: UITextField?
    @IBOutlet weak var startStopButton: UIButton?

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
        setProgress(round(sender.value))
    }
    @IBAction func sliderTouchUpOutside(sender: UISlider) {
        updateCompleted()
        setProgress(round(sender.value))
    }

    @IBAction func startStopAction(sender: UIButton) {
        if let status = TaskStatus(rawValue: currentTask?.status ?? ""){
            switch status {
            case .New, .Paused:
                setStatus(TaskStatus.InProgress)
            case .InProgress:
                setStatus(TaskStatus.Paused)
            default:
                break
            }
        }
    }
}

//MARK:- Additional methods
extension PhaseDetailsCell{
    func configureCell(obj:TasksModel) {
        currentTask = obj
        taskNameLabel?.text = currentTask?.taskName.uppercaseString ?? ""
        starRatingView?.value = CGFloat(currentTask?.rating ?? 0)
        ratingLabel?.text = "\(currentTask?.rating ?? 0) Rating"

        if obj.parentPhase.parentTemplate.objectType == ObjectType.Track {
            commentCountButton?.setTitle("\(currentTask?.commentsCount ?? 0) Comment(s)", forState: .Normal)
            commentCountButton?.hidden = currentTask?.key.getValidObject() == nil
            rateTaskButton?.hidden = currentTask?.key.getValidObject() == nil

            let (status, sliderEnabled, sliderValue, startStopImage, details) = TaskStatus.getConfig(obj)
            statusLabel?.text = status
            slider?.enabled = sliderEnabled
            startStopButton?.setImage(startStopImage, forState: .Normal)
            slider?.value = Float(sliderValue) ?? 0
            completedOnlabel?.text = details
            updateCompleted()
        }
    }

    func updateCompleted() {
        taskCompleted?.text = "\(Int(round(slider?.value ?? 0)))%"
    }

    func setStatus(taskStatus:TaskStatus) {
        
        if NetworkClass.isConnected(true), let key = currentTask?.key {
            startStopButton?.enabled = false
            NetworkClass.sendRequest(URL: Constants.URLs.setStatus, RequestType: .POST, ResponseType: .JSON, Parameters: TasksModel.getDictForStatus(key, status: taskStatus.rawValue), Headers: nil, CompletionHandler: {
                (status, responseObj, error, statusCode) in
                if status{
                    self.currentTask?.status = taskStatus.rawValue
                    if let task = self.currentTask{
                        self.configureCell(task)
                    }
                    self.getTableView()?.reloadData()
                }
                self.startStopButton?.enabled = true
            })
        }
    }

    func setProgress(progress:Float) {
        if progress == 100{
            UIAlertController.showAlertOfStyle(.Alert, Title: "Confirm mark this as complete?", Message: nil, OtherButtonTitles: ["YES"], CancelButtonTitle: "NO", completion: { (tappedAtIndex) in
                if tappedAtIndex == -1{
                    if let task = self.currentTask{
                        self.configureCell(task)
                    }
                }else{
                    self.updateProgress(progress)
                    self.setStatus(TaskStatus.Complete) 
                }
            })
        }else{
            updateProgress(progress)
        }
    }

    func updateProgress(progress:Float) {
        if NetworkClass.isConnected(true), let key = currentTask?.key {
            slider?.enabled = false
            NetworkClass.sendRequest(URL: Constants.URLs.setProgress, RequestType: .POST, ResponseType: .JSON, Parameters: TasksModel.getDictForProgress(key, progress: "\(progress/100)"), Headers: nil, CompletionHandler: {
                (status, responseObj, error, statusCode) in
                if status{
                    self.currentTask?.progress = Double(progress)
                    if let task = self.currentTask{
                        self.configureCell(task)
                    }
                }
                self.slider?.enabled = true
            })
        }
    }

}
