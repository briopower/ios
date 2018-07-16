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
    case noInternet, noData, errorFetching, count
}
//MARK:- Constant
let NullCaseTag = Int.min

//MARK:- Protocol
protocol NullCaseDelegate:NSObjectProtocol{
    func retryButtonTapped(_ nullCaseType:NullCaseType, identifier:Int?)
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
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if shouldPassTouch {
            if let frame = self.viewWithTag(99)?.frame {
                if frame.contains(point){
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
    @IBAction func retryTapped(_ sender: UIButton) {
        if let obj = delegate {
            obj.retryButtonTapped(nullCaseType!, identifier: identifier)
        }
    }

}

//MARK:- Private methods
extension NullCaseView{
    fileprivate class func getViewForNullCase(_ obj:AnyObject) -> UIView?{
        var viewForNullCase:UIView?
        if let viewCont = obj as? UIViewController{
            viewForNullCase = viewCont.view
        }else if let view = obj as? UIView{
            viewForNullCase = view
        }
        return viewForNullCase
    }

    fileprivate class func getNullCaseView(_ obj:AnyObject) -> NullCaseView{
        if let viewForNullCase = getViewForNullCase(obj) {
            if let nullCaseView = viewForNullCase.viewWithTag(NullCaseTag) as? NullCaseView {
                return nullCaseView
            }else{
                if let nibArr = Bundle.main.loadNibNamed(String(describing: NullCaseView), owner: nil, options: nil){
                    for view in nibArr {
                        if let nullCaseView = view as? NullCaseView
                        {
                            return nullCaseView
                        }
                    }
                }
            }
        }
        return NullCaseView()
    }

    fileprivate func setupView(_ nullCaseType:NullCaseType, identifier:Int?, delegate:NullCaseDelegate?, shouldPassTouch:Bool){
        self.nullCaseType = nullCaseType
        self.identifier = identifier
        self.delegate = delegate
        self.shouldPassTouch = shouldPassTouch
        self.tag = NullCaseTag
        configureView(nullCaseType)
    }
    fileprivate func configureView(_ type:NullCaseType){
        switch type {
        case .noInternet:
            nullCaseSetup("", nullCaseImageName: "no-internet", description: "No Internet", buttonTitle: "Retry", buttonImageName: nil)
            button.isHidden = false
        case .noData:
            nullCaseSetup("", nullCaseImageName: "no-feed", description: "No Data Available", buttonTitle: "Retry", buttonImageName: nil)
            button.isHidden = true
        case .errorFetching:
            nullCaseSetup("", nullCaseImageName: "no-feed", description: "Error Fetching Data", buttonTitle: "Retry", buttonImageName: nil)
            button.isHidden = false
        default:
            break
        }
    }
    fileprivate func nullCaseSetup(_ title:String?, nullCaseImageName:String?, description:String?, buttonTitle:String?, buttonImageName:String?) {

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
            button.setTitle(text, for: UIControlState())
        }else{
            button.setTitle(nil, for: UIControlState())
        }

        //Button Image
        if let imageName = buttonImageName {
            button.setImage(UIImage(named:imageName), for: UIControlState())
        }else{
            button.setImage(nil, for: UIControlState())
        }
    }
}

//MARK:- Additional methods
extension NullCaseView{

    class func showNullCaseOn(_ obj:AnyObject, nullCaseType:NullCaseType, identifier:Int?, delegate:NullCaseDelegate?, shouldPassTouch:Bool) -> NullCaseView? {

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

    class func hideNullCaseOn(_ obj:AnyObject){
        if getNullCaseView(obj).superview != nil {
            getNullCaseView(obj).removeFromSuperview()
        }
    }
}
