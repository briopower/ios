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
    func taskFilesTapped(tag:Int, obj:AnyObject?)
    func readMoreTapped(tag:Int, obj:AnyObject?)
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
                return ("COMPLETED", false, currentTask.progress, nil, "Completed on \(date.mediumDateString)")
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
    @IBOutlet weak var taskDetailsTextView: UITextView?

    //MARK:- Variables
    static var statusCell = "PhaseDetailsCell_Status"
    static var completedCell = "PhaseDetailsCell_Completed"

    weak var delegate:PhaseDetailsCellDelegate?
    var currentTask:TasksModel?
    let readMoreString = "...Read more"
    var tapGesture:UITapGestureRecognizer?
    
    //MARK:- -------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        if tapGesture?.view == nil{
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.textViewTapped(_:)))
            taskDetailsTextView?.addGestureRecognizer(tapGesture!)
        }
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

    @IBAction func textViewTapped(sender: UITapGestureRecognizer) {
        if let textView = sender.view as? UITextView {
            let location = sender.locationInView(textView)
            if let tapPostion = textView.closestPositionToPoint(location) {
                if let range = textView.tokenizer.rangeEnclosingPosition(tapPostion, withGranularity: .Word, inDirection: UITextLayoutDirection.Right.rawValue){
                    tappedInRange(range)
                }
            }
        }
    }

    @IBAction func taskFiles(sender: UIButton) {
        delegate?.taskFilesTapped(self.tag, obj: currentTask)
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
            commentCountButton?.setTitle("\(currentTask?.commentsCount ?? 0) Journals", forState: .Normal)
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
        configDetailsText()
    }

    func configDetailsText() {
        if let text = currentTask?.details {

            let fixSize = 250
            let customFont = (UIFont.getAppRegularFontWithSize(17) ?? UIFont.systemFontOfSize(17)).getDynamicSizeFont()
            let customBoldFont = (UIFont.getAppSemiboldFontWithSize(17) ?? UIFont.boldSystemFontOfSize(17)).getDynamicSizeFont()
            let mutableAttrString = NSMutableAttributedString(string: "")

            if text.characters.count <= fixSize {
                mutableAttrString.appendAttributedString(NSAttributedString(string: text, attributes: [NSFontAttributeName : customFont]))
            }else{
                let numberOfCharToAccept = fixSize - readMoreString.characters.count
                let acceptableString = text.substringWithRange(text.startIndex ..< text.startIndex.advancedBy(numberOfCharToAccept))
                mutableAttrString.appendAttributedString(NSAttributedString(string: acceptableString, attributes: [NSFontAttributeName : customFont]))
                mutableAttrString.appendAttributedString(NSAttributedString(string: readMoreString, attributes: [NSFontAttributeName : customBoldFont]))
            }
            taskDetailsTextView?.attributedText = mutableAttrString

        }else{
            taskDetailsTextView?.attributedText = nil
        }

    }

    func tappedInRange(textRange:UITextRange) {
        if let txtView = taskDetailsTextView {
            let readMoreRange = NSString(string: txtView.text).rangeOfString(readMoreString)
            let location = txtView.offsetFromPosition(txtView.beginningOfDocument, toPosition: textRange.start)
            let length = txtView.offsetFromPosition(textRange.start, toPosition: textRange.end)
            let tappedTextRange = NSRange(location: location, length: length)
            if NSIntersectionRange(readMoreRange, tappedTextRange).length > 0 {
                delegate?.readMoreTapped(self.tag, obj: currentTask)
            }
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
                    switch taskStatus{
                    case .Complete:
                        self.currentTask?.completedDate = NSDate().timeIntervalInMilliSecs()
                    case .Paused:
                        self.currentTask?.pausedDate = NSDate().timeIntervalInMilliSecs()
                    default:
                        break
                    }
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
