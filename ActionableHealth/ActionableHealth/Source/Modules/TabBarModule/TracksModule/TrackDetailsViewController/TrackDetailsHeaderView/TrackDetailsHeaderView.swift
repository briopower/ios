//
//  TrackDetailsHeaderView.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 19/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
enum TrackDetailsSourceType:Int {
    case templates, tracks, count
}
enum TrackButtonTypes:Int {
    case comment, invite, edit
}
enum TemplateButtonTypes:Int {
    case follower, unfollow, comment, activeGroups, createGroup, follow
}

protocol TrackDetailsHeaderViewDelegate:NSObjectProtocol {
    func commentsTapped(_ type:TrackDetailsSourceType)
    func requestButtonTapped(_ type:TrackDetailsSourceType)
    func showImagePicker()
    func rateGroup()
}

class TrackDetailsHeaderView: UIView {

    //MARK:- Outlets
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var rateGroupButton: UIButton?
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
    @IBOutlet weak var nameLabel: UILabel?

    //MARK:- Variables
    static let heightOf1PxlWidthTemplate:CGFloat = 1.2663438257
    static let heightOf1PxlWidthTrack:CGFloat = 1.0403551251

    weak var delegate:TrackDetailsHeaderViewDelegate?
    var type:TrackDetailsSourceType = TrackDetailsSourceType.templates
    var currentTemplate:TemplatesModel?
}

//MARK:- Button Action
extension TrackDetailsHeaderView{
    @IBAction func buttonAction(_ sender: UIButton) {
        switch type {
        case .templates:
            if let buttonType = TemplateButtonTypes(rawValue: sender.tag) {
                switch buttonType {
                case .activeGroups, .follower:
                    debugPrint("No Actions")
                case .comment:
                    delegate?.commentsTapped(type)
                case .createGroup:
                    delegate?.requestButtonTapped(type)
                case .follow, .unfollow:
                    followUnfollowTapped()
                }
            }
        case .tracks:
            if let buttonType = TrackButtonTypes(rawValue: sender.tag) {
                switch buttonType {
                case .comment:
                    delegate?.commentsTapped(type)
                case .invite:
                    delegate?.requestButtonTapped(type)
                case .edit:
                    delegate?.showImagePicker()
                }
            }
        default:
            break
        }
    }

    @IBAction func rateGroupAction(_ sender: UIButton) {
        delegate?.rateGroup()
    }
}
//MARK:- Additional methods
extension TrackDetailsHeaderView{
    class func getView(_ type:TrackDetailsSourceType) -> TrackDetailsHeaderView? {
        let nibName = type == .templates ? "TrackDetailsHeaderView_Template" : "TrackDetailsHeaderView_Track"
        if let nibArr = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil){
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

    func setupFrame(_ type:TrackDetailsSourceType = .templates) {
        CommonMethods.addShadowToView(topContainer)
        CommonMethods.addShadowToTabBar(bottomContainer)
        requestButton3?.layer.borderWidth = 1
        requestButton3?.layer.borderColor = UIColor.getAppThemeColor().cgColor
        switch type {
        case .templates:
            self.frame = CGRect(x: 0, y: 0, width: UIDevice.width(), height: UIDevice.width() * TrackDetailsHeaderView.heightOf1PxlWidthTemplate)
        case .tracks:
            self.frame = CGRect(x: 0, y: 0, width: UIDevice.width(), height: UIDevice.width() * TrackDetailsHeaderView.heightOf1PxlWidthTrack)
        default:
            break
        }
    }

    func setupForType(_ type:TrackDetailsSourceType, template:TemplatesModel?) {
        self.type = type
        currentTemplate = template
        ratingView.value = CGFloat(currentTemplate?.rating ?? 0)
        rateGroupButton?.isHidden = currentTemplate?.key == nil
        nameLabel?.text = template?.name
        switch self.type {
        case .templates:
            logoImageView.image = UIImage(named: "logo-1")
            templateImage.sd_setImage(with: URL(string: currentTemplate?.templateImageUrl ?? ""))
            detailsButton1?.setTitle("\(currentTemplate?.followersCount ?? 0) Follower(s)", for: UIControlState())
            detailsButton2?.setTitle("\(currentTemplate?.commentsCount ?? 0) Group Message(s)", for: UIControlState())
            detailsButton3?.setTitle("\(currentTemplate?.activeTrackCount ?? 0) Active Group(s)", for: UIControlState())
            setupFollowUnfollowButton()
        case .tracks:
            templateImage.sd_setImage(with: URL(string: currentTemplate?.trackImageUrl ?? ""))
            logoImageView.sd_setImage(with: URL(string: currentTemplate?.templateImageUrl ?? ""))
            detailsButton1?.setTitle("\(currentTemplate?.commentsCount ?? 0) Group Message(s)", for: UIControlState())
            editButton?.isHidden = !(UserDefaults.getUserId() == currentTemplate?.createdBy)
            requestButton1?.isHidden = editButton?.isHidden ?? true
        default:
            break
        }
    }

    func followUnfollowTapped() {
        let check = currentTemplate?.isFollowing ?? false
        updateFollowingStatus(!check)
    }

    func updateFollowingStatus(_ shouldFollow:Bool) {
        if NetworkClass.isConnected(true) {
            requestButton1?.isEnabled = false
            requestButton3?.isEnabled = false
            NetworkClass.sendRequest(URL: Constants.URLs.follow, RequestType: .post, ResponseType: .json, Parameters: currentTemplate?.getFollowingDict(shouldFollow) as AnyObject, Headers: nil, CompletionHandler: { (status, responseObj, error, statusCode) in
                if status{
                    self.currentTemplate?.updateFollowers(responseObj)
                    self.setupForType(self.type, template: self.currentTemplate)
                }
                self.requestButton1?.isEnabled = true
                self.requestButton3?.isEnabled = true

            })
        }
    }
    
    func setupFollowUnfollowButton() {
        let check = currentTemplate?.isFollowing ?? false
        UIView.animate(withDuration: 0.1, animations: {
            self.requestButton1?.alpha = check ? 1 : 0
            self.requestButton3?.alpha = check ? 0 : 1
        }) 

    }
}

