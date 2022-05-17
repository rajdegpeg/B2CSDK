//
//  ListViewController.swift
//  Degpeg
//
//  Created by Raj Kadam on 25/04/22.
//
           
import UIKit

 class ListViewController: B2CBaseViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    var cellBundle: Bundle?
     override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        self.navigationItem.title = "Home"
        print("Is Connected",NetworkManager.isConnectedToInternet)
    }
    
     required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
     
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         hideNavigationBar()
     }
    private func registerCells(){
        cellBundle = Bundle.resourceBundle(for: Self.self)
        listTableView.register(TableCellID.ListHeaderSection, bundle: cellBundle)
        listTableView.register(TableCellID.TrendingCellID, bundle: cellBundle)
        listTableView.register(TableCellID.CategoryCellID, bundle: cellBundle)
        listTableView.register(TableCellID.BrandCellID, bundle: cellBundle)
        listTableView.register(TableCellID.UpcomingShowCellID, bundle: cellBundle)
        
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
        return 5
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderSectionTableViewCell", for: indexPath) as? HeaderSectionTableViewCell {
                cell.delegate = self
                cell.registerCell(bundle: cellBundle)
                return cell
            }else {
                return UITableViewCell()
            }
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCellID.TrendingCellID, for: indexPath) as! TrendingVideosTableViewCell
            cell.registerCell(bundle: cellBundle)
            return cell
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCellID.CategoryCellID, for: indexPath) as! CategoryTableViewCell
            cell.registerCell(bundle: cellBundle)
            return cell
        }else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCellID.UpcomingShowCellID, for: indexPath) as! UpcomingShowsTableViewCell
            cell.registerCell(bundle: cellBundle)
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
    
    func redirectToLiveScreen() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LiveScreenViewController") as! LiveScreenViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
