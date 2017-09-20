//
//  Extensions.swift
//  fix
//
//  Created by Alex Beattie on 9/20/17.
//  Copyright © 2017 Artisan Branding. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImageUsingUrlString(urlString: String) {
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data:data!)
            }
        }).resume()
    }
}

