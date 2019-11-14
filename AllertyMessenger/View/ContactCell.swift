//
//  MyCell.swift
//  Smarket
//
//  Created by Ivan Ignatkov on 2019-03-19.
//  Copyright © 2019 TechCompetence. All rights reserved.
//

import UIKit
import SDWebImage

class ContactCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
  
    //@IBOutlet weak var timeLabel: UILabel!
    
    func configureCell(profile: Profile) {  // contact: Contact
       // if contact.image == "" {
          //  productImage.image = UIImage(named:"defaultImage")
       // } else {
           // productImage.sd_setImage(with: URL(string: contact.image), completed: nil)
      //  }
        
         if profile.photo == "" {
                   productImage.image = UIImage(named:"defaultImage")
               } else {
                    productImage.sd_setImage(with: URL(string: profile.photo!), completed: nil)
               }
        productNameLabel.text = profile.name  /*contact.contactName*/
        
        productNameLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        
        locationLabel.text = profile.address   // contact.location
         
        //productImage.sd_setImage(with: URL(string: profile.photo?), completed: nil)
        
        //let formatter = DateFormatter()
        //formatter.dateFormat = "dd.MM.yyyy hh:mm"
        //let curTime = formatter.string(from: advert.time)
        //print(curTime)
       // timeLabel.text = curTime
        //advert.timestamp.calenderTimeSinceNow()
    }
}
