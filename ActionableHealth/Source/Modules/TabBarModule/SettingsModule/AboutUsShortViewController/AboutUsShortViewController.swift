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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle("About Us", LeftButtonType: BarButtontype.back, RightButtonType: BarButtontype.none)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if shouldScroll {
            txtView.contentOffset = CGPoint.zero
        }
    }

    override func viewDidAppear(_ animated: Bool) {
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
    @IBAction func textViewTapped(_ sender: UITapGestureRecognizer) {
        if let textView = sender.view as? UITextView {
            let location = sender.location(in: textView)
            if let tapPostion = textView.closestPosition(to: location) {
                if let range = textView.tokenizer.rangeEnclosingPosition(tapPostion, with: .word, inDirection: UITextLayoutDirection.right.rawValue){
                    tappedInRange(range)
                }
            }
        }
    }

    func tappedInRange(_ textRange:UITextRange) {
        let readMoreRange = NSString(string: txtView.text).range(of: "Read more...")
        let location = txtView.offset(from: txtView.beginningOfDocument, to: textRange.start)
        let length = txtView.offset(from: textRange.start, to: textRange.end)
        let tappedTextRange = NSRange(location: location, length: length)
        if NSIntersectionRange(readMoreRange, tappedTextRange).length > 0 {
            readMoreTapped()
        }
    }

    func readMoreTapped() {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.SettingsStoryboard.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.SettingsStoryboard.aboutUsLongView) as? AboutUsLongViewController {
            getNavigationController()?.pushViewController(viewCont, animated: true)
        }
    }
}
