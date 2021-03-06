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

//        let url = URL(string: "http://localhost:8888/simplyrets/file.js")!
        let url = URL(string: "https://simplyrets:simplyrets@api.simplyrets.com/properties")!
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
                    
                    // without nil check
                    // listing.listDate = dictionary["listDate"] as? String
                    if let theListDate = dictionary["listDate"] as? String {
                        listing.listDate = theListDate
                        print("The date listed is: \(theListDate)")
                    }
                    
                    // listing.listPrice = dictionary["listPrice"] as? NSNumber
                    if let theListPrice = dictionary["listPrice"] as? NSNumber {
                        listing.listPrice = theListPrice
                        print("The listed price is: \(theListPrice)")
                    }
                    if let theAddress = dictionary["address"] as? [String:Any]  {
                            if let fullAddress = theAddress["full"] as? String {
                                listing.address = fullAddress
                                print("The full address is: \(fullAddress)")
                            }
                    }
                    if let theMlsId = dictionary["mlsId"] as? Int {
                        listing.mlsId = theMlsId
                        print("The mlsId is: \(theMlsId)")
                    }
                    
                    if let geo = dictionary["geo"] as? [String:Any]  {
                        if let theLng = geo["lng"] as? Double {
                        if let theLat = geo["lat"] as? Double {
                            listing.geoLat = theLat
                            listing.geoLng = theLng
                            print("The coords are: \(theLat),\(theLng)\n")
                            }
                        }
                    }
                    
                    // the array of photos are
                    if let thePhotos = dictionary["photos"] as? [Any] {
                        listing.photos = thePhotos as? String
                       
                        if let theFirst = thePhotos.first {
                            listing.mainImage = theFirst as? String
                            print("The first photo is: \(theFirst)")
                        }
                        print("The photos are: \(thePhotos)")
                    }
                    

                    self.listings?.append(listing)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.listing = sender as? Listing
        }
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let listing = listings![indexPath.item]
        performSegue(withIdentifier: "toDetailVC", sender: listing)
    }


   
    
}




