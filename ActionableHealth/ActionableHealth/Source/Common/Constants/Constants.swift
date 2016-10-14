//
//  Constants.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 06/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class Constants: NSObject {

    //MARK:- Storyboard
    struct Storyboard {
        struct LoginStoryboard {
            static let storyboardName = "SignupLogin"
            static let storyboardRestorationId = "SignupLogin"
            static let SignupView = "signupView"
            static let LoginView = "loginView"
        }

        struct TabBarStoryboard {
            static let storyboardName = "TabBar"
            static let storyboardRestorationId = "TabBar"
        }

        struct HomeStoryboard {
            static let storyboardName = "Home"
            static let storyboardRestorationId = "Home"
            static let filtersView = "filtersView"
            static let searchView = "searchView"
            static let notificationView = "notificationView"
        }

        struct GroupsStoryboard {
            static let storyboardName = "Groups"
            static let storyboardRestorationId = "Groups"
            static let groupMemberView = "groupMemberView"
            static let memberDetailsView = "memberDetailsView"
        }

    }
}
