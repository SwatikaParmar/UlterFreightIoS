//
//  CountriesListController.swift
//  FreightPulse
//
//  Created by AbsolveTech on 24/10/24.
//

import UIKit


protocol CountriesSelectDelegate {
    func chooseCountries(_ id:Int, _ name:String)
    func chooseState(_ id:Int, _ name:String)
}

    class CountriesListController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate{

        @IBOutlet weak var tableViewSearch : UITableView!
        @IBOutlet weak var navigationViewConstraint: NSLayoutConstraint!
        @IBOutlet weak var navigationView: UIView!
        @IBOutlet var SearchTxt: UITextField!
        @IBOutlet weak var titleLbe : UILabel!

        var nameArray = [String]()
        var imageArray = [String]()
        var CountListData : [CountriesListData] = []
        var stateListDataArray : [StateListData] = []
        var searchData = [CountriesListData]()
        var stateData = [StateListData]()
        var topTitle = ""
        var delegate : CountriesSelectDelegate!
        var searchText = ""
        var countryID = 0
        var isJurisdictions = false

        var allJurisdictionsListData : [JurisdictionsListData] = []
        var jurisdictionsListDataArray : [JurisdictionsListData] = []
        
        func topViewLayout(){
               if CountriesListController.hasSafeArea{
                   if navigationViewConstraint != nil {
                       navigationViewConstraint.constant = 92
                     
                }
            }
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            topViewLayout()
            titleLbe.text = topTitle
  
            

        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            self.navigationController?.isNavigationBarHidden = true
            if isJurisdictions {
                GetAllJurisdictionsAPIRequestData(true, false)
            }
            else{
                if countryID == 0 {
                    GetCategoryListDataGet(true, true)
                }
                else{
                    GetStateListDataGet(true, true)
                }
            }
        }
        
        
        @IBAction func Back(_ sender: Any) {

            self.navigationController?.popViewController(animated: true)
        }
        
        
        @IBAction func searchAction(_ sender: Any) {

            self.SearchTxt.resignFirstResponder()

        }
        
        func GetCategoryListDataGet(_ isLoader:Bool, _ isAppend: Bool){
        
            CountriesListAPIRequest.shared.CountriesListAPI(requestParams:[:], isLoader) { (message,status,dictionary) in
                if status {
                    if dictionary != nil{
                        self.CountListData = dictionary!
                        self.searchData = dictionary!
                        self.tableViewSearch.reloadData()
                    }
                    else{
                        
                    }
                }
                else{
                      
                }
            }
        }
        
        func GetAllJurisdictionsAPIRequestData(_ isLoader:Bool, _ isAppend: Bool){
        
            GetAllJurisdictionsAPIRequest.shared.JurisdictionsListAPI(requestParams:0, isLoader) { (message,status,dictionary) in
                if status {
                    if dictionary != nil{
                        self.jurisdictionsListDataArray = dictionary!
                        self.allJurisdictionsListData = dictionary!
                        self.tableViewSearch.reloadData()
                    }
                
                }
                else{
                      
                }
            }
        }
        
        func GetStateListDataGet(_ isLoader:Bool, _ isAppend: Bool){
        
            StateListAPIRequest.shared.StateListAPI(requestParams:countryID, isLoader) { (message,status,dictionary) in
                if status {
                    if dictionary != nil{
                        self.stateListDataArray = dictionary!
                        self.stateData = dictionary!
                        self.tableViewSearch.reloadData()
                    }
                }
            }
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            
            if isJurisdictions{
                
                return jurisdictionsListDataArray.count
            }
            else{
                if countryID == 0 {
                    return searchData.count
                }
                return stateData.count
            }
            return 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CountriesTableCell") as! CountriesTableCell
            if isJurisdictions{
                cell.lbeName.text = self.jurisdictionsListDataArray[indexPath.row].name

                
                
            }
            else{
                if countryID == 0 {
                    let data : CountriesListData = self.searchData[indexPath.row]
                    cell.lbeName.text = data.countryName
                }
                else{
                    let data : StateListData = self.stateData[indexPath.row]
                    cell.lbeName.text = data.cityName
                }
            }
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 50
            }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
            tableView.deselectRow(at: indexPath, animated: true)
           
            if isJurisdictions{
                
                
                delegate.chooseState(self.jurisdictionsListDataArray[indexPath.row].id, self.jurisdictionsListDataArray[indexPath.row].name)

                
                
            }
            else{
                if countryID == 0 {
                    let data : CountriesListData = self.searchData[indexPath.row]
                    delegate.chooseCountries(data.countryMasterId, data.countryName)
                }
                else{
                    let data : StateListData = self.stateData[indexPath.row]
                    delegate.chooseState(data.cityID, data.cityName)
                    
                }
            }
                self.navigationController?.isNavigationBarHidden = true
                self.navigationController?.popViewController(animated: true)

        }
        
        
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
        {
          
            
            let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)

            if isJurisdictions{
                jurisdictionsListDataArray = newText.isEmpty ? allJurisdictionsListData : allJurisdictionsListData.filter{ $0.name.range(of: newText, options: .caseInsensitive) != nil }

                
            }
            else{
                if countryID == 0 {
                    searchData = newText.isEmpty ? CountListData : CountListData.filter{ $0.countryName.range(of: newText, options: .caseInsensitive) != nil }
                    
                }
                else{
                    stateData = newText.isEmpty ? stateListDataArray : stateListDataArray.filter{ $0.cityName.range(of: newText, options: .caseInsensitive) != nil }
                }
            }

            tableViewSearch.reloadData()

           
            return true
        }


    }



class CountriesListAPIRequest: NSObject {
    
    static let shared = CountriesListAPIRequest()
    
    func CountriesListAPI(requestParams : [String:Any],_ isLoader:Bool, completion: @escaping (_ message : String?, _ status : Bool, _ dictionary : [CountriesListData]?) -> Void) {
        
        let apiURL = String("".CountriesList)
        
        print("URL---->> ",apiURL)
        print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.GetBodyFrom(urlString:apiURL, parameters: requestParams, authToken:nil, isLoader: isLoader, loaderMessage: "") { (data, error) in
            
            print("*************************************************")
            print(data ?? "No data")
            
            if error == nil{
                var messageString : String = ""
                if let status = data?["statusCode"] as? Int{
                    if let msg = data?["message"] as? String{
                        messageString = msg
                    }
                    if status == 200 {
                        var homeListObject : [CountriesListData] = []
                        if let dataList = data?["data"] as? NSArray{
                            for list in dataList{
                                let dict : CountriesListData =   CountriesListData.init(fromDictionary: list as! [String : Any])
                                homeListObject.append(dict)
                            }
                            
                            completion(messageString,true,homeListObject)
                        }else{
                            completion(messageString, false,nil)
                        }
                    }
                    else
                    {
                        NotificationAlert().NotificationAlert(titles: GlobalConstants.serverError)
                        completion(GlobalConstants.serverError, false,nil)
                    }
                }
                else
                {
                    NotificationAlert().NotificationAlert(titles: GlobalConstants.serverError)
                    completion(GlobalConstants.serverError, false,nil)
                }
            }
        }
    }
    
}
class CountriesListData: NSObject {
            var countryMasterId = 0
            var countryName = "";
            var countryCode = "";


    init(fromDictionary dictionary: [String:Any]){
        countryMasterId = dictionary["countryId"] as? Int  ?? 0
        countryName = dictionary["countryName"] as? String ?? ""
        countryCode = dictionary["countryCode"] as? String ?? ""


    }

}
class CountriesTableCell: UITableViewCell {

    @IBOutlet weak var lbeName : UILabel!
    @IBOutlet weak var lbeLine : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
//MARK:-   AlertView  Model
class AlertView : NSObject
{
    static func oneButtonAction(_ title:String, _ message:String, _ view:UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
    
    static func backButtonAction(_ title:String, _ message:String, _ view:UIViewController){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            view.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        view.present(alertController, animated: true, completion: nil)
    }
    
    static func backButtonDismiss(_ title:String, _ message:String, _ view:UIViewController){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            view.dismiss(animated: false, completion: nil)
        }
        alertController.addAction(okAction)
        view.present(alertController, animated: true, completion: nil)
    }
}



class StateListAPIRequest: NSObject {
    
    static let shared = StateListAPIRequest()
    
    func StateListAPI(requestParams : Int,_ isLoader:Bool, completion: @escaping (_ message : String?, _ status : Bool, _ dictionary : [StateListData]?) -> Void) {
        
        var apiURL = String("".GetStates)

        apiURL = String(format: "%@?countryId=%d", apiURL,requestParams)
        
        print("URL---->> ",apiURL)
        print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.GetBodyFrom(urlString:apiURL, parameters: [:], authToken:nil, isLoader: isLoader, loaderMessage: "") { (data, error) in
            
            print("*************************************************")
            print(data ?? "No data")
            
            if error == nil{
                var messageString : String = ""
                if let status = data?["statusCode"] as? Int{
                    if let msg = data?["message"] as? String{
                        messageString = msg
                    }
                    if status == 200 {
                        var homeListObject : [StateListData] = []
                        if let dataList = data?["data"] as? NSArray{
                            for list in dataList{
                                let dict : StateListData =   StateListData.init(fromDictionary: list as! [String : Any])
                                homeListObject.append(dict)
                            }
                            
                            completion(messageString,true,homeListObject)
                        }else{
                            completion(messageString, false,nil)
                        }
                    }
                    else
                    {
                        NotificationAlert().NotificationAlert(titles: GlobalConstants.serverError)
                        completion(GlobalConstants.serverError, false,nil)
                    }
                }
                else
                {
                    NotificationAlert().NotificationAlert(titles: GlobalConstants.serverError)
                    completion(GlobalConstants.serverError, false,nil)
                }
            }
        }
    }
    
}


class StateListData: NSObject {
    var cityID = 0
    var cityName = "";
    var countryCode = "";


    init(fromDictionary dictionary: [String:Any]){
        cityID = dictionary["stateId"] as? Int  ?? 0
        cityName = dictionary["stateName"] as? String ?? ""
    }

}


class GetAllJurisdictionsAPIRequest: NSObject {
    
    static let shared = GetAllJurisdictionsAPIRequest()
    
    func JurisdictionsListAPI(requestParams : Int,_ isLoader:Bool, completion: @escaping (_ message : String?, _ status : Bool, _ dictionary : [JurisdictionsListData]?) -> Void) {
        
        var apiURL = String("".GetAllJurisdictions)

        
        print("URL---->> ",apiURL)
        print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.GetBodyFrom(urlString:apiURL, parameters: [:], authToken:nil, isLoader: isLoader, loaderMessage: "") { (data, error) in
            
            print("*************************************************")
            print(data ?? "No data")
            
            if error == nil{
                var messageString : String = ""
                if let status = data?["statusCode"] as? Int{
                    if let msg = data?["message"] as? String{
                        messageString = msg
                    }
                    if status == 200 {
                        var homeListObject : [JurisdictionsListData] = []
                        if let dataList = data?["data"] as? NSArray{
                            for list in dataList{
                                let dict : JurisdictionsListData =   JurisdictionsListData.init(fromDictionary: list as! [String : Any])
                                homeListObject.append(dict)
                            }
                            
                            completion(messageString,true,homeListObject)
                        }else{
                            completion(messageString, false,nil)
                        }
                    }
                    else
                    {
                        NotificationAlert().NotificationAlert(titles: GlobalConstants.serverError)
                        completion(GlobalConstants.serverError, false,nil)
                    }
                }
                else
                {
                    NotificationAlert().NotificationAlert(titles: GlobalConstants.serverError)
                    completion(GlobalConstants.serverError, false,nil)
                }
            }
        }
    }
    
}


class JurisdictionsListData: NSObject {
    var id = 0
    var name = "";


    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["id"] as? Int  ?? 0
        name = dictionary["name"] as? String ?? ""
    }

}
