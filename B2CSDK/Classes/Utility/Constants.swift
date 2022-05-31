//
//  Constants.swift
//  Degpeg
//
//  Created by Raj Kadam on 25/04/22.
//

import Foundation

public struct Storyboards {
    public static let DEGPEG_STORYBOARD = "Degpeg"
}
struct StoryboardID {
    static let ROOT_NAVIGATION = "RootNavigationController"
}


struct TableCellID {
    static let ListHeaderSection = "HeaderSectionTableViewCell"
    static let TrendingCellID = "TrendingVideosTableViewCell"
    static let CategoryCellID = "CategoryTableViewCell"
    static let BrandCellID = "BrandTableViewCell"
    static let UpcomingShowCellID = "UpcomingShowsTableViewCell"
    
    static let ReceiverCell = "ReceiverTableViewCell"
    static let SenderCell = "SenderTableViewCell"
}

struct CollectionCellID {
    static let HeaderCellID = "HeaderCollectionViewCell"
    static let TrendingCellID = "TrendingVideoCollectionViewCell"
    static let CategoryCellID = "CategoryCollectionViewCell"
    static let BrandCellID = "BrandCollectionViewCell"
    static let UpcomingShowCellID = "UpcomingShowCollectionViewCell"
    static let CTACellID = "CTACollectionViewCell"
    static let ProductCellID = "ProductCollectionViewCell"
}


struct ImageConstants {
    static let placeholderImage = "dummy2"
}


enum SessionStatusString: String {
    case plan = "  Upcoming  "
    case completed = "  Completed  "
    case live = "  Live  "
    case scheduled = "  Scheduled  "
}
