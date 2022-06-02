//
//  ListViewController.swift
//  Degpeg
//
//  Created by Raj Kadam on 25/04/22.
//
           
import UIKit

 class ListViewController: B2CBaseViewController {
     var viewModel: ListViewModelProtocol?
     var currentView: UIView?
     var homeDataArray = [ListSectionData]()
    @IBOutlet weak var listTableView: UITableView!
    var cellBundle: Bundle?
     
     lazy fileprivate var refreshControl: UIRefreshControl = {
         let refreshControl = UIRefreshControl()
         refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
         refreshControl.tintColor = UIColor.darkGray
         return refreshControl
     }()
     
     override func viewDidLoad() {
        super.viewDidLoad()
         AddRefreshControl()
        registerCells()
        self.navigationItem.title = "Home"
        print("Is Connected",NetworkManager.isConnectedToInternet)
         configureVM()
         //fontFamilyName()
    }
    
     // MARK: - Just to test Font Family
     // TODO: - Delete this function
     func fontFamilyName(){
         for family: String in UIFont.familyNames
         {
             print(family)
             for names: String in UIFont.fontNames(forFamilyName: family)
             {
                 print("== \(names)")
             }
         }
     }
     
     // MARK: Add Refresh Control
     private func AddRefreshControl(){
         listTableView.refreshControl = refreshControl
     }
     
     //MARK: refresh table data
     @objc private func pullToRefresh() {
         getScreenData(spinnerFlag: false)
         
     }
     
     private func getScreenData(spinnerFlag: Bool){
         viewModel?.fetchAllCategories()
         viewModel?.getContentPublishers(for: DEFAULT_ContentPublisherId, showSpinnerFlag: spinnerFlag)
     }
     
     //
     func configureVM(){
         self.viewModel = ListViewModel()
         viewModel?.viewController = self
         self.currentView = self.view
     }
     required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
     
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         hideNavigationBar()
         getScreenData(spinnerFlag: true)
     }
    private func registerCells(){
        cellBundle = Bundle.resourceBundle(for: Self.self)
        listTableView.register(TableCellID.ListHeaderSection, bundle: cellBundle)
        listTableView.register(TableCellID.TrendingCellID, bundle: cellBundle)
        listTableView.register(TableCellID.CategoryCellID, bundle: cellBundle)
        listTableView.register(TableCellID.BrandCellID, bundle: cellBundle)
        listTableView.register(TableCellID.UpcomingShowCellID, bundle: cellBundle)
        
        listTableView.delegate = self
        listTableView.dataSource = self
    }
     
     
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
     func numberOfSections(in tableView: UITableView) -> Int {
         return homeDataArray.count
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         if homeDataArray[indexPath.section].sectionName == .live {
             if let cell = tableView.dequeueReusableCell(withIdentifier: TableCellID.ListHeaderSection, for: indexPath) as? HeaderSectionTableViewCell {
                cell.delegate = self
                cell.registerCell(bundle: cellBundle)
                if homeDataArray.count > 0 {
                    cell.configureCell(data: homeDataArray[indexPath.section].sectionData)
                }
                return cell
            }else {
                return UITableViewCell()
            }
        }else if homeDataArray[indexPath.section].sectionName == .trending {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCellID.TrendingCellID, for: indexPath) as! TrendingVideosTableViewCell
            cell.registerCell(bundle: cellBundle)
            cell.delegate = self
            cell.configureCell(data: homeDataArray[indexPath.section].sectionData)
            
            return cell
        }else if homeDataArray[indexPath.section].sectionName == .category {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCellID.CategoryCellID, for: indexPath) as! CategoryTableViewCell
            cell.registerCell(bundle: cellBundle)
            cell.configureCell(data: homeDataArray[indexPath.section].sectionData)
            return cell
        }else if homeDataArray[indexPath.section].sectionName == .upcoming {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCellID.UpcomingShowCellID, for: indexPath) as! UpcomingShowsTableViewCell
            cell.registerCell(bundle: cellBundle)
            cell.configureCell(data: homeDataArray[indexPath.section].sectionData)
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCellID.BrandCellID, for: indexPath) as! BrandTableViewCell
            cell.registerCell(bundle: cellBundle)
            return cell
        }
    }
    
    
    
    
}

extension ListViewController: LiveScreenRedirectionProtocol {
    
    func redirectToLiveScreen(data: RowData) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LiveScreenViewController") as! LiveScreenViewController
        vc.screenData = data
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension ListViewController: ListViewControllerProtocol{
    
    func updateSectionData(dataArray: [ListSectionData]) {
        print(dataArray.count)
        UIUtils.hideHUD(view: self.view)
        homeDataArray = [ListSectionData]()
        homeDataArray = dataArray
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
        listTableView.reloadData()
    }
    
    func showError(errorString: String) {
        
        UIUtils.hideHUD(view: self.view)
        showAlertView(title: AlertTitles.Alert, message: errorString)
    }
    
    
}
