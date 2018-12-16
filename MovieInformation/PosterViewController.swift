//
//  PosterViewController.swift
//  MovieInformation
//
//  Created by Apple on 2018. 12. 17..
//  Copyright © 2018년 Nowstring. All rights reserved.
//

import UIKit

class PosterViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    var posterImage: UIImage!
    var currentMovie: Movie!
    var gesRecognizer : UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gesRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapDetected( _:)))
        self.view.addGestureRecognizer(gesRecognizer)
        
        self.scrollView.maximumZoomScale = 3.0
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.delegate = self
        
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.posterImageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.posterImageView?.image = self.posterImage
    }
    
    
    @IBAction func tapDetected(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
 

}
