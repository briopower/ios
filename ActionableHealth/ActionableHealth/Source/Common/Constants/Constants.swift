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
            static let signupView = "signupView"
            static let loginView = "loginView"
            static let forgotPasswordView = "forgotPasswordView"
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
            static let changePasswordView = "changePasswordView"
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
            static let commentsView = "commentsView"
            static let trackFileView = "trackFileView"
            static let phaseDetailsView = "phaseDetailsView"
        }
    }

    //MARK:- URLs
    struct URLs {
        static let base = "https://briopower-qa.appspot.com/"

        static let authAPIs = "auth/"
        static let signup = "\(base)\(authAPIs)create/"
        static let login = "\(base)\(authAPIs)authenticate/"
        static let logOut="\(base)\(authAPIs)logout/"
        static let forgotPasswordNotification = "\(base)\(authAPIs)resetPasswordNotification/"
        static let allTemplates = "\(base)\(authAPIs)getAllTemplates/"
        static let templateDetails = "\(base)\(authAPIs)getTemplateDetails/"
        static let updateDetails = "\(base)\(authAPIs)updatePassword"

        static let trackAPIs = "track/"
        static let myTracks = "\(base)\(trackAPIs)getMyTracks"
        static let trackDetails = "\(base)\(trackAPIs)getTrackDetails/"
        static let trackFiles = "\(base)\(trackAPIs)downloadAttachment/"
    }
}
