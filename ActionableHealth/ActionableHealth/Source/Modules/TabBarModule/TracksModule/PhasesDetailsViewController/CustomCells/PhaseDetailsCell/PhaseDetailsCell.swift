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
    @IBOutlet weak var statusLabel: UILabel_FontSizeLabel!
    
    //MARK:- Variables

    static let statusCell = "PhaseDetailsCell_Status"
    weak var delegate:PhaseDetailsCellDelegate?
    var currentTask:TasksModel?
    let backView = UIView()
    var selectionView : SelectionView?
    
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
        delegate?.rateTaskTapped(self.tag, obj: nil)
    }
    @IBAction func overFlowBtnAction(sender: AnyObject) {
        selectionView = SelectionView.getInstance() as? SelectionView
        if let localView = selectionView{
            localView.setUpCell()
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
            let width = (516/1242)*(table.frame.width)
            let height = (600/2204)*(table.frame.height)
            let btnFrame =  self.convertRect(overFlow.frame, toView: self.superview)
            if (table.contentSize.height > frame.origin.y + topView.frame.height + height){
            view.frame = CGRect.init(x:btnFrame.origin.x - width + btnFrame.size.width , y:btnFrame.origin.y + topView.frame.height, width: width, height: height)
            }
            else{
                view.frame = CGRect.init(x:btnFrame.origin.x - width + btnFrame.size.width , y:btnFrame.origin.y + topView.frame.height - height, width: width, height: height)
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
    
    func getSelectedRow(type:cellName){
        switch type {
        case .New:
            statusLabel.text = "NEW"
        case .Complete:
            statusLabel.text = "COMPLETE"
        case .InProgress:
            statusLabel.text = "IN PROGRESS"
        case .incomplete:
            statusLabel.text = "INCOMPLETE"
        default:
            break
        }
        self.handleTap()
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
        commentCountButton.hidden = currentTask?.key.getValidObject() == nil
        if obj.parentPhase.parentTemplate.objectType == ObjectType.Track {
            completedOnlabel.text = obj.status
            rateTaskButton.hidden = false
        }else{
            completedOnlabel.text = nil
            rateTaskButton.hidden = true
        }
    }
}
