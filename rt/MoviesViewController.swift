//
//  MoviesViewController.swift
//  rt
//
//  Created by David Bowen on 2/7/15.
//  Copyright (c) 2015 David Bowen. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let apikey="a858bmgpurzt72kukecja4q6"
    
    var movies: [NSDictionary] = []
    var selectedMovie: NSIndexPath?
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        NSLog("viewDidLoad")
        super.viewDidLoad()

        title = "Rotten Tomatoes"
        tableView.dataSource = self
        tableView.delegate = self

        SVProgressHUD.show()
        loadMovieDataAsync() {
            () -> Void in
            SVProgressHUD.dismiss()
        }
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    func loadMovieDataAsync(onFinished: () -> Void) {
        var url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=\(apikey)")
        var request = NSURLRequest(URL: url!)

        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
            (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            onFinished()
            
            if ((error?) != nil || (response as NSHTTPURLResponse).statusCode != 200) {
                self.title = "\u{26A0} Network Error"
            }
            else {
                var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                self.movies = responseDictionary["movies"] as [NSDictionary]
                NSLog("Movie data loaded")
            }
            
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieTableViewCell
        
        let movie = movies[indexPath.row]
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        var url0 = movie.valueForKeyPath("posters.thumbnail") as NSString
        let url = url0.stringByReplacingOccurrencesOfString("_tmb.jpg", withString: "_ori.jpg")
        
        cell.movieImageView.setImageWithURL(NSURL(string: url))
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedMovie = indexPath
    }
    
    // Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as MovieDetailViewController
        NSLog("prepare for segue, sender=%@", "\(sender.dynamicType())")

        let indexPath = tableView.indexPathForSelectedRow()
        vc.movie = movies[indexPath!.row]
    }

    // Refreshing
    
    func onRefresh() {
        loadMovieDataAsync() {
            () -> Void in
            self.refreshControl.endRefreshing()
        }
    }

}
