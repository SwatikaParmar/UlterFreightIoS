//
//  HomeViewController.swift
//  FreightPulse
//
//  Created by AbsolveTech on 17/09/24.
//

import UIKit
import SDWebImage
import CoreLocation

class HomeViewController: UIViewController {
    @IBOutlet weak var tableViewHome : UITableView!
    @IBOutlet weak var lbeName : UILabel!
    @IBOutlet weak var lbeStatus : UILabel!
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var mySwitch : UISwitch!
    
    var locationManager: CLLocationManager?
    var locationUpdateTimer: Timer?
    static let geoCoderOnline = CLGeocoder()
    var strAddress = ""
    var lat = "0.0"
    var long = "0.0"
 
    override func viewDidLoad() {
        super.viewDidLoad()
        mySwitch.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.activityType = .automotiveNavigation
        locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager?.distanceFilter = 100.0
        
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.showsBackgroundLocationIndicator = true
        
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
       // requestLocationUpdate()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        stopLocationUpdate()
        getProfileAPI()
    }
    
    private func requestLocationUpdate() {
        
        locationUpdateTimer = Timer.scheduledTimer(withTimeInterval: 35, repeats: true) { [weak self] _ in
            self?.sendCurrentLocation()
        }
    }
    
    private func stopLocationUpdate() {
        locationUpdateTimer?.invalidate()
        locationUpdateTimer = nil
    }
    
  
    
    @IBAction func Menu_Action(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SideMenuUpdate"), object: nil)
        sideMenuController?.showLeftView(animated: true)
    }
    
    @IBAction func notification(_ sender: Any) {
        let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
        let controller = (storyBoard.instantiateViewController(withIdentifier: "NotificationViewController") as?  NotificationViewController)!
        self.parent?.navigationController?.pushViewController(controller, animated: true)

    }
    
    func getProfileAPI(){
        
        if let retrievedDriver = getDriverDetails() {
          
            self.lbeName.text = retrievedDriver.driverName
         
        }
        
        GetProfileRequest.shared.getProfileAPI(requestParams:[:], false) { (user,message,isStatus) in
            if isStatus {
                if user != nil{
                    
                    
                    if let retrievedDriver = getDriverDetails() {
                        self.mySwitch.isOn = retrievedDriver.isAvailable
                        if retrievedDriver.isAvailable {
                            self.lbeStatus.text = "Available"
                            self.lbeStatus.textColor = .green
                        }
                        else{
                            self.lbeStatus.text = "Not Available"
                            self.lbeStatus.textColor = .red

                        }
                        self.lbeName.text = retrievedDriver.driverName
                        
                        var urlString = retrievedDriver.driverImage.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
                        urlString =  GlobalConstants.BASE_IMAGE_URL + urlString
                        
                        self.imgUser?.sd_setImage(with: URL.init(string:(urlString)),
                                               placeholderImage: UIImage(named: "placeholder_Male"),
                                               options: .refreshCached,
                                               completed: nil)
                        
                        if retrievedDriver.loadFleetDetailId > 0 {
                            self.requestLocationUpdate()
                            self.sendCurrentLocation()
                        }
                        else{
                            self.stopLocationUpdate()
                        }
                    }
                }
            }
        }
    }
    
    
    func sendCurrentLocation() {
        if UserDefaults.standard.bool(forKey: Constants.login) {
            if let retrievedDriver = getDriverDetails() {
                if retrievedDriver.loadFleetDetailId > 0 {
                    if typeDelivered == "PickedUp" {
                        let params = [
                            "loadFleetDetailId": retrievedDriver.loadFleetDetailId,
                            "status": "InTransit",
                            "currentLat" : self.lat,
                            "currentLong": self.long,
                            "address": self.strAddress,
                        ] as [String : Any]
                        
                        UpdateLoadTrackingStatusRequest.shared.UpdateLoadTrackingStatusAPI(requestParams: params) { (obj, message, success,Verification) in
                            
                        }
                    }
                    else{
                        stopLocationUpdate()
                    }
                }
            }
        }else{
            stopLocationUpdate()
        }
    }
    @objc func switchToggled(_ sender: UISwitch) {
            if sender.isOn {
                UpdateDriverAvailability(true)
                lbeStatus.text = "Available"
                self.lbeStatus.textColor = .green

            } else {
                UpdateDriverAvailability(false)
                lbeStatus.text = "Not Available"
                self.lbeStatus.textColor = .red

            }
        }
    
    
    func UpdateDriverAvailability(_ isAvailable:Bool)
    {
        
        let params = [ "driverId": userId(),
                       "isAvailable": isAvailable,
                     ] as [String : Any]
           
     
        UpdateDriverAvailabilityRequest.shared.UpdateDriverAvailabilityAPI(requestParams: params) { (obj, message, success,Verification) in
            NotificationAlert().NotificationAlert(titles: message ?? "isAvailable")
            if success {
                
            }
        }
    }
    
    
    
}

extension HomeViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("Location permission not determined")
        case .restricted:
            print("Location permission restricted")
        case .denied:
            print("Location permission denied")
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location permission granted")
        default:
            print("default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
        {
            guard let location = locations.first else {
                return
            }
        
            DispatchQueue.main.async {
                
            HomeViewController.geoCoderOnline.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
     
                        placemarks?.forEach { (placemark) in
                            if let city = placemark.locality {
                                self.strAddress = placemark.name ?? ""
                                self.strAddress = self.strAddress + " " + city
                                print(self.strAddress)
                            }
                        }
                    })
                
                if let locationData = locations.last {
                    self.lat = String(locationData.coordinate.latitude)
                    self.long = String(locationData.coordinate.longitude)
                    
                    UserDefaults.standard.set(self.lat, forKey: "latitude_current")
                    UserDefaults.standard.set(self.long, forKey: "longitude_current")
                }
            }
        }
}

extension HomeViewController: UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
        let cell = tableViewHome.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        
        if indexPath.row == 0
        {
            cell.lbeName.text = "Active Load"
        }
        if indexPath.row == 1
        {
            cell.lbeName.text = "Active Load Fuel Receipts"

        }
        if indexPath.row == 2
        {
            cell.lbeName.text = "Update Profile"
        }
        if indexPath.row == 3
        {
            cell.lbeName.text = "My Fleet"
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return  100
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if indexPath.row == 0 {
            let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
            let controller = (storyBoard.instantiateViewController(withIdentifier: "AssignedViewController") as?  AssignedViewController)!
            controller.titleStr = "Active Load"
            self.parent?.navigationController?.pushViewController(controller, animated: true)
        }
        if indexPath.row == 1
        {
            if let retrievedDriver = getDriverDetails() {
                if retrievedDriver.loadFleetDetailId == 0 {
                    return
                }
                
                let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
                let controller = (storyBoard.instantiateViewController(withIdentifier: "PurchaseFuelListViewController") as?  PurchaseFuelListViewController)!
                controller.fleetId = retrievedDriver.fleetId
                controller.loadId = retrievedDriver.loadId

                controller.IsActive = 1
                self.parent?.navigationController?.pushViewController(controller, animated: true)
                
            }
        }
        
        if indexPath.row == 2
        {

            let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
            let controller = (storyBoard.instantiateViewController(withIdentifier: "UpdateProfileViewController") as?  UpdateProfileViewController)!
            controller.titleStr = "Update Profile"
            self.parent?.navigationController?.pushViewController(controller, animated: true)
        }
        
        if indexPath.row == 3
        {

            let storyBoard = UIStoryboard.init(name: "Fleet", bundle: nil)
            let controller = (storyBoard.instantiateViewController(withIdentifier: "MyFleetViewController") as?  MyFleetViewController)!
            self.parent?.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    
}
class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var lbeName: UILabel!
    
}
