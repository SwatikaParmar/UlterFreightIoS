//
//  TabViewController.swift
//  FreightPulse
//
//  Created by AbsolveTech on 25/09/24.
//

import UIKit

class TabViewController: UIViewController {

        @IBOutlet weak var TabBarView: UIView!
        @IBOutlet weak var Contentview: UIView!
        
        @IBOutlet weak var three_UIImageView: UIImageView!
        @IBOutlet weak var one_UIImageView: UIImageView!
        @IBOutlet weak var two_UIImageView: UIImageView!
        @IBOutlet weak var four_UIImageView: UIImageView!
        
        @IBOutlet weak var one_Lbe: UILabel!
        @IBOutlet weak var two_Lbe: UILabel!
        @IBOutlet weak var three_Lbe: UILabel!
        @IBOutlet weak var four_Lbe: UILabel!
        @IBOutlet weak var lbeCount: UILabel!

        var className = "1"
        var lastOpenClass = ""
        
        var oneNavigation: UINavigationController?
        var twoNavigation: UINavigationController?
        var threeNavigation: UINavigationController?
        var fourNavigation: UINavigationController?
        var fiveNavigation: UINavigationController?
    
        var homeClass: HomeViewController?

        
        override func viewDidLoad() {
            super.viewDidLoad()
            print(accessToken())
            
            self.lbeCount.layer.cornerRadius = 12
            lbeCount.layer.masksToBounds = true
            
            one_Lbe.text = "Home"
            two_Lbe.text = "Loads"
            three_Lbe.text = "Documents"
            four_Lbe.text = "Setting"
            
            one_Lbe.textColor = UIColor.white
            two_Lbe.textColor = UIColor.white
            three_Lbe.textColor = UIColor.white
            four_Lbe.textColor = UIColor.white
            
            one_UIImageView.image = UIImage(named: "oneImage")
            two_UIImageView.image = UIImage(named: "twoImage")
            three_UIImageView.image = UIImage(named: "threeImage")
            four_UIImageView.image = UIImage(named: "fourImage")
            
            one_UIImageView.tintColor = UIColor.white
            two_UIImageView.tintColor = UIColor.white
            three_UIImageView.tintColor = UIColor.white
            four_UIImageView.tintColor = UIColor.white
            
            one_Lbe.font = UIFont(name:FontName.Inter.Regular, size: "".dynamicFontSize(11)) ?? UIFont.systemFont(ofSize: 15)
            two_Lbe.font = UIFont(name:FontName.Inter.Regular, size: "".dynamicFontSize(11)) ?? UIFont.systemFont(ofSize: 15)
            three_Lbe.font = UIFont(name:FontName.Inter.Regular, size: "".dynamicFontSize(11)) ?? UIFont.systemFont(ofSize: 15)
            four_Lbe.font = UIFont(name:FontName.Inter.Regular, size: "".dynamicFontSize(11)) ?? UIFont.systemFont(ofSize: 15)

            if className == "1" {
               
                one_Lbe.font = UIFont(name:FontName.Inter.SemiBold, size: "".dynamicFontSize(12)) ?? UIFont.systemFont(ofSize: 15)
                if homeClass != nil {
                    oneNavigation?.popToRootViewController(animated: false)
                    oneNavigation!.didMove(toParent: self)
                    self.Contentview.bringSubviewToFront(self.oneNavigation!.view)
                    
                }
                else{
                    guard let home = self.storyboard?.instantiateViewController(identifier: "HomeViewController") as? HomeViewController else { return}
                    homeClass = home
                    oneNavigation = UINavigationController(rootViewController: home)
                    oneNavigation?.view.frame = Contentview.bounds
                    addChild(oneNavigation!)
                    Contentview.addSubview((oneNavigation?.view)!)
                    oneNavigation!.didMove(toParent: self)
                    
                }
            }
            
            
            else if className == "2"{
               
                two_Lbe.font = UIFont(name:FontName.Inter.SemiBold, size: "".dynamicFontSize(12)) ?? UIFont.systemFont(ofSize: 15)
                if Contentview.contains(twoNavigation?.view ?? UIView()){
                    twoNavigation?.view.removeFromSuperview()
                }

                guard let home = self.storyboard?.instantiateViewController(identifier: "LoadsViewController") as? LoadsViewController else { return}
                home.view.frame = Contentview.bounds
                twoNavigation = UINavigationController(rootViewController: home)
                twoNavigation?.view.frame = Contentview.bounds
                addChild(twoNavigation!)
                Contentview.addSubview((twoNavigation?.view)!)
                twoNavigation!.didMove(toParent: self)
                
                
                
            }
            
            else if className == "3"{
              
                three_Lbe.font = UIFont(name:FontName.Inter.SemiBold, size: "".dynamicFontSize(12)) ?? UIFont.systemFont(ofSize: 15)
                
                if Contentview.contains(threeNavigation?.view ?? UIView()){
                    threeNavigation?.view.removeFromSuperview()
                }
                
                guard let home = self.storyboard?.instantiateViewController(identifier: "DocumentsViewController") as? DocumentsViewController else { return}
                home.view.frame = Contentview.bounds
                threeNavigation = UINavigationController(rootViewController: home)
                threeNavigation?.view.frame = Contentview.bounds
                addChild(threeNavigation!)
                Contentview.addSubview((threeNavigation?.view)!)
                threeNavigation!.didMove(toParent: self)
                
                
            }
            else{
            
                four_Lbe.font = UIFont(name:FontName.Inter.SemiBold, size: "".dynamicFontSize(12)) ?? UIFont.systemFont(ofSize: 15)
                if Contentview.contains(fiveNavigation?.view ?? UIView()){
                    fiveNavigation?.view.removeFromSuperview()
                }
                
                guard let home = self.storyboard?.instantiateViewController(identifier: "SettingsViewController") as? SettingsViewController else { return}
                home.view.frame = Contentview.bounds
                fiveNavigation = UINavigationController(rootViewController: home)
                fiveNavigation?.view.frame = Contentview.bounds
                
                addChild(fiveNavigation!)
                Contentview.addSubview((fiveNavigation?.view)!)
                fiveNavigation!.didMove(toParent: self)
                
            }
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            
            
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            homeClass?.view.frame = Contentview.bounds
        }
        
        @IBAction func oneAction(_ sender: Any) {
            className = "1"
            viewDidLoad()
            
        }
        
        @IBAction func twoAction(_ sender: Any) {
            className = "2"
            viewDidLoad()
        }
        
        @IBAction func threeAction(_ sender: Any) {
            
            className = "3"
            viewDidLoad()
        }
        @IBAction func fourAction(_ sender: Any) {
            
            className = "4"
            viewDidLoad()
        }
        
        @IBAction func fiveAction(_ sender: Any) {
            
            
        }
        
    }
