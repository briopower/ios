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
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var completedOnlabel: UILabel!
    @IBOutlet weak var commentCountButton: UIButton!
    @IBOutlet weak var starRatingView: HCSStarRatingView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var rateTaskButton: UIButton!
    @IBOutlet weak var overFlow: UIButton!
    @IBOutlet weak var statusLabel: UILabel!

    //MARK:- Variables

    static var statusCell = "PhaseDetailsCell_Status"
    weak var delegate:PhaseDetailsCellDelegate?
    var currentTask:TasksModel?
    let backView = UIView()
    var selectionView : SelectionView?
    var statusSelected : ((cell:PhaseDetailsCell , status:String) ->Void)?
    
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
    @IBAction func overFlowBtnAction(sender: AnyObject) {
        selectionView = SelectionView.getInstance() as? SelectionView
        if let localView = selectionView{
            localView.setUpCell(currentTask?.status ?? "")
            self.setFrameForSelectionView(localView)
            localView.delegate = self
            CommonMethods.addShadowToView(localView)
            self.superview?.addSubview(backView)
            localView.alpha = 0
            UIView.animateWithDuration(0.5, animations: {
                self.superview?.addSubview(localView)
                localView.alpha = 1
            })
        }

    }
}

//MARK:- SelectionView Functions
extension PhaseDetailsCell{
    func setFrameForSelectionView(view:UIView) -> (){
        if let table = self.superview?.superview as? UITableView{
          let rowCount = selectionView?.getRowCount((selectionView?.getCellNameForStatus(currentTask?.status ?? "")) ?? CellName.New)
            let width = (516/1242)*(table.frame.width)
            let height = ((600/2204)*(table.frame.height) * CGFloat(rowCount ?? 3)) / CGFloat(CellName.Count.rawValue)
            let btnFrame =  self.convertRect(overFlow.frame, toView: self.superview)
            //apply cases
            if (table.contentSize.height > table.frame.height){
            if (table.contentSize.height > frame.origin.y + topView.frame.height + height){
                view.frame = CGRect.init(x:btnFrame.origin.x - width + btnFrame.size.width , y:btnFrame.origin.y + topView.frame.height, width: width, height: height)
            }
            else{
                view.frame = CGRect.init(x:btnFrame.origin.x - width + btnFrame.size.width , y:btnFrame.origin.y + topView.frame.height - height, width: width, height: height)
            }
            }
            else{
                if (table.frame.height > frame.origin.y + topView.frame.height + height){
                    view.frame = CGRect.init(x:btnFrame.origin.x - width + btnFrame.size.width , y:btnFrame.origin.y + topView.frame.height, width: width, height: height)
                }
                else{
                    view.frame = CGRect.init(x:btnFrame.origin.x - width + btnFrame.size.width , y:btnFrame.origin.y + topView.frame.height - height, width: width, height: height)
                }
            }
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(PhaseDetailsCell.handleTap(_:)))
            tapGesture.numberOfTapsRequired = 1
            backView.addGestureRecognizer(tapGesture)
            backView.frame = CGRect.init(origin: table.frame.origin, size: table.contentSize)
        }
    }

    func handleTap(sender: UITapGestureRecognizer? = nil){
        selectionView?.alpha = 1
        UIView.animateWithDuration(0.5, animations: {
            self.selectionView?.removeFromSuperview()
            self.selectionView?.alpha = 0
        })
        backView.removeFromSuperview()
    }

    func setStatus(type:CellName){
            if NetworkClass.isConnected(true), let key = currentTask?.key{
                let dict = ["key" : key , "status": type.getApiStatus(type)]
                UIApplication.sharedApplication().keyWindow?.showLaoder(true)
                NetworkClass.sendRequest(URL:Constants.URLs.postStatus, RequestType: .POST, Parameters: dict, Headers: nil, CompletionHandler: {
                    (status, responseObj, error, statusCode) in
                    if status{
                        self.statusLabel.text = type.getStatus(type)
                        self.statusSelected?(cell:self , status: type.getApiStatus(type))
                    }else{

                    }
                    UIApplication.sharedApplication().keyWindow?.hideLoader(true)
                })
            }
                self.handleTap()
    }
}

//MARK:- Additional methods
extension PhaseDetailsCell{
    func configureCell(obj:TasksModel) {
        currentTask = obj
        taskNameLabel.text = currentTask?.taskName ?? ""
        commentCountButton.setTitle("\(currentTask?.commentsCount ?? 0) Comment(s)", forState: .Normal)
        starRatingView.value = CGFloat(currentTask?.rating ?? 0)
        ratingLabel.text = "\(currentTask?.rating ?? 0) Rating"
        commentCountButton.hidden = currentTask?.key.getValidObject() == nil
        rateTaskButton.hidden = commentCountButton.hidden

        if obj.parentPhase.parentTemplate.objectType == ObjectType.Track {
            self.setStatuslabel(obj.status)
        }
    }
    
    func setStatuslabel(status:String){
        switch status {
        case "New":
            statusLabel.text = "NEW"
        case "Complete":
            statusLabel.text = "COMPLETE"
//            statusCell = "PhaseDetailsCell"
            
        case "In progress":
            statusLabel.text = "IN PROGRESS"
        case "Assigned":
            statusLabel.text = "ASSIGNED"
        default:
            statusLabel.text = ""
        }
    }
}
