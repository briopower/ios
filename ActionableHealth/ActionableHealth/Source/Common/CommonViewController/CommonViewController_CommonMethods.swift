//
//  CommonViewController_CommonMethods.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import UIKit

//MARK:- Loader methods
extension CommonViewController{
    func showLoader() {
        if showLoading {
            loader = self.view.showLaoder(true)
        }
    }

    func showLoaderOnWindow() {
        if let window = UIApplication.sharedApplication().keyWindow where showLoading {
            loader = window.showLaoder(true)
        }
    }

    func hideLoader() {
        loader = nil
        self.view.hideLoader(true)
        UIApplication.sharedApplication().keyWindow?.hideLoader(true)
        UIApplication.enableInteraction()
    }

    func showProgressLoader() {
        showLoader()
        loader?.mode = .Determinate
    }
}

//MARK: NullCase Methods
extension CommonViewController:NullCaseDelegate{
    // Delegate has been implemented in class Because of issue in swift
    func showNullCase(view:UIView, type:NullCaseType, identifier:Int?, shouldPassTouch:Bool = false) {
        hideLoader()
        UIApplication.dismissKeyboard()
        nullCaseView = NullCaseView.showNullCaseOn(view, nullCaseType: type, identifier: identifier, delegate: self, shouldPassTouch: shouldPassTouch)
    }

    func hideNullCase(view:UIView) {
        NullCaseView.hideNullCaseOn(view)
    }
}

