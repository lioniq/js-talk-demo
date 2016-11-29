//
//  NativeViewController.swift
//  js-talk
//
//  Created by JERRY LIU on 28/11/2016.
//  Copyright © 2016 LionIQ. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SDWebImage

class NativeViewController: UITableViewController {
    
    // array of photo url strings
    var detailPhotos: [String] = []
    
    // omg cache image heights....
    var imageHeights: [CGFloat] = []
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    
    override func viewDidLoad() {
        
        getItem()
    }
    
    private func getItem() {
        // API get item
        let appKey = "15ef0668e2f7d3234c1706997156c8a2"
        let appSecret = "2ab6633650437c8bb29ee5bcdf072034"
        
        let itemKey = "1074578361b531a8dfe6fb6f1e9bf5d7"
        let url = "https://lioniq.com/api/items/\(itemKey)"
        
        let headers: [String:String] = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "X-APP-KEY": appKey,
            "X-APP-SECRET": appSecret
        ]
        
        // clear caches
        detailPhotos = []
        imageHeights = []
        
        Alamofire.request(url, method: .get, parameters: [:], encoding: URLEncoding.default, headers: headers).validate().responseJSON {(response) in
            
            if let json = response.result.value as? Dictionary<String, AnyObject> {
                
                if let title = json["title"] as? String {
                    self.itemTitleLabel.text = title
                }
                
                if let price = json["price_label"] as? String {
                    // TODO
                }
                
                if let coverImage = json["square_cover_photo_url"] as? String {
                    // set image
                    self.coverImageView.sd_setImage(with: URL(string: coverImage)!)
                }
                
                if let photosArray = json["detail_photos"] as? [Dictionary<String, AnyObject>] {
                    for photoObj in photosArray {
                        let imageUrl = (photoObj["image_url"] as? String) ?? ""
                        self.detailPhotos.append(imageUrl)
                        self.imageHeights.append(0.0)
                    }
                }
                
                // reload 
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailPhotos.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return imageHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let urlString = detailPhotos[indexPath.row]
        let url = URL(string: urlString)!
        
        // typedef void(^SDWebImageCompletionBlock)(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL);

        let imageView = cell.viewWithTag(1001) as! UIImageView
        let placeholderImage = UIImage(named: "placeholder")!

        
        let completeBlock: SDWebImageCompletionBlock = {(image, error, cacheType, imageURL) -> Void in
            
            
            // calc image height
            let w = imageView.frame.width
            let k = w / (image?.size.width)!
            let h = (image?.size.height)! * k
            
            self.imageHeights[indexPath.row] = h
            
            // reload cell
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            self.tableView.endUpdates()
            
        }

        
        imageView.sd_setImage(with: url, placeholderImage: placeholderImage, options: [SDWebImageOptions.progressiveDownload], completed: completeBlock)
    
        return cell
    }
}


