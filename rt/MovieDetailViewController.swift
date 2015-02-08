//
//  MovieDetailViewController.swift
//  rt
//
//  Created by David Bowen on 2/7/15.
//  Copyright (c) 2015 David Bowen. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController, UIScrollViewDelegate {

    var movie: NSDictionary?

    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var url0 = movie!.valueForKeyPath("posters.thumbnail") as NSString
        let url = url0.stringByReplacingOccurrencesOfString("_tmb.jpg", withString: "_ori.jpg")
        myImageView.setImageWithURL(NSURL(string: url))
        
        titleLabel.text = movie!["title"] as? String
        synopsisLabel.text = movie!["synopsis"] as? String
        synopsisLabel.sizeToFit()
        
        // there is surely a better way?
        let contentHeight = myImageView.bounds.height + titleLabel.bounds.height + synopsisLabel.bounds.height + 20
        myScrollView.contentSize = CGSize(width: 320, height: contentHeight)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
