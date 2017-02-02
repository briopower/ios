//
//  TrackDetailsHeaderView.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 19/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
enum TrackDetailsSourceType:Int {
    case Templates, Tracks, Count
}
enum TrackButtonTypes:Int {
    case Comment, Invite, Edit
}
enum TemplateButtonTypes:Int {
    case Follower, Unfollow, Comment, ActiveGroups, CreateGroup, Follow
}

protocol TrackDetailsHeaderViewDelegate:NSObjectProtocol {
    func commentsTapped(type:TrackDetailsSourceType)
    func requestButtonTapped(type:TrackDetailsSourceType)
    func showImagePicker()
}

class TrackDetailsHeaderView: UIView {

    //MARK:- Outlets
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var bottomContainer: UIView?
    @IBOutlet weak var templateImage: UIImageView!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton?
    @IBOutlet weak var requestButton1: UIButton?
    @IBOutlet weak var requestButton2: UIButton?
    @IBOutlet weak var requestButton3: UIButton?
    @IBOutlet weak var detailsButton1: UIButton?
    @IBOutlet weak var detailsButton2: UIButton?
    @IBOutlet weak var detailsButton3: UIButton?

    //MARK:- Variables
    static let heightOf1PxlWidthTemplate:CGFloat = 1.2663438257
    static let heightOf1PxlWidthTrack:CGFloat = 1.0403551251

    weak var delegate:TrackDetailsHeaderViewDelegate?
    var type:TrackDetailsSourceType = TrackDetailsSourceType.Templates
    var currentTemplate:TemplatesModel?
}

//MARK:- Button Action
extension TrackDetailsHeaderView{
    @IBAction func buttonAction(sender: UIButton) {
        switch type {
        case .Templates:
            if let buttonType = TemplateButtonTypes(rawValue: sender.tag) {
                switch buttonType {
                case .ActiveGroups, .Follower:
                    debugPrint("No Actions")
                case .Comment:
                    delegate?.commentsTapped(type)
                case .CreateGroup:
                    delegate?.requestButtonTapped(type)
                case .Follow, .Unfollow:
                    followUnfollowTapped()
                }
            }
        case .Tracks:
            if let buttonType = TrackButtonTypes(rawValue: sender.tag) {
                switch buttonType {
                case .Comment:
                    delegate?.commentsTapped(type)
                case .Invite:
                    delegate?.requestButtonTapped(type)
                case .Edit:
                    delegate?.showImagePicker()
                }
            }
        default:
            break
        }
    }
}
//MARK:- Additional methods
extension TrackDetailsHeaderView{
    class func getView(type:TrackDetailsSourceType) -> TrackDetailsHeaderView? {
        let nibName = type == .Templates ? "TrackDetailsHeaderView_Template" : "TrackDetailsHeaderView_Track"
        if let nibArr = NSBundle.mainBundle().loadNibNamed(nibName, owner: nil, options: nil){
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

    func setupFrame(type:TrackDetailsSourceType = .Templates) {
        CommonMethods.addShadowToView(topContainer)
        CommonMethods.addShadowToTabBar(bottomContainer)
        requestButton3?.layer.borderWidth = 1
        requestButton3?.layer.borderColor = UIColor.getAppThemeColor().CGColor
        switch type {
        case .Templates:
            self.frame = CGRect(x: 0, y: 0, width: UIDevice.width(), height: UIDevice.width() * TrackDetailsHeaderView.heightOf1PxlWidthTemplate)
        case .Tracks:
            self.frame = CGRect(x: 0, y: 0, width: UIDevice.width(), height: UIDevice.width() * TrackDetailsHeaderView.heightOf1PxlWidthTrack)
        default:
            break
        }
    }

    func setupForType(type:TrackDetailsSourceType, template:TemplatesModel?) {
        self.type = type
        currentTemplate = template
        ratingView.value = CGFloat(currentTemplate?.rating ?? 0)
        switch self.type {
        case .Templates:
            logoImageView.image = UIImage(named: "logo-1")
            templateImage.sd_setImageWithURL(NSURL(string: currentTemplate?.templateImageUrl ?? ""))
            detailsButton1?.setTitle("\(currentTemplate?.followersCount ?? 0) Followers", forState: .Normal)
            detailsButton2?.setTitle("\(currentTemplate?.commentsCount ?? 0) Group Chat", forState: .Normal)
            detailsButton3?.setTitle("\(currentTemplate?.activeTrackCount ?? 0) Active Groups", forState: .Normal)
            setupFollowUnfollowButton()
        case .Tracks:
            templateImage.sd_setImageWithURL(NSURL(string: currentTemplate?.trackImageUrl ?? ""))
            logoImageView.sd_setImageWithURL(NSURL(string: currentTemplate?.templateImageUrl ?? ""))
            detailsButton1?.setTitle("\(currentTemplate?.commentsCount ?? 0) Group Chat", forState: .Normal)
            editButton?.hidden = !(NSUserDefaults.getUserId() == currentTemplate?.createdBy)
            requestButton1?.hidden = editButton?.hidden ?? true
        default:
            break
        }
    }

    func followUnfollowTapped() {
        let check = currentTemplate?.isFollowing ?? false
        updateFollowingStatus(!check)
    }

    func updateFollowingStatus(shouldFollow:Bool) {
        if NetworkClass.isConnected(true) {
            NetworkClass.sendRequest(URL: Constants.URLs.follow, RequestType: .POST, ResponseType: ExpectedResponseType.JSON, Parameters: currentTemplate?.getFollowingDict(shouldFollow), Headers: nil, CompletionHandler: { (status, responseObj, error, statusCode) in
                if status{
                    self.currentTemplate?.updateFollowers(responseObj)
                    self.setupForType(self.type, template: self.currentTemplate)
                }
            })
        }
    }
    
    func setupFollowUnfollowButton() {
        let check = currentTemplate?.isFollowing ?? false
        UIView.animateWithDuration(0.1) {
            self.requestButton1?.alpha = check ? 1 : 0
            self.requestButton3?.alpha = check ? 0 : 1
        }

    }
}

