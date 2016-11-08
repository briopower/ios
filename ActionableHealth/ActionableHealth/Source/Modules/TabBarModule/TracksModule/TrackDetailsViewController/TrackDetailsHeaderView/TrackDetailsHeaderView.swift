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

}
class TrackDetailsHeaderView: UIView {

    //MARK:- Outlets
    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var templateImage: UIImageView!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var tracksCount: UILabel!
    @IBOutlet weak var commentsCountButton: UIButton!
    
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

}
//MARK:- Additional methods
extension TrackDetailsHeaderView{
    class func getView() -> TrackDetailsHeaderView? {
        let nibArr = NSBundle.mainBundle().loadNibNamed(String(TrackDetailsHeaderView), owner: nil, options: nil)

        for view in nibArr {
            if let headerView = view as? TrackDetailsHeaderView
            {
                headerView.setupFrame()
                return headerView
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
        switch self.type {
        case .Home:
            requestButton.setTitle("JOIN TRACK", forState: .Normal)
        case .Tracks:
            requestButton.setTitle("INVITE MEMBERS", forState: .Normal)
        default:
            break
        }
        currentTemplate = template
        setupView()
    }

    func setupView() {
        templateImage.sd_setImageWithURL(NSURL(string: currentTemplate?.imageUrl ?? ""))
        commentsCountButton.setTitle("\(currentTemplate?.commentsCount ?? 0) Comments", forState: .Normal)
        tracksCount.text = "\(currentTemplate?.activeTrackCount ?? 0) Active Tracks"
        ratingView.value = CGFloat(currentTemplate?.rating ?? 0)
    }
}
