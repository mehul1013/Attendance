//
//  Constants.swift
//  controlcast
//
//  Created by Openxcell Game on 24/11/16.
//  Copyright © 2016 Openxcell Game. All rights reserved.
//

import UIKit

class Constants: NSObject {
    
    static let AppName     = "CleanDate"
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let UserDefault = UserDefaults.standard
    
    //GIPHY API KEY
    static let API_KEY_GIPHY = "dc6zaTOxFJmzC"
    
    static let CleanDate_WebSite     = "https://www.cleandate.com"
    
    static let Bucket_Path          = "apexusers/profileimages"
    static let Verify_Bucket_Path   = "apexusers/verifyidentityimages"
    
    //Image Downloading Temp PREFIX
    static let IMAGE_PREFIX         = "https://d1riy88ht7pokm.cloudfront.net/profileimages/"
    
    //Profile Images Folder - inside Temp directory
    static let Directory_Profile_images     = "ProfileImages"
    static let Directory_Instagram_images   = "InstagramImages"
    static let Directory_GIF                = "GIF"
    
    static var Directory_Profile_images_Path = NSTemporaryDirectory().appending(Constants.Directory_Profile_images).appending("/")
    static var Directory_Instagram_images_Path = NSTemporaryDirectory().appending(Constants.Directory_Instagram_images).appending("/")
    static var Directory_GIF_Path = NSTemporaryDirectory().appending(Constants.Directory_GIF).appending("/")
    
    
    //MARK: - COLORS
    static let COLOR_NAV_BAR = UIColor(colorLiteralRed: 83/255.0, green: 83/255.0, blue: 99/255.0, alpha: 1.0)
    static let COLOR_NAV_BAR_RED_TITLE = UIColor(colorLiteralRed: 245/255.0, green: 114/255.0, blue: 115/255.0, alpha: 1.0)
    static let COLOR_LIGHT_GRAY_BACKGROUND = UIColor(colorLiteralRed: 242/255.0, green: 243/255.0, blue: 245/255.0, alpha: 1.0)
    static let COLOR_GREEN_USERNAME = UIColor(colorLiteralRed: 0/255.0, green: 128/255.0, blue: 64/255.0, alpha: 1.0)
    static let COLOR_GREEN_VERIFIED = UIColor(colorLiteralRed: 26/255.0, green: 182/255.0, blue: 155/255.0, alpha: 1.0)
    
    static let COLOR_FACEBOOK = UIColor(colorLiteralRed: 64/255.0, green: 93/255.0, blue: 159/255.0, alpha: 1.0)
    
    
    //MARK: - Fonts
    struct Fonts {
        static let Helvetica_LTstd_BLK      = "HelveticaLTStd-Blk"
        static let Helvetica_LTstd_Bold     = "HelveticaLTStd-Bold"
        static let Helvetica_LTstd_Light    = "HelveticaLTStd-Light"
        static let Helvetica_LTstd_Roman    = "HelveticaLTStd-Roman"
        
        static let Roboto_Light             = "Roboto-Light"
        static let Roboto_Regular           = "Roboto-Regular"
        static let Roboto_Bold              = "Roboto-Bold"
        static let Roboto_Medium            = "Roboto-Medium"
    }
    
    //MARK: - Storyboards
    struct StoryBoardFile {
        static let MAIN         = "Main"
        static let SETTINGS     = "Settings"
        static let MESSAGES     = "Messages"
    }
    
    //MARK: - Storyboard Identifier
    struct StoryBoardIdentifier {
        
        //Navigation Controller
        static let storyNavigationVC                    = "NavigationController"
        
        
        // Main StoryBoard
        static let storyIntroductionVC                  = "Introduction"
        static let storyDashboardVC                     = "Dashboard"
        
        
        
        
        static let storySuggestPeoplesVC                = "SuggestPeoples"
        
        
        // Setting StoryBoard
        static let storySettingsVC                      = "Settings"
        static let storyViewProfileVC                   = "ViewProfile"
        static let storyEditProfileVC                   = "EditProfile"
        static let storyAppSettingVC                    = "AppSetting"
        static let storyUsernameVC                      = "Username"
        static let storyVerifyVC                        = "VerifyIdentity"
        static let storyWebViewVC                       = "WebViewController"
        static let storySelectOptionVC                  = "SelectOption"
        static let storyDiscoveryVC                     = "DiscoveryPreference"
        static let storyInstagramPhotosVC               = "InstagramPhotosViewer"
        
        
        // Messages StoryBoard
        static let storyMessagesVC                      = "Messages"
        static let storyChatVC                          = "Chat"
        static let storySearchMatchesVC                 = "SearchMatches"
        
    }
}


//MARK: - Screen Size
struct ScreenSize {
    static let screen_width         = UIScreen.main.bounds.size.width
    static let screen_height        = UIScreen.main.bounds.size.height
    static let screen_maxLength    = max(ScreenSize.screen_width, ScreenSize.screen_height)
    static let screen_minLength    = min(ScreenSize.screen_width, ScreenSize.screen_height)
}


//MARK: - Device Type
struct DeviceType {
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screen_maxLength < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screen_maxLength == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screen_maxLength == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screen_maxLength == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.screen_maxLength == 1024.0
}

//MARK: - Version
struct Version {
    
    static let SYS_VERSION_FLOAT = (UIDevice.current.systemVersion as NSString).floatValue
    static let iOS7 = (Version.SYS_VERSION_FLOAT < 8.0 && Version.SYS_VERSION_FLOAT >= 7.0)
    static let iOS8 = (Version.SYS_VERSION_FLOAT >= 8.0 && Version.SYS_VERSION_FLOAT < 9.0)
    static let iOS9 = (Version.SYS_VERSION_FLOAT >= 9.0 && Version.SYS_VERSION_FLOAT < 10.0)
    static let iOS10 = (Version.SYS_VERSION_FLOAT >= 10.0 && Version.SYS_VERSION_FLOAT < 11.0)
    
}

//MARK: - Platform
struct Platform {
    
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

//MARK: - Device iPhone | iPad
enum UIUserInterfaceIdiom : Int {
    
    case unspecified
    case phone
    case pad
}

enum SettingScreensEnum {
    case termsofUse
    case privacyPolicy
    case refer
    case faq
    case aboutus
}

struct SettingsScreenNames {
    
    static let TermsofUse            = "Terms of Use"
    static let PrivacyPolicy         = "Privacy Policy"
    static let Refer_Friend          = "Refer a Friend"
    static let FAQ                   = "FAQ"
    static let AboutUs               = "About Us"
    
}

//MARK: - Alert Messages
struct AlertMessages {
    
    static let USER_ID               = "userID"
    static let OK_TEXT               = "OK"
    static let YES_TEXT              = "Yes"
    static let NO_TEXT               = "No"
    static let EMAIL_ALERT           = "Please enter your Email Address"
    static let PASSWORD_ALERT        = "Please enter your Password"
    static let USERNAME_ALERT        = "Please enter your Username"
    static let VALID_EMAIL_ALERT     = "Please enter valid Email Address"
    static let CONFIRM_PASSWD_ALERT  = "Please enter confirm your Password"
    static let UNMATCHED_PASSWORD    = "Your Password does not match"
    static let CURRENT_PASSWORD      = "Please enter your Current Password"
    static let NEW_PASSWORD_ALERT    = "Please enter new password"
    static let VALIDATE_PASSWORD     = "Please enter atleast 6 characters Password"
    static let WEBSITE_NOT_REACHABLE = "Website can't reachable"
    
    static let NO_LOCATION_PERMISSION = "No Location Permission"
    static let ENABLE_LOCATION       = "To re-enable, please go to Settings and turn on Location Service for this app."
    
    static let CAMERA_PERMISSION = "Camera Permission"
    static let ENABLE_CAMERA     = "To re-enable, please go to Settings and turn on Camera access for this app."
    
    //Instagram
    static let CONNECT_INSTAGRAM    = "Connect Instagram"
    static let DISCONNECT_INSTAGRAM = "Disconnect Instagram"
    static let DISCONNECT_INSTAGRAM_MESSAGE = "Your instagram photos will be removed from your CleanDate profile."
    
    static let LOGOUT   =   "Are you sure you want to logout? You will continue to be seen by compatible users in your last known location"
    static let DELETE_ACCOUNT   =   "If you delete your account, you will permently lose your profile, messages, photos and matches. \n\nIf you'd rather keep your account but simply hide your card you can disable discovery instead. \n\nAre you sure you want to delete your account?"
    
    static let NO_WORK   = "We not found any work related information from your Facebook account. Please update it on your account."
    static let NO_SCHOOL = "We not found any education related information from your Facebook account. Please update it on your account."
    
    
}

//Edit Profile
struct SelectedOption {
    static let CURRENT_WORK     =   11
    static let SCHOOL           =   12
    static let GENDER           =   13
    static let SHOW_ME          =   14
    static let PROFILE          =   15
}


//Font
/*
 *****Gotham Bold*****
 GothamBold
 GothamBold-Italic
 
 *****Gotham ExtraLight*****
 GothamExtraLight
 GothamExtraLight-Italic
 
 *****Gotham Ultra*****
 GothamUltra-Italic
 GothamUltra
 
 *****Gotham*****
 Gotham-Light
 Gotham-BookItalic
 Gotham-Bold
 
 *****Gotham Black*****
 GothamBlack
 GothamBlack-Italic
 
 *****Gotham Thin*****
 GothamThin-Italic
 GothamThin
 
 *****Gotham Medium*****
 GothamMedium-Italic
 GothamMedium
 
 *****Roboto*****
 Roboto-Regular
 Roboto-Black
 Roboto-Light
 Roboto-BoldItalic
 Roboto-LightItalic
 Roboto-Thin
 Roboto-MediumItalic
 Roboto-Medium
 Roboto-Bold
 Roboto-BlackItalic
 Roboto-Italic
 Roboto-ThinItalic
 
 */


