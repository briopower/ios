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
            static let countryList = "countryListView"
            static let verificationView = "welcomeToBrio"
            static let textDetailsView = "textDetailsView"
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
            static let termsAndConditionsView = "termsAndConditionsView"
            static let aboutUsShortView = "aboutUsShortView"
            static let aboutUsLongView = "aboutUsLongView"
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
            static let searchUserView = "searchUserView"
            static let trackMemberListView = "trackMemberListView"
            static let showTextView = "showTextView"
        }
    }

    //MARK:- URLs
    struct URLs {
        static let countryCodes = "http://country.io/phone.json"
        static let countryNames = "http://country.io/names.json"

//        static let base = "https://briopower-qa.appspot.com/" // Dev
        static let base = "https://briopower-uat.appspot.com/" // UAT

        static let authAPIs = "auth/"
        static let allTemplates = "\(base)\(authAPIs)getAllTemplates/"
        static let templateDetails = "\(base)\(authAPIs)getTemplateDetails/"
        static let requestOtp = "\(base)\(authAPIs)requestOTP/"
        static let verifyOtp = "\(base)\(authAPIs)/validateOTP/"

        static let trackAPIs = "track/"
        static let myTracks = "\(base)\(trackAPIs)getMyTracks/"
        static let trackDetails = "\(base)\(trackAPIs)getTrackDetails/"
        static let phaseDetails = "\(base)\(trackAPIs)phaseOrTaskDetails/"
        static let trackFiles = "\(base)\(trackAPIs)downloadAttachment/"
        static let appUsers = "\(base)\(trackAPIs)appUsers/"
        static let createTrack = "\(base)\(trackAPIs)createTrack/"
        static let inviteMember = "\(base)\(trackAPIs)invite/"
        static let inviteUsersToApp = "\(base)\(trackAPIs)inviteUsersToApp/"
        static let trackMembers = "\(base)\(trackAPIs)getAllTrackMembers/"
        static let comment = "\(base)\(trackAPIs)comment/"
        static let getComments = "\(base)\(trackAPIs)getComments/"
        static let setStatus = "\(base)\(trackAPIs)setStatus/"
        static let setProgress = "\(base)\(trackAPIs)setProgress/"
        static let rating = "\(base)\(trackAPIs)setRating/"
        static let createUploadURL = "\(base)\(trackAPIs)createUploadURL/"
        static let uploadProfileImage = "\(base)\(trackAPIs)uploadProfileImage/"
        static let profileImageURL = "\(base)\(trackAPIs)profileImageURL/"
        static let updateMyProfile = "\(base)\(trackAPIs)updateMyProfile/"
        static let openChatSession = "\(base)\(trackAPIs)openChatSession/"
        static let closeChatSession = "\(base)\(trackAPIs)closeChatSession/"
        static let broadCastPresence = "\(base)\(trackAPIs)broadCastPresence/"
        static let postMessage = "\(base)\(trackAPIs)postMessage/"
        static let postNotification = "\(base)\(trackAPIs)postNotification/"
        static let createTrackUploadURL = "\(base)\(trackAPIs)createTrackUploadURL/"
        static let searchUser = "\(base)\(trackAPIs)searchAppUsers/"
        static let sendToken = "\(base)\(trackAPIs)saveDeviceToken/"
        static let follow = "\(base)\(trackAPIs)follow/"
    }
}
