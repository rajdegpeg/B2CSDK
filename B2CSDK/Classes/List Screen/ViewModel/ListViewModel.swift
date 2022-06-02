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
    var categories: [CategoryData] = [CategoryData]()
    
    func fetchAllCategories() {
        if NetworkManager.isConnectedToInternet {
            UIUtils.showHUD(view: viewController?.currentView)
            HomeService().getAllCategories() { [weak self] result, error in
                guard let self = self else { return }
                UIUtils.hideHUD(view: self.viewController?.currentView)
                if let array = result {
                    self.categories = array
                } else {
                    self.viewController?.showError(errorString: error?.message ?? "Categories not found!")
                }
            }
        }else {
            self.viewController?.showError(errorString: AlertDetails.NoInternet)
        }
    }
    func getContentPublishers(for publisherId: String, showSpinnerFlag: Bool) {
    
        if NetworkManager.isConnectedToInternet {
            if showSpinnerFlag {
                UIUtils.showHUD(view: viewController?.currentView)
            }
            HomeService().getContentPublisherDetails(contentPublisherId: publisherId) { [weak self] publisher, error in
                guard let self = self else { return }
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
//            if showSpinnerFlag {
//                UIUtils.showHUD(view: viewController?.currentView)
//            }
            HomeService().getContentProviderVideos(contentProviderId: providers[index]) { [weak self] result, error in
                guard let self = self else { return }
                //UIUtils.hideHUD(view: self.viewController?.currentView)
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
        
        
        let myGroup: DispatchGroup = DispatchGroup()
        
        listSectionData = [ListSectionData]()
        
        var tp = UserFilter.init()
        let val = tp.createUserFilter(id: "456")
        print("Filter Value", val)
        var rowData: [RowData] = [RowData]()
        
        videos.forEach { video in
            if let channels  = video.channelIds{
                
                for channel in channels {
                    myGroup.enter()
                    HomeService().getChannelDetails(for: channel) { [weak self] channel, error in
                        myGroup.leave()
                    guard let self = self else { return }
                    if let channel = channel {
                        if channel.isWebToStream {
                            let videoUrl = video.webVideoUrl ?? ""
                            let oneRecord = RowData.init(id: video.id, products: video.products, sessionDate: video.dateTime?.stringToDate() ?? Date(), videoUrl: videoUrl, status: video.status, imageUrl: video.bannerUrl, sessionDataId: video.sessionDataId, contentProviderId: video.contentProviderId, liveSessionCategory: video.liveSessionCategory, streamKey: video.streamKey, sessionType: video.sessionType, sessionPassCode: video.sessionPassCode, name: video.name, description: video.description, userName: nil, userImage: nil, userID: nil, userContentProviderId: nil)
                            rowData.append(oneRecord)
                            
                        }
                    } else {
                        
                    }
                }
                
                }
                /*if channels.contains(CHANNELS.StreamToWebsiteID.0) || channels.contains(CHANNELS.StreamToWebsiteID.1) {
                    let oneRecord = RowData.init(id: video.id, sessionDate: video.dateTime, videoUrl: video.videoUrl, status: video.status, imageUrl: video.bannerUrl, sessionDataId: video.sessionDataId, contentProviderId: video.contentProviderId, liveSessionCategory: video.liveSessionCategory, streamKey: video.streamKey, sessionType: video.sessionType, sessionPassCode: video.sessionPassCode, name: video.name, description: video.description, userName: nil, userImage: nil, userID: nil, userContentProviderId: nil)
                    rowData.append(oneRecord)
                }*/
            }
        }
        //UIUtils.hideHUD(view: self.viewController?.currentView)
        myGroup.notify(queue: DispatchQueue.main) {  [weak self] in
            
            guard let self = self else {return}
            let liveDataArray = rowData.filter({$0.status == .live}).sorted(by: {$0.sessionDate > $1.sessionDate})
            let plannedSessions = rowData.filter({$0.status == .planned}).sorted(by: {$0.sessionDate > $1.sessionDate})
            let scheduledSessions = rowData.filter({$0.status == .scheduled}).sorted(by: {$0.sessionDate > $1.sessionDate})
            let completedSessions = rowData.filter({$0.status == .completed}).sorted(by: {$0.sessionDate > $1.sessionDate})
            var topSectionData = liveDataArray
            if topSectionData.count > 5 {
               
                topSectionData = Array(topSectionData.prefix(upTo: 5))
               
            }else if topSectionData.count < 5 {
               
                for data in plannedSessions {
                    topSectionData.append(data)
                    if topSectionData.count == 5 {
                        break
                    }
                }
                if topSectionData.count < 5 {
                    for data in completedSessions {
                        topSectionData.append(data)
                        if topSectionData.count == 5 {
                            break
                        }
                    }
                }
                
            }
            
            var homeDataArray = [ListSectionData]()
            
            let liveData = ListSectionData.init(sectionName: .live, sectionData: topSectionData)
            
            homeDataArray.append(liveData)
            let trendindData = ListSectionData.init(sectionName: .trending, sectionData: rowData.sorted(by: {$0.sessionDate > $1.sessionDate}))
            
            homeDataArray.append(trendindData)
            var categoryRowDta = [RowData]()
            self.categories.forEach { category in
                categoryRowDta.append(RowData.init(id: category.id, sessionDate: Date(), videoUrl: nil, status: nil, imageUrl: category.categoryImageUrl, sessionDataId: nil, contentProviderId: nil, liveSessionCategory: nil, streamKey: nil, sessionType: nil, sessionPassCode: nil, name: category.name, description: nil, userName: nil, userImage: nil, userID: nil, userContentProviderId: nil))
            }
            let categoriesData = ListSectionData.init(sectionName: .category, sectionData: categoryRowDta)
            homeDataArray.append(categoriesData)
            let upcommingSessions = plannedSessions+scheduledSessions
            if upcommingSessions.count > 0 {
                let upcomingData = ListSectionData.init(sectionName: .upcoming, sectionData: upcommingSessions.sorted(by: {$0.sessionDate>$1.sessionDate}))
                homeDataArray.append(upcomingData)
            }
            
            let brandData = ListSectionData.init(sectionName: .brand, sectionData: nil)
            homeDataArray.append(brandData)
            
            self.addUserDetails(in: homeDataArray)
            //[liveData, trendindData, categoriesData, upcomingData, brandData]
            }
        
    }
    
    func addUserDetails(in homeData:[ListSectionData]) {
        let myGroup: DispatchGroup = DispatchGroup()
        
        if let bannerData = homeData.first(where: {$0.sectionName == .live}), var array = bannerData.sectionData {
            
            var userDataArry: [UserDetails] = [UserDetails]()
            for oneRecord in array {
                myGroup.enter()
                
                var filter = UserFilter.init()
                let param = filter.createUserFilter(id: oneRecord.contentProviderId ?? "")
                HomeService().getUserDetails(param: param) { [weak self] user, error in
                    myGroup.leave()
                    guard let self = self else { return }
                    if let user = user, user.count > 0 {
                        print("User", user[0].email)
                        print("User", user[0])
                        userDataArry.append(user[0])
                    } else {
                       
                    }
                }
            }
            
            myGroup.notify(queue: DispatchQueue.main) {  [weak self] in
                guard let self = self else {return}
                for i in 0..<array.count {
                    var record  = array[i]
                    var name = ""
                    let user = userDataArry[i]
                    if let username = user.firstName {
                        name = username
                    }else if let username = user.fullName {
                        name = username
                    }else if let email = user.email {
                        name = email.emailToName()
                    }
                    record.userName = name
                    record.userID = user.id
                    record.userContentProviderId = user.contentProviderId
                    record.userImage = user.displayPicture
                    
                    array[i] = record
                }
                let liveData = ListSectionData.init(sectionName: .live, sectionData: array)
                var data = homeData
                let index = homeData.firstIndex(where: {$0.sectionName == .live}) ?? 0
                data[index] = liveData
                self.viewController?.updateSectionData(dataArray: data)
            }
        }else {
        
            self.viewController?.updateSectionData(dataArray: homeData)
        }
    }
    
    
   /* func filterData(dataArray: [RowData]?) -> [RowData] {
           guard var arr = dataArray else {return [RowData]() }
           let alldate = arr.compactMap({$0.sessionDate})
           
           for i in 0..<alldate.count {
               let date = alldate[i]
               var formatedDate = ""
               
               if let firstIndex = date.firstIndex(of: ".") {
                   formatedDate = String(date[..<firstIndex] ) // "www.stackoverflow"
                   
               }
               let title = getMonthYear(time: formatedDate)
               arr[i].sectionMonth = title
           }
           
           var datesArray = arr.compactMap { $0.sectionMonth } // return array of date
           datesArray = datesArray.removerDuplicates()
           var sectionedArray = [[String: Any]]()
           datesArray.forEach {
               let dateKey = $0
               let filterArray = arr.filter { $0.sectionMonth == dateKey }
               
               sectionedArray.append(["title": dateKey, "data": filterArray])
           }
           print("Sorted Statuse",sectionedArray)
           return sectionedArray
       }
       
       func getMonthYear(time: String?) -> String{
            if let startDateString = time, let startDate = startDateString.ISO8601StringToDate(){
              let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "yyyy"
               let outputDatedateFormatter = DateFormatter()
               outputDatedateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
               outputDatedateFormatter.timeZone = TimeZone.current
               
               let secondsFromGMT = TimeZone.current.secondsFromGMT()
               let CurrentTimeZoneDate = startDate.adding(seconds: secondsFromGMT)
               
               let todaysDate = Date()
               //let stringDate = todaysDate.DateToISO8601String()
               let currentYear = dateFormatter.string(from: todaysDate)
               
               let year = dateFormatter.string(from: CurrentTimeZoneDate)
               if year == currentYear {
                   dateFormatter.dateFormat = "MMMM"
                   return dateFormatter.string(from: CurrentTimeZoneDate)
               }else {
                   dateFormatter.dateFormat = "MMMM yy"
                   return dateFormatter.string(from: CurrentTimeZoneDate)
               }
           }
           return ""
       }*/
}
