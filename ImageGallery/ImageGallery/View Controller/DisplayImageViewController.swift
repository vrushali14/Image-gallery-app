//
//  DisplayImageViewController.swift
//  ImageGallery
//
//  Created by Jadhav, V. A. on 27/09/2020.
//  Copyright © 2020 Vrushali. All rights reserved.
//

import UIKit

class DisplayImageViewController: UIViewController {

    @IBOutlet weak var imageView : UIImageView!
    var image : UIImage!
    var imageURL : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)

        if let url = URL(string:self.imageURL) {
            self.imageView.load(url: url)
        }
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
