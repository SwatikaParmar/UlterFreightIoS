//
//  FuelReceiptViewController.swift
//  FreightPulse
//
//  Created by Mac on 22/05/25.
//

import UIKit

class FuelReceiptViewController: UIViewController,UIScrollViewDelegate {
    
  
    @IBOutlet weak var lbeTitle: UILabel!
    @IBOutlet weak var viewFuelReceiptImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!

    var urlString: String!
    var titleString = "View Fuel Receipt"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbeTitle.text = titleString

        urlString =  GlobalConstants.BASE_IMAGE_URL + urlString
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        scrollView.zoomScale = 1.0

        self.viewFuelReceiptImage?.sd_setImage(with: URL.init(string:(urlString)),
                               placeholderImage: UIImage(named: "imgPlaceH"),
                               options: .refreshCached,
                               completed: nil)
    }
    
    // MARK: - UIScrollViewDelegate 
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return viewFuelReceiptImage
        }
    
    
    @IBAction func btnBackPreessed(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    

}
