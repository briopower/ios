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
    func readMoreTapped(tag:Int, obj:AnyObject?)
}

class TrackPhasesCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var numberOfTaskLabel: UILabel!
    @IBOutlet weak var taskDetailsTextView: UITextView?
    @IBOutlet weak var topHeight: NSLayoutConstraint!

    //MARK:- Variables
    weak var delegate:TrackPhasesCellDelegate?
    var currentPhase:PhasesModel?
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

//MARK:- Additional methods
extension TrackPhasesCell{
    func configCell(phase:PhasesModel) {
        currentPhase = phase
        nameLabel.text = currentPhase?.phaseName ?? ""
        ratingLabel.text = "\(currentPhase?.rating ?? 0) Rating"
        if let count = currentPhase?.tasks.count{
            if count == 1 {
                numberOfTaskLabel.text = "Overall \(count) task"
            }else{
                numberOfTaskLabel.text = "Overall \(count) tasks"
            }
        }else{
            numberOfTaskLabel.text = ""
        }
        configDetailsText()

    }

    func configDetailsText() {
        if let text = currentPhase?.details {
            let fixSize = 250
            let customFont = (UIFont.getAppRegularFontWithSize(17) ?? UIFont.systemFontOfSize(17)).getDynamicSizeFont()
            let mutableAttrString = NSMutableAttributedString(string: "")

            if text.characters.count <= fixSize {
                mutableAttrString.appendAttributedString(NSAttributedString(string: text, attributes: [NSFontAttributeName : customFont]))
            }else{
                let numberOfCharToAccept = fixSize - readMoreString.characters.count
                let acceptableString = text.substringWithRange(text.startIndex ..< text.startIndex.advancedBy(numberOfCharToAccept))
                mutableAttrString.appendAttributedString(NSAttributedString(string: acceptableString, attributes: [NSFontAttributeName : customFont]))
                mutableAttrString.appendAttributedString(NSAttributedString(string: readMoreString, attributes: [NSFontAttributeName : customFont,
                    NSForegroundColorAttributeName: UIColor.blueColor()]))
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
                delegate?.readMoreTapped(self.tag, obj: currentPhase)
            }
        }
    }

    @IBAction func taskFiles(sender: UIButton) {
        delegate?.taskFilesTapped(self.tag, obj: currentPhase)
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
}
