//
//  AboutUsShortViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 06/01/17.
//  Copyright © 2017 Finoit Technologies. All rights reserved.
//

import UIKit

class AboutUsShortViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var txtView: UITextView!

    //MARK:- Variables
    var shouldScroll = true

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txtView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle("About Us", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if shouldScroll {
            txtView.contentOffset = CGPointZero
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        shouldScroll = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Additional methods
extension AboutUsShortViewController{
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

    func tappedInRange(textRange:UITextRange) {
        let readMoreRange = NSString(string: txtView.text).rangeOfString("Read more...")
        let location = txtView.offsetFromPosition(txtView.beginningOfDocument, toPosition: textRange.start)
        let length = txtView.offsetFromPosition(textRange.start, toPosition: textRange.end)
        let tappedTextRange = NSRange(location: location, length: length)
        if NSIntersectionRange(readMoreRange, tappedTextRange).length > 0 {
            readMoreTapped()
        }
    }

    func readMoreTapped() {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.SettingsStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.SettingsStoryboard.aboutUsLongView) as? AboutUsLongViewController {
            getNavigationController()?.pushViewController(viewCont, animated: true)
        }
    }
}
