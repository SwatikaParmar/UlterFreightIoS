//
//  ParcelDetailsRequestController.swift
//  FreightPulse
//
//  Created by AbsolveTech on 26/10/24.
//

import UIKit

class ParcelDetailsRequestController: UIViewController {

    @IBOutlet weak var view_NavConst: NSLayoutConstraint!
    @IBOutlet weak var table_HeightConst: NSLayoutConstraint!
    @IBOutlet weak var tableViewList: UITableView!
    @IBOutlet weak var _scrollView: UIScrollView!

    @IBOutlet weak var lbe_Pickup: UILabel!
    @IBOutlet weak var lbe_Delivery: UILabel!
    @IBOutlet weak var lbe_Distance: UILabel!
    @IBOutlet weak var lbe_Duration: UILabel!
    @IBOutlet weak var lbe_Price: UILabel!
    @IBOutlet weak var lbe_SType: UILabel!
    @IBOutlet weak var lbe_PaymentBy: UILabel!
    @IBOutlet weak var lbe_ParcelName: UILabel!
    @IBOutlet weak var lbe_ParcelNotes: UILabel!
    
    @IBOutlet weak var btn_Confirm: UIButton!
    @IBOutlet weak var btn_Cancel: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func Back(_ sender: Any) {
      self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func AddFuel(_ sender: Any) {
        let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
        let controller = (storyBoard.instantiateViewController(withIdentifier: "AddFuelViewController") as?  AddFuelViewController)!
        self.navigationController?.pushViewController(controller, animated: true)
        
    }

}
