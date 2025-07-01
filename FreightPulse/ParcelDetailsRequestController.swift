//
//  ParcelDetailsRequestController.swift
//  FreightPulse
//
//  Created by AbsolveTech on 26/10/24.
//

import UIKit
import GooglePlaces
import GoogleMaps
import MapKit
import Foundation
import Alamofire

class ParcelDetailsRequestController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var view_NavConst: NSLayoutConstraint!
    @IBOutlet weak var viewFuel_HeightConst: NSLayoutConstraint!
    @IBOutlet weak var tableViewList: UITableView!
    @IBOutlet weak var _scrollView: UIScrollView!
    @IBOutlet weak var fuelView: UIView!
    @IBOutlet weak var lbeTitle: UILabel!

    @IBOutlet weak var lbe_Pickup: UILabel!
    @IBOutlet weak var lbe_Delivery: UILabel!
    @IBOutlet weak var lbe_Distance: UILabel!
    @IBOutlet weak var lbe_Duration: UILabel!
    @IBOutlet weak var lbe_Price: UILabel!
    @IBOutlet weak var lbe_SType: UILabel!
    @IBOutlet weak var lbe_PaymentBy: UILabel!
    @IBOutlet weak var lbe_ParcelName: UILabel!
    @IBOutlet weak var lbe_ParcelNotes: UILabel!
    @IBOutlet weak var lbe_DateTime: UILabel!
    @IBOutlet weak var lbe_Status: UILabel!
    
    
    @IBOutlet weak var btn_Confirm: UIButton!
    @IBOutlet weak var btn_Cancel: UIButton!
    
    @IBOutlet weak var addMapView: UIView!
    
    let mapView = GMSMapView()
    var arrayActiveData : [DriverLoadsArray] = []
    var loadId = 0
    var fleetId = 0
    var index = 0
    var pickUpDirectionsAction = false

    
    lazy var locationManager: CLLocationManager = {
          var _locationManager = CLLocationManager()
          _locationManager.delegate = self
          _locationManager.activityType = .automotiveNavigation
          _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
          _locationManager.distanceFilter = 100.0
          _locationManager.requestWhenInUseAuthorization()
          _locationManager.startUpdatingLocation()
          return _locationManager
      }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.frame = CGRect(x: 1, y: 1, width: Utility.ScreenSize.SCREEN_WIDTH - 35, height: 220)
        mapView.layer.cornerRadius = 6
        mapView.clipsToBounds = true
        self.addMapView.addSubview(mapView)
        mapView.isMyLocationEnabled = true
        mapView.settings.scrollGestures = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true

      //  locationManager.startUpdatingLocation()
        
        
        
        if arrayActiveData.count > index {
            
            if self.arrayActiveData[index].trackingStatus == "Assigned"{
                lbeTitle.text = "Upcoming Load"
                lbe_Status.text = "Upcoming"
                btn_Confirm.setTitle("Active", for: .normal)
                viewFuel_HeightConst.constant = 0
                fuelView.isHidden = true
            }
            
            if self.arrayActiveData[index].trackingStatus == "Delivered"{
                lbeTitle.text = "Delivered Load"
                lbe_Status.text = "Completed"
                btn_Confirm.isHidden = true
                viewFuel_HeightConst.constant = 0
                fuelView.isHidden = true
            }
            
            
            
            lbe_Pickup.text = self.arrayActiveData[index].pickupLocation
            lbe_Delivery.text = self.arrayActiveData[index].deliveryLocation
            
            lbe_DateTime.text = "".convertddMMMM(pickupDate: self.arrayActiveData[index].pickupDate, pickupTime: self.arrayActiveData[index].pickupTime)
            
            
            let camera = GMSCameraPosition.camera(withLatitude: Double(self.arrayActiveData[index].pickupLocationLat) ?? 0.00,longitude: Double(self.arrayActiveData[index].pickupLocationLong) ?? 0.00,zoom: 12.0)
            
            mapView.camera = camera
            
            let coordinatePickup = CLLocationCoordinate2D(latitude:  Double(self.arrayActiveData[index].pickupLocationLat) ?? 0.00, longitude: Double(self.arrayActiveData[index].pickupLocationLong) ?? 0.00)
            
            
            let coordinateDelivery = CLLocationCoordinate2D(latitude:  Double(self.arrayActiveData[index].deliveryLocationLat) ?? 0.00, longitude: Double(self.arrayActiveData[index].deliveryLocationLong) ?? 0.00)
    
            let marker1 = GMSMarker(position:coordinatePickup)
                marker1.title = ""
                marker1.icon = UIImage(named: "CircelFill")
                marker1.map = mapView
            
            let marker2 = GMSMarker(position: coordinateDelivery)
                marker2.title = ""
                marker2.icon = UIImage(named: "squar_green_point")
                marker2.map = mapView
            self.drawToLocation(originPosition: coordinatePickup, destinationPosition: coordinateDelivery)
            
        }
    }
    
    
    @IBAction func Back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func AddFuel(_ sender: Any) {
        let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
        let controller = (storyBoard.instantiateViewController(withIdentifier: "AddFuelViewController") as?  AddFuelViewController)!
        controller.fleetId = fleetId
        controller.loadId = loadId
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    @IBAction func LoadandFleet(_ sender: Any) {
        let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
        let controller = (storyBoard.instantiateViewController(withIdentifier: "LoadandFleetViewController") as?  LoadandFleetViewController)!
        controller.loadId = loadId
        controller.fleetID = fleetId
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    @IBAction func CompleteAction(_ sender: Any) {
        if self.arrayActiveData[index].trackingStatus == "Assigned"{
            
            ActiveActionSheet()
            
        }
        else{
            ActionSheet()
        }
   
    }
    
    func ActionSheet()
        {
            let alert = UIAlertController(title: nil, message:"Are you sure you want to complete the trip?", preferredStyle: .alert)
            
            let No = UIAlertAction(title:"No", style: UIAlertAction.Style.destructive, handler: { action in
            })
                alert.addAction(No)
            
            let Yes = UIAlertAction(title:"Yes", style: .default , handler: { action in
                self.CompleteAPI()
             
            })
            alert.addAction(Yes)
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true)
            })
        }
    
    func ActiveActionSheet() {
        
        let alert = UIAlertController(title: nil, message:"Are you sure you want to accept this load?", preferredStyle: .alert)
        
        let No = UIAlertAction(title:"No", style: UIAlertAction.Style.destructive, handler: { action in
        })
            alert.addAction(No)
        
        let Yes = UIAlertAction(title:"Yes", style: .default , handler: { action in
            self.ActiveAPI()
         
        })
        alert.addAction(Yes)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
        
    }
    
    
    func CompleteAPI(){
        
        if arrayActiveData.count > index {
            let params = [
                "loadFleetDetailId": arrayActiveData[index].loadFleetDetailId,
                "status": "Delivered",
            ] as [String : Any]
            typeDelivered = "Delivered"
            UpdateLoadTrackingStatusRequest.shared.UpdateLoadTrackingStatusAPI(requestParams: params) { (obj, message, success,Verification) in
                
                if success {
                    self.showAlertWith(message ?? GlobalConstants.serverError)
                }
                else{
                    self.MessageAlertError(message:message ?? GlobalConstants.serverError)

                }
            }
        }
    }
    
    func ActiveAPI(){
        
        if arrayActiveData.count > index {
            let params = [
                "loadFleetDetailId": arrayActiveData[index].loadFleetDetailId,
                "status": "PickedUp",
            ] as [String : Any]
            UpdateLoadTrackingStatusRequest.shared.UpdateLoadTrackingStatusAPI(requestParams: params) { (obj, message, success,Verification) in
                
                if success {
                    self.showAlertWith(message ?? GlobalConstants.serverError)
                }
                else{
                    self.MessageAlertError(message:message ?? GlobalConstants.serverError)

                }
            }
        }
    }
    
    
    func showAlertWith(_ message:String) {
        let alert = UIAlertController(title: "Success!", message: message, preferredStyle: .alert)

          let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
              self.navigationController?.popViewController(animated: true)
               
          }

          alert.addAction(confirmAction)

        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    func drawToLocation(originPosition : CLLocationCoordinate2D , destinationPosition : CLLocationCoordinate2D)
        {
            
            let origin = "\(originPosition.latitude),\(originPosition.longitude)"
            let Destination = "\(destinationPosition.latitude),\(destinationPosition.longitude)"
            
            let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(Destination)&mode=driving&key=\(GlobalConstants.GoogleWebAPIKey)"
            
            guard let mapUrl = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
                print("Invalid URL")
                return
            }
                
            let task = URLSession.shared.dataTask(with: mapUrl) { data, response, error in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
//                    do {
//                        if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
//                            {
//                               
//                            let preRoutes = json["routes"] as? NSArray
//                                
//                            if preRoutes?.count == 0 {
//                                    return
//                            }
//
//                            let routes = preRoutes?[0] as! NSDictionary
//                                let routeOverviewPolyline:NSDictionary = routes.value(forKey: "overview_polyline") as! NSDictionary
//                                let polyString = routeOverviewPolyline.object(forKey: "points") as! String
//                                
//                                DispatchQueue.main.async(execute: { [self] in
//                                    let path = GMSPath(fromEncodedPath: polyString)
//                                    let polyline = GMSPolyline(path: path)
//                                    polyline.strokeWidth = 3.0
//                                    polyline.strokeColor = UIColor.blue
//                                    polyline.map = self.mapView
//                                    
//                                    if  self.mapView != nil {
//                                            if let path = path {
//                                                let bounds = GMSCoordinateBounds(path: path)
//                                                self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
//                                            }
//                                        }
//                                    
//                                })
//                            }
//                        } catch {
//                            print("parsing error")
//                        }
                    
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any],
                           let preRoutes = json["routes"] as? [[String: Any]], !preRoutes.isEmpty,
                           let routeOverviewPolyline = preRoutes[0]["overview_polyline"] as? [String: Any],
                           let polyString = routeOverviewPolyline["points"] as? String {

                            DispatchQueue.main.async { [weak self] in
                                guard let self = self else { return }
                                guard let path = GMSPath(fromEncodedPath: polyString) else { return }

                                let polyline = GMSPolyline(path: path)
                                polyline.strokeWidth = 3.0
                                polyline.strokeColor = .blue
                                polyline.map = self.mapView

                                let bounds = GMSCoordinateBounds(path: path)
                                mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
                                
                            }

                        } else {
                            print("Invalid or empty route data")
                        }
                    } catch {
                        print("JSON parsing failed: \(error.localizedDescription)")
                    }
                    }
                }
            task.resume()
        }
    
    @IBAction fileprivate func PickUpDirections(_ sender: Any) {
          pickUpDirectionsAction = false
          alertSheet()
    }
    
    @IBAction fileprivate func DeliveryDirections(_ sender: Any) {
        pickUpDirectionsAction = true
        alertSheet()
    }
   
  //MARK:-   Map Alert Function
      
      func alertSheet(){
          
          if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
              
              let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Choose application", message: "" , preferredStyle: .actionSheet)
          
              let MapButton = UIAlertAction(title: "Maps", style: .default) { _ in
                  
                  self.openAppleMap()
              
              }
              actionSheetControllerIOS8.addAction(MapButton)
              
              let GoogleButton = UIAlertAction(title: "Google Maps", style: .default)
              { _ in
                  self.googleMap()
                  
              }
              actionSheetControllerIOS8.addAction(GoogleButton)
              
              
              let CancelActionButton = UIAlertAction(title: "Cancel", style: .cancel)
              { _ in
                  
              }
              actionSheetControllerIOS8.addAction(CancelActionButton)
              self.present(actionSheetControllerIOS8, animated: true, completion: nil)
              
          }else{
              openAppleMap()
          }
      }
      
      func googleMap(){
          
          if arrayActiveData.count > index {

              let data : DriverLoadsArray = self.arrayActiveData[index]
              var  tlatitude = Double(data.pickupLocationLat)
              var  tlongitude = Double(data.pickupLocationLong)
              var address = data.pickupLocation

              if pickUpDirectionsAction {
                  tlatitude = Double(data.deliveryLocationLat) ?? 0.00
                  tlongitude = Double(data.deliveryLocationLong) ?? 0.00
                  address = data.deliveryLocation
              }
              
              let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

              let destination: String
              if let lat = tlatitude, let lon = tlongitude {
                  destination = "\(lat),\(lon)"
              } else if !encodedAddress.isEmpty {
                  destination = encodedAddress
              } else {
                  destination = ""
              }

              let urlString = "comgooglemaps://?saddr=&daddr=\(destination)"
              if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
                  UIApplication.shared.open(url, options: [:], completionHandler: nil)
              } else {
                  print("Google Maps is not available or URL is invalid.")
              }
              
          }
      }
   
      func openAppleMap() {
          
          if arrayActiveData.count > index {
              let data : DriverLoadsArray = self.arrayActiveData[index]
              var  tlatitude = Double(data.pickupLocationLat) ?? 0.00
              var  tlongitude = Double(data.pickupLocationLong) ?? 0.00
              
              if pickUpDirectionsAction {
                  tlatitude = Double(data.deliveryLocationLat) ?? 0.00
                  tlongitude = Double(data.deliveryLocationLong) ?? 0.00
                
                  let center = CLLocationCoordinate2D(latitude:tlatitude, longitude:tlongitude)
                  openMapsAppWithDirections(to: center, destinationName: data.deliveryLocation)
              }
              else{
                  let center = CLLocationCoordinate2D(latitude:tlatitude, longitude:tlongitude)
                  openMapsAppWithDirections(to: center, destinationName: data.pickupLocation)
              }
          }
      }
   
      func openMapsAppWithDirections(to coordinate: CLLocationCoordinate2D, destinationName name: String) {
          let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
          let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
          let mapItem = MKMapItem(placemark: placemark)
          mapItem.name = name
          mapItem.openInMaps(launchOptions: options)
      }
}
   
   

extension ParcelDetailsRequestController
{
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error" + error.description)
    }
    
    @objc func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    }
}
extension ParcelDetailsRequestController : GMSMapViewDelegate
{
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
      
    }
}
