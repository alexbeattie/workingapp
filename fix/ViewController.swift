//
//  ViewController.swift
//  fix
//
//  Created by Alex Beattie on 9/19/17.
//  Copyright © 2017 Artisan Branding. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {

    var listings:[Listing]?
    func fetchListings() {

        let url = URL(string: "http://localhost:8888/simplyrets/file.js")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)

                self.listings = [Listing]()
                
                for dictionary in json as! [[String:Any]] {
                    
                    let listing = Listing()
                    listing.listDate = dictionary["listDate"] as? String
                    listing.listPrice = dictionary["listPrice"] as? NSNumber
                    
                    self.listings?.append(listing)
                    
                    
                    
//                    print("\(listing.listDate) + \(listing.listPrice)")
                }
             
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    
                }
            } catch let jsonError {
                print(jsonError)
            }
            
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       fetchListings()
        let width = collectionView!.frame.width / 3
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)

}

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /*
         if let count = videos?.count {
         return count
         } means same as below */
//        listings?.sorted(by: { $0.listDate > $1.listDate})
        return listings?.count ?? 0
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // everytime deqeue is called, the cell initWith frame is called
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ListingsCollectionCell

        if let listing = listings?[indexPath.item] {
            
            cell.listing = listing
        }
        
        return cell
    }
}




