//
//  SceneDelegate.swift
//  FreightPulse
//
//  
//

import UIKit
import LGSideMenuController
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        RootControllerManager().SetRootViewController()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

class RootControllerManager: NSObject {
    
    //MARK: -  @Set RootView Controller
    func SetRootViewController(){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        
        if UserDefaults.standard.bool(forKey: Constants.login) {
            let homecontroller = storyboard.instantiateViewController(withIdentifier: "TabViewController")
                let leftController = storyboard.instantiateViewController(withIdentifier: "MenuUserController")
                
                let navigationController = UINavigationController(rootViewController: homecontroller)
                
                navigationController.isNavigationBarHidden = true
                
                let sideMenu = LGSideMenuController(rootViewController: navigationController,
                                                    leftViewController: leftController,
                                                    rightViewController: nil)
                sideMenu.leftViewWidth = UIScreen.main.bounds.size.width - 110
                sideMenu.navigationController?.isNavigationBarHidden = true
                //   sideMenu.rootViewStatusBarStyle = .lightContent
                //   sideMenu.leftViewStatusBarStyle = .lightContent
                sideMenu.isLeftViewStatusBarHidden = true
                sideMenu.panGestureForLeftView.isEnabled = false
                UIApplication.shared.windows.first?.rootViewController = sideMenu
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
        else{
            let storyboardMain = UIStoryboard(name: "Main", bundle: nil)
            PushToRootScreen(ClassName: storyboardMain.instantiateViewController(withIdentifier: "ViewController") as! ViewController)
            

        }
    }
    
    //MARK: -  @Push To RootController
    func PushToRootScreen(ClassName:UIViewController){
                
        let navigationController = UINavigationController(rootViewController: ClassName)
        navigationController.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
