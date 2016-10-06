//
//  NullCaseView.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import UIKit

//MARK:- Enum

enum NullCaseType:Int {
    case NoInternet, NoData, ErrorFetching, Count
}
//MARK:- Constant
let NullCaseTag = Int.min

//MARK:- Protocol
protocol NullCaseDelegate:NSObjectProtocol{
    func retryButtonTapped(nullCaseType:NullCaseType, identifier:Int?)
}

//MARK:- Class
class NullCaseView: UIView {
    //MARK:- Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: UIButton!

    //MARK:- Variables
    weak var delegate:NullCaseDelegate?
    var shouldPassTouch = false
    var nullCaseType:NullCaseType!
    var identifier:Int?

    //MARK:- touch passing methods
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        if shouldPassTouch {
            if let frame = self.viewWithTag(99)?.frame {
                if CGRectContainsPoint(frame, point){
                    return true
                }
            }
            return false
        }
        return true
    }
}

//MARK:- Action
extension NullCaseView{
    @IBAction func retryTapped(sender: UIButton) {
        if let obj = delegate {
            obj.retryButtonTapped(nullCaseType!, identifier: identifier)
        }
    }

}

//MARK:- Private methods
extension NullCaseView{
    private class func getViewForNullCase(obj:AnyObject) -> UIView?{
        var viewForNullCase:UIView?
        if let viewCont = obj as? UIViewController{
            viewForNullCase = viewCont.view
        }else if let view = obj as? UIView{
            viewForNullCase = view
        }
        return viewForNullCase
    }

    private class func getNullCaseView(obj:AnyObject) -> NullCaseView{
        if let viewForNullCase = getViewForNullCase(obj) {
            if let nullCaseView = viewForNullCase.viewWithTag(NullCaseTag) as? NullCaseView {
                return nullCaseView
            }else{
                let nibArr = NSBundle.mainBundle().loadNibNamed(String(NullCaseView), owner: nil, options: nil)

                for view in nibArr {
                    if let nullCaseView = view as? NullCaseView
                    {
                        return nullCaseView
                    }
                }
            }
        }
        return NullCaseView()
    }

    private func setupView(nullCaseType:NullCaseType, identifier:Int?, delegate:NullCaseDelegate?, shouldPassTouch:Bool){
        self.nullCaseType = nullCaseType
        self.identifier = identifier
        self.delegate = delegate
        self.shouldPassTouch = shouldPassTouch
        self.tag = NullCaseTag
        configureView(nullCaseType)
    }
    private func configureView(type:NullCaseType){
        switch type {
        case .NoInternet:
            nullCaseSetup("", nullCaseImageName: "no-internet", description: "No Internet", buttonTitle: "Retry", buttonImageName: nil)
            button.hidden = false
        case .NoData:
            nullCaseSetup("", nullCaseImageName: "no-feed", description: "No Data Available", buttonTitle: "Retry", buttonImageName: nil)
            button.hidden = true
        case .ErrorFetching:
            nullCaseSetup("", nullCaseImageName: "no-feed", description: "Error Fetching Data", buttonTitle: "Retry", buttonImageName: nil)
            button.hidden = false
        default:
            break
        }
    }
    private func nullCaseSetup(title:String?, nullCaseImageName:String?, description:String?, buttonTitle:String?, buttonImageName:String?) {

        //Title
        if let text = title {
            titleLabel.text = text
        }else{
            titleLabel.text = nil
        }

        //NullCase Image
        if let imageName = nullCaseImageName {
            imageView.image = UIImage(named:imageName)
        }else{
            imageView.image = nil
        }

        //Description
        if let text = description {
            label.text = text
        }else{
            label.text = nil
        }

        //Button Title
        if let text = buttonTitle {
            button.setTitle(text, forState: .Normal)
        }else{
            button.setTitle(nil, forState: .Normal)
        }

        //Button Image
        if let imageName = buttonImageName {
            button.setImage(UIImage(named:imageName), forState: .Normal)
        }else{
            button.setImage(nil, forState: .Normal)
        }
    }
}

//MARK:- Additional methods
extension NullCaseView{

    class func showNullCaseOn(obj:AnyObject, nullCaseType:NullCaseType, identifier:Int?, delegate:NullCaseDelegate?, shouldPassTouch:Bool) -> NullCaseView? {

        let viewForNullCase = getViewForNullCase(obj)

        if let view = viewForNullCase {

            let nullCaseView = getNullCaseView(obj)
            nullCaseView.setupView(nullCaseType, identifier: identifier, delegate: delegate, shouldPassTouch: shouldPassTouch)
            nullCaseView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
            view.addSubview(nullCaseView)

            return nullCaseView
        }
        return nil
    }

    class func hideNullCaseOn(obj:AnyObject){
        if getNullCaseView(obj).superview != nil {
            getNullCaseView(obj).removeFromSuperview()
        }
    }
}