//
//  ListViewModel.swift
//  Degpeg
//
//  Created by Raj Kadam on 25/04/22.
//

import Foundation
final class ListViewModel: ListViewModelProtocol {
    var viewController: ListViewControllerProtocol?
    var contentPublisher: ContentPublishersDetails?
    
    var listSectionData: [ListSectionData] = [ListSectionData]()
    var videos:[ContentProviderDetailsModel] = [ContentProviderDetailsModel]()
    
    func getContentPublishers(for publisherId: String) {
    
        if NetworkManager.isConnectedToInternet {
            UIUtils.showHUD(view: viewController?.currentView)
            HomeService().getContentPublisherDetails(contentPublisherId: publisherId) { [weak self] publisher, error in
                guard let self = self else { return }
                UIUtils.hideHUD(view: self.viewController?.currentView)
                if publisher != nil {
                    self.contentPublisher = publisher
                    self.getAllHomeData()
                } else {
                    //UIUtils.showDefaultAlertView(title: AlertTitles.Error, message: error?.message ?? "Something went wrong")
                    self.viewController?.showError(errorString: error?.message ?? "Something went wrong")
                }
            }
        }else {
            self.viewController?.showError(errorString: AlertDetails.NoInternet)
        }
        
    }
    
    func getAllHomeData() {
        videos = [ContentProviderDetailsModel]()
        if let providers = contentPublisher?.contentProviders, providers.count > 0 {
            getContentProviderVideos(for: providers, index: 0)
            
        }
        
    }
    
    func getContentProviderVideos(for providers: [String], index: Int) {
        if NetworkManager.isConnectedToInternet {
            UIUtils.showHUD(view: viewController?.currentView)
            HomeService().getContentProviderVideos(contentProviderId: providers[index]) { [weak self] result, error in
                guard let self = self else { return }
                UIUtils.hideHUD(view: self.viewController?.currentView)
                if let list = result {
                    if !list.isEmpty {
                        self.videos.append(contentsOf: list)
                    }
                    if index >= providers.count-1 {
                        // customise data
                        self.createHomeData()
                        return
                    }else {
                        print("received videos ", self.videos.count)
                        self.getContentProviderVideos(for: providers, index: index+1)
                    }
                } else {
                    //UIUtils.showDefaultAlertView(title: AlertTitles.Error, message: error?.message ?? "Something went wrong")
                    self.viewController?.showError(errorString: error?.message ?? "Something went wrong")
                }
            }
        }else {
            self.viewController?.showError(errorString: AlertDetails.NoInternet)
        }
        
    }
    
    func createHomeData() {
        listSectionData = [ListSectionData]()
        
        var tp = UserFilter.init()
        let val = tp.createUserFilter(id: "456")
        print("Filter Value", val)
        var rowData: [RowData] = [RowData]()
        
        videos.forEach { video in
            if let channels  = video.channelIds{
                if channels.contains(CHANNELS.StreamToWebsiteID.0) || channels.contains(CHANNELS.StreamToWebsiteID.1) {
                    let oneRecord = RowData.init(id: video.id, sessionDate: video.dateTime, videoUrl: video.videoUrl, status: video.status, imageUrl: video.bannerUrl, sessionDataId: video.sessionDataId, contentProviderId: video.contentProviderId, liveSessionCategory: video.liveSessionCategory, streamKey: video.streamKey, sessionType: video.sessionType, sessionPassCode: video.sessionPassCode, name: video.name, description: video.description, userName: nil, userImage: nil, userID: nil, userContentProviderId: nil)
                    rowData.append(oneRecord)
                }
            }
        }
        let liveData = ListSectionData.init(sectionName: "Live", sectionData: rowData)
        
        let trendindData = ListSectionData.init(sectionName: "Tending", sectionData: rowData)
        
        let upcomingData = ListSectionData.init(sectionName: "Upcoming", sectionData: rowData)
        viewController?.updateSectionData(dataArray: [liveData, trendindData, upcomingData])
    }
}
