//
//  TrackPhasesCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 19/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
protocol TrackPhasesCellDelegate:NSObjectProtocol {
    func taskFilesTapped(tag:Int, obj:AnyObject?)
    func numberOfTasksTapped(tag:Int, obj:AnyObject?)
}

class TrackPhasesCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var numberOfTask: UIButton!
    @IBOutlet weak var webView: UIWebView!

    @IBOutlet var resourceView: UIView!

    @IBOutlet var resourceButtonHeightConstraint: NSLayoutConstraint!
    //MARK:- Variables
    weak var delegate:TrackPhasesCellDelegate?
    var currentPhase:PhasesModel?

    //MARK:- -------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        webView.scrollView.showsVerticalScrollIndicator = false
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

//MARK:- Additional methods
extension TrackPhasesCell{
    func configCell(phase:PhasesModel) {
        currentPhase = phase
        nameLabel.text = currentPhase?.phaseName ?? ""
//        if(currentPhase?.tasks.count > 0){
//            resourceButtonHeightConstraint.constant = 0.8 * resourceView.frame.size.height
//        }else{
//            
//        }
//        ratingLabel.text = "\(currentPhase?.rating ?? 0) Rating"
        if let count = currentPhase?.tasks.count{
            if count == 1 || count == 0{
                numberOfTask.setTitle("\(count) Task", forState: .Normal)
            }else{
                numberOfTask.setTitle("\(count) Tasks", forState: .Normal)
            }
        }else{
            numberOfTask.setTitle("", forState: .Normal)
        }
        webView.loadHTMLString(currentPhase?.details ?? "", baseURL: nil)
    }
    
    @IBAction func numberOfTaskAction(sender: UIButton) {
        delegate?.numberOfTasksTapped(self.tag, obj: currentPhase)
    }
    
    @IBAction func resourcesAction(sender: UIButton) {
        delegate?.taskFilesTapped(self.tag, obj: currentPhase)

    }
}
