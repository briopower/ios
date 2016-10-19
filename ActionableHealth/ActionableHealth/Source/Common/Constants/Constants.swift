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
            static let SignupView = "signupView"
            static let LoginView = "loginView"
        }

        struct TabBarStoryboard {
            static let storyboardName = "TabBar"
        }

        struct HomeStoryboard {
            static let storyboardName = "Home"
            static let filtersView = "filtersView"
            static let searchView = "searchView"
            static let notificationNavigationView = "notificationNavigationView"
            static let notificationView = "notificationView"
        }

        struct GroupsStoryboard {
            static let storyboardName = "Groups"
            static let storyboardRestorationId = "Groups"
            static let groupMemberView = "groupMemberView"
            static let memberDetailsView = "memberDetailsView"
        }

        struct SettingsStoryboard {
            static let storyboardName = "Settings"
            static let editProfileView = "editProfileView"
        }

        struct MessagingStoryboard {
            static let storyboardName = "Chats"
            static let messagingView = "messagingView"
        }

        struct TracksStoryboard {
            static let storyboardName = "Tracks"
            static let trackDetailsView = "trackDetailsView"
            static let inviteTracksView = "inviteTracksView"
            static let joinTracksView = "joinTracksView"
        }
    }

    //MARK:- URLs
    struct URLs {
        static let base = "https://actionablehealth.appspot.com/"
        static let mid = "auth/"
        static let signup = "\(base)\(mid)create/"
        static let login = "\(base)\(mid)authenticate/"
    }
}
