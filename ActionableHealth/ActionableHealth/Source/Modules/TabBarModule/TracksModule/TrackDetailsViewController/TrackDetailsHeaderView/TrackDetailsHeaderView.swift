//
//  TrackDetailsHeaderView.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 19/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
enum TrackDetailsSourceType:Int {
    case Home, Tracks, Count
}

protocol TrackDetailsHeaderViewDelegate:NSObjectProtocol {
    func commentsTapped(type:TrackDetailsSourceType)
    func requestButtonTapped(type:TrackDetailsSourceType)
    func showImagePicker()
}
class TrackDetailsHeaderView: UIView {

    //MARK:- Outlets
    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var templateImage: UIImageView!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var commentsCountButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!

    //MARK:- Variables
    static let heightOf1PxlWidth:CGFloat = 1.0628019324
    weak var delegate:TrackDetailsHeaderViewDelegate?
    var type:TrackDetailsSourceType = TrackDetailsSourceType.Home
    var currentTemplate:TemplatesModel?
}

//MARK:- Button Action
extension TrackDetailsHeaderView{
    @IBAction func requestButtonAction(sender: AnyObject) {
        delegate?.requestButtonTapped(type)
    }
    @IBAction func commentsButtonAction(sender: AnyObject) {
        delegate?.commentsTapped(type)
    }
    @IBAction func editButtonAction(sender: AnyObject) {
        delegate?.showImagePicker()
    }
}
//MARK:- Additional methods
extension TrackDetailsHeaderView{
    class func getView() -> TrackDetailsHeaderView? {
        if let nibArr = NSBundle.mainBundle().loadNibNamed(String(TrackDetailsHeaderView), owner: nil, options: nil){
            for view in nibArr {
                if let headerView = view as? TrackDetailsHeaderView
                {
                    headerView.setupFrame()
                    return headerView
                }
            }
        }
        return nil
    }

    func setupFrame() {
        CommonMethods.addShadowToTabBar(bottomContainer)
        self.frame = CGRect(x: 0, y: 0, width: UIDevice.width(), height: UIDevice.width() * TrackDetailsHeaderView.heightOf1PxlWidth)
        setupView()
    }

    func setupForType(type:TrackDetailsSourceType, template:TemplatesModel?) {
        self.type = type
        currentTemplate = template
        switch self.type {
        case .Home:
            requestButton.setTitle("Create Track", forState: .Normal)
            logoImageView.image = UIImage(named: "logo-1")
            templateImage.sd_setImageWithURL(NSURL(string: currentTemplate?.templateImageUrl ?? ""))
        case .Tracks:
            requestButton.setTitle("Invite", forState: .Normal)
            templateImage.sd_setImageWithURL(NSURL(string: currentTemplate?.trackImageUrl ?? ""))
            logoImageView.sd_setImageWithURL(NSURL(string: currentTemplate?.templateImageUrl ?? ""))

            editButton.hidden = !(NSUserDefaults.getUserId() == currentTemplate?.createdBy)
            requestButton.hidden = editButton.hidden
        default:
            break
        }
        setupView()
    }

    func setupView() {
        commentsCountButton.hidden = currentTemplate?.key?.getValidObject() == nil
        commentsCountButton.setTitle("\(currentTemplate?.commentsCount ?? 0) Comment(s)", forState: .Normal)
        ratingView.value = CGFloat(currentTemplate?.rating ?? 0)
    }
}

