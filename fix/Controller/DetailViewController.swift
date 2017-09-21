//
//  DetailViewController.swift
//  fix
//
//  Created by Alex Beattie on 9/20/17.
//  Copyright © 2017 Artisan Branding. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    var annotation:MKAnnotation!
    var pointAnnotation:MKPointAnnotation!
    var pinView:MKPinAnnotationView!
    var region: MKCoordinateRegion!
    var mapType: MKMapType!
    
    var listing: Listing? {
        didSet  {
      
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupThumbNailImage()
        addressLabel.text = listing?.address
        if let thumnailImageName = listing?.mainImage {
            mainImageView.image = UIImage(named: thumnailImageName)
        }
//        let coordinates = CLLocationCoordinate2D(latitude: (listing?.geoLat)!, longitude: (listing?.geoLng)!)
//        let listingAnno = ListingAnno(title: (listing?.address)!, subtitle: (listing?.listDate)!, coordinate: coordinates)
//        mapView.addAnnotation(listingAnno)
        
        
        if let lat = listing?.geoLat, let lng = listing?.geoLng {
            let location = CLLocationCoordinate2DMake(lat, lng)
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, 27500.0, 27500.0)
            mapView.setRegion(coordinateRegion, animated: false)

            let pin = MKPointAnnotation()
//            let title = listing?.address
//            if let subtitle = listing?.listPrice  {
//                listing?.listPrice = subtitle
//            }

            
            pin.coordinate = location
            pin.title = listing?.address?.capitalized
            
            if let listPrice = listing?.listPrice {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                
                let subtitle = "\(numberFormatter.string(from: listPrice)!)"
                pin.subtitle = subtitle
            }
            
            
            mapView.addAnnotation(pin)
        }
//

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if mapView.annotations.count != 0 {
            annotation = mapView.annotations[0]
            mapView.removeAnnotation(annotation)
            
        }
        mapView.delegate = self

    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        setupThumbNailImage()

        let annoView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Default")
        annoView.pinTintColor = #colorLiteral(red: 0.5137254902, green: 0.8470588235, blue: 0.8117647059, alpha: 1)
        annoView.animatesDrop = true
        annoView.canShowCallout = true
        let swiftColor = #colorLiteral(red: 0.5137254902, green: 0.8470588235, blue: 0.8117647059, alpha: 1)
        annoView.centerOffset = CGPoint(x: 100, y: 400)
        annoView.pinTintColor = swiftColor
        
        // Add a RIGHT CALLOUT Accessory
        let rightButton = UIButton(type: UIButtonType.detailDisclosure)
        rightButton.frame = CGRect(x:0, y:0, width:32, height:32)
        rightButton.layer.cornerRadius = rightButton.bounds.size.width/2
        rightButton.clipsToBounds = true
        rightButton.tintColor = #colorLiteral(red: 0.5137254902, green: 0.8470588235, blue: 0.8117647059, alpha: 1)
        
        annoView.rightCalloutAccessoryView = rightButton
        
        
        let leftIconView = UIImageView()
        leftIconView.contentMode = .scaleAspectFill
        if let thumnailImageName = listing?.mainImage {
            leftIconView.image = UIImage(named: thumnailImageName)
            self.setupThumbNailImage()

        }


        let newBounds = CGRect(x:0.0, y:0.0, width:54.0, height:54.0)
        leftIconView.bounds = newBounds
        annoView.leftCalloutAccessoryView = leftIconView
        
        
        return annoView
    }

    func goOutToGetMap() {
        
        
        let lat = listing?.geoLat
        let lng = listing?.geoLng
        let location = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)

        let placemark = MKPlacemark(coordinate: location, addressDictionary: nil)
        
        let item = MKMapItem(placemark: placemark)
        item.name = listing?.address as? String
        item.openInMaps (launchOptions: [MKLaunchOptionsMapTypeKey: 2,
                                         MKLaunchOptionsMapCenterKey:NSValue(mkCoordinate: placemark.coordinate),
                                         MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving])
        
        
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
        let alertController = UIAlertController(title: nil, message: "Driving directions", preferredStyle: .actionSheet)
        let OKAction = UIAlertAction(title: "Get Directions", style: .default) { (action) in
            self.goOutToGetMap()
        }
        alertController.addAction(OKAction)
        
        present(alertController, animated: true) {
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
    }
    

    
    
    func setupThumbNailImage() {
        if let thumbnailImageUrl = listing?.mainImage {
            mainImageView.loadImageUsingUrlString(urlString: thumbnailImageUrl)
        }
    }
}

