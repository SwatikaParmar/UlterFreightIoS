//
//  MenuViewController.swift
//  FreightPulse
//
//  Created by AbsolveTech on 25/09/24.
//

import UIKit
import LGSideMenuController
import SDWebImage

class MenuUserController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var lbeName: UILabel!
    @IBOutlet weak var lbeSp: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
                        
    var titleArray = [String]()
    var imagesArray = [String]()

    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var versionLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.versionLbl.text = Utility.shared.appVersion() + "(\(Utility.shared.appBuildVersion()))"
       
        
        titleArray = ["Home","Privacy Policy","About Us","Log Out"]
        imagesArray = ["oneImage","Privacy","About","Log"]
        
        tableview.contentInsetAdjustmentBehavior = .never
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.SideMenuUpdate), name: NSNotification.Name(rawValue: "SideMenuUpdate"), object: nil)
        

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let retrievedDriver = getDriverDetails() {
            print("Retrieved Driver Name: \(retrievedDriver.driverName)")
            self.lbeName.text = retrievedDriver.driverName
            
            let imagePath = retrievedDriver.driverImage
            print("Raw image path: \(imagePath)")
            
            var urlString = retrievedDriver.driverImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            urlString =  GlobalConstants.BASE_IMAGE_URL + urlString
            
            self.imgProfile?.sd_setImage(with: URL.init(string:(urlString)),
                                   placeholderImage: UIImage(named: "placeholder_Male"),
                                   options: .refreshCached,
                                   completed: nil)
        }
     
    
        self.tableview.reloadData()
        
    }
    
    
    @objc func SideMenuUpdate(_ notification: NSNotification) {
        
        if let retrievedDriver = getDriverDetails() {
            print("Retrieved Driver Name: \(retrievedDriver.driverName)")
            self.lbeName.text = retrievedDriver.driverName
            var urlString = retrievedDriver.driverImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            urlString =  GlobalConstants.BASE_IMAGE_URL + urlString
            
            self.imgProfile?.sd_setImage(with: URL.init(string:(urlString)),
                                   placeholderImage: UIImage(named: "placeholder_Male"),
                                   options: .refreshCached,
                                   completed: nil)
        }
     
        

        self.tableview.reloadData()
    }
    
    //MARK:-   TableView Function
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

          
          return titleArray.count
    }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuCell
          
          cell.lbeName.text = titleArray[indexPath.row]
          cell.imgVw.image = UIImage (named: imagesArray[indexPath.row])
          return cell
      }
      
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 55
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
           tableview.deselectRow(at: indexPath, animated: false)
           sideMenuController?.hideLeftView(animated: true)
    
        if titleArray.count == indexPath.row + 1 {
            ActionSheet()
        }
        else{
            if indexPath.row == 0 {
              
            }
            else if indexPath.row == 1{
               
            }
            else{
                    NotificationCenter.default.post(name: Notification.Name("Menu_Push_Action"), object: nil, userInfo: ["count":String(indexPath.row)])

                }
            }
        }
    
    //MARK: - Logout Message Action Sheet
    func ActionSheet()
    {
        let alert = UIAlertController(title: nil, message:"Are you sure you want to logout?", preferredStyle: .alert)
        
        let No = UIAlertAction(title:"No", style: UIAlertAction.Style.destructive, handler: { action in
        })
            alert.addAction(No)
        
        let Yes = UIAlertAction(title:"Yes", style: .default, handler: { action in
            self.callLogOutApi()
         
        })
        alert.addAction(Yes)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    //MARK: - Call Logout API
    func callLogOutApi(){
        
        UserDefaults.standard.removeObject(forKey: Constants.accessToken)
        UserDefaults.standard.removeObject(forKey: Constants.userId)
        UserDefaults.standard.removeObject(forKey: Constants.userImg)
        UserDefaults.standard.removeObject(forKey: Constants.firstName)
        UserDefaults.standard.removeObject(forKey: Constants.lastName)
        UserDefaults.standard.removeObject(forKey: Constants.email)
        UserDefaults.standard.removeObject(forKey: Constants.phoneNumber)
        UserDefaults.standard.set(false, forKey: Constants.login)
        UserDefaults.standard.synchronize()
        RootControllerManager().SetRootViewController()

    }
}


class SideMenuCell: UITableViewCell {
       @IBOutlet weak var imgVw: UIImageView! = nil
       @IBOutlet weak var lbeName: UILabel! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}






