//
//  Keys.h
//  XBowling3.1
//
//  Created by Click Labs on 11/24/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//



#ifndef XBowling3_1_Keys_h
#define XBowling3_1_Keys_h

#define APIKey @"158478DC73FA498DB5D29BF13E9033F5"
#define serverAddress @"https://api.xbowling.com/"
#define kTimeoutInterval  50        //Server call timeout interval
#define kTimeoutIntervalForTimer 5
#define kUserAccessToken @"userToken"
#define kLatitude @"latitude"
#define kLongitude @"longitude"
#define kUserEmailId  @"emailId"
#define KIsFacebookLogin @"FacebookLogin"
#define facebookFirstName @"facebookFirstnameSave"
#define facebooklastname @"facebookLastnameSave"
#define kuserName @"userName"

#define kAdsServerCall @"adsServerCallCheck" //check to make ads server call

//Bowling Game Keys
#define kbowlingGameId @"bowlingGameId"
#define kvenueId @"venueID"
#define kcountryId @"countryID"
#define kadministrativeAreaId @"stateID"
#define kuserId @"userID"
#define kbowlerName @"bowlerName"
#define klaneNumber @"laneNumber"
#define kcenterName @"centername"
#define kscoringType @"scoringType"
#define klaneCheckOutId @"laneCheckOutId"
#define kFinalScore @"finalScore"
#define kgameComplete @"isComplete"
#define ksavingGameTags @"GameTags"
#define kDeviceToken @"currentDeviceToken"
#define kaddLoyaltyPoints @"addLoyaltyPointsAtGameEnd"

//Live Score Keys
#define kliveGameCenterName @"bowlingGameCenterName"
#define kliveGameCenterId @"bowlingGameCenterId"
#define kliveScoreUpdate @"updateLiveScore"
#define kliveGameBowlerName @"liveGameBowler"
#define kAddedTags @"AddedTagsFromTagController"

#define kSelectedPackageId @"selectedPacakgeId"
#define kopponentId @"opponentId"
#define kliveCompetitionId @"LiveCompetitionId"
#define kUserStatsPackagePurchased @"userStats"

#define screenBounds  [[UIScreen mainScreen] bounds]
#define TARGET_SIZE CGSizeMake(414, 736)
#define separatorColor [UIColor grayColor]

//My History Keys
#define kInGameHistoryView @"Game History View"
#define kHistoryGameName @"Game Name"

//server response dictionary keys
#define kResponseStatusCode @"responseStatusCode"
#define kResponseString @"responseString"

//Font
#define AvenirDemi @"AvenirNextLTPro-Demi"
#define AvenirRegular @"AvenirNextLTPro-Regular"

// Response Keys For AFNetworking
#define responseCode @"response code of API hit"
#define responseDataDic @"responseDictionary"
#define responseStringAF @"responseString"

// Sizes
#define XbH1size    [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]
#define XbH2size    [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:screenBounds.size.height]
#define XbH3size    [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:screenBounds.size.height]
#define XbGraphLabelsize [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:25/3 currentSuperviewDeviceSize:screenBounds.size.width]

//color
#define XbCurrentBoxcolor  [UIColor colorWithRed:3.0/255.0f green:68.0/255.0f blue:144.0/255.0f alpha:1.0f]
#define coachViewPlayerSeparatorLine [UIColor colorWithRed:33.0/255.0f green:42.0/255.0f blue:51.0/255.0f alpha:1.0f]

#define unPlayedBoxcolor  [UIColor colorWithRed:5.0/255.0f green:14.0/255.0f blue:23.0/255.0f alpha:1.0f]

#define XBBlueTitleButtonNormalStateColor           [UIColor colorWithRed:15.0/255.0f green:93.0/255.0f blue:188.0/255.0f alpha:1.0f]
#define XBBlueTitleButtonHighlightedStateColor  [UIColor lightGrayColor]

#define XBWhiteTitleButtonNormalStateColor           [UIColor whiteColor]
#define XBWhiteTitleButtonHighlightedStateColor  [UIColor colorWithRed:15.0/255.0f green:93.0/255.0f blue:188.0/255.0f alpha:1.0f]

//For rounded blue buttons
#define XBBlueButtonBackgndNormalState   [UIColor colorWithRed:0.0/255 green:118.0/255 blue:250.0/255 alpha:0.5]
#define XBBlueButtonBackgndHighlightedState   [UIColor colorWithRed:0.0/255 green:118.0/255 blue:252.0/255 alpha:0.7]

//Header color & Separator line color
//#define XBHeaderColor           [UIColor colorWithRed:11/255 green:91/255 blue:253/255 alpha:0.1]
//#define XBHeaderColor           [UIColor colorWithRed:0.0/255 green:118.0/255 blue:254.0/255 alpha:0.1]

/////#define XBHeaderColor           [UIColor colorWithRed:140.0/255 green:16.0/255 blue:136.0/255 alpha:0.9]
//#define XBHeaderColor           [UIColor colorWithRed:48.0/255 green:0.0/255 blue:47.0/255 alpha:0.9]
#define XBHeaderColor           [UIColor colorWithRed:12.0/255 green:12.0/255 blue:12.0/255 alpha:0.9]


#define XBlightGraySeparatorLineColor           [UIColor colorWithRed:100.0/255.0f green:100.0/255.0f blue:100.0/255.0f alpha:0.6]

//Table view cell Highlighted color
#define kCellNormalColor [UIColor colorWithRed:11.0/255 green:91.0/255 blue:253.0/255 alpha:0.1]
#define kCellHighlightedColor [UIColor colorWithRed:6.0/255 green:36.0/255 blue:86.0/255 alpha:0.6]

#define orientaion @"orientaion"

//Notification
#define currentUnreadAllNotification @"unreadNotifications"

//user stats keys for gamePlay
#define kUserStatsPackagePurchased @"userStats"
#define kGameType @"gameType"
#define kBallType @"ballType"   //to set selected ball type index
#define kBallTypeBoolean @"ballTypeBoolean"
#define kPocketBrooklynBoolean @"pocketBrooklynBoolean" //if YES then pocket i.e value=2 for server call
#define kOilPatternBoolean @"oilPatternBoolean"
#define kBallTypeArray @"ballTypeArray"
#define kBowlingBallName @"bowlingBallName"
#define kCompetitionTypeId @"userStatsCompetitionTypeId"
#define kPatternLengthId @"userStatPatternLengthId"
#define kPatternNameId @"userStatPatternNameId"

//Keys for User Stats section
#define kpatternLength @"patternLength"
#define koilPattern @"oilPattern"
#define kduration @"duration"
#define kfilterVenueId @"filterVenueId"
#define kfilterCountryIndex @"countryNameIndex"
#define kfilterStateIndex @"stateNameIndex"
#define kfilterVenueIndex @"venueNameIndex"
#define kScreenName @"screenName"
#define kfilterTag @"TagSelectedInFilter"
#define kselectedGraph @"selectedGraphType"

//Challenge
#define kInChallengeView @"inChallengeViewBool"
#define kcurrentChallenge @"enteredChallengeName"
#define kenteredH2HLive @"enteredH2HLive"
#define kenteredH2HPosted @"enteredH2HPosted"
#define kh2hViewFlow @"h2hViewFlowPath"         //To handle orientation for H2H Frame View
#define kPostedGameTagAdded @"postedGameTagAdded"
#define kshowOpponentsForH2HPosted @"showListOfOpponentsOnClickOfH2HViewButton"

//FSEM
#define kInFSEMView @"enteredFSEM"

#define kscratchType @"Scratch"
//Extra Keys
#define kRewardPoints @"rewardspoints"
#define kCongratsScreenPopUp @"CongratsScreenPopUp"

#define kglobalLeaderboradViaBowlingView @"leaderboard"


#endif

#define NSLog(s,...)
