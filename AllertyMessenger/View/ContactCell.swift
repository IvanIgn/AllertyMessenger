//
//  MyCell.swift
//  Smarket
//
//  Created by Ivan Ignatkov on 2019-03-19.
//  Copyright © 2019 TechCompetence. All rights reserved.
//

import UIKit
import SDWebImage

//protocol UserTableViewCellDelegate {
//    func didTapAvatarImage(indexPath: IndexPath)
//}

class ContactCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var statusIcon: UIImageView!
    

//   var indexPath: IndexPath!
//   var delegate: UserTableViewCellDelegate?
//   let tapGestureRecognizer = UITapGestureRecognizer()

//     override func awakeFromNib() {
//           super.awakeFromNib()
//
//           tapGestureRecognizer.addTarget(self, action: #selector(self.avatarTap))
//           productImage.isUserInteractionEnabled = true
//           productImage.addGestureRecognizer(tapGestureRecognizer)
//       }

    override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code

                 // statusIcon.image = .init(imageLiteralResourceName: "offline")

       }


    override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)

       }

    func configureCell(profile: Profile) {  // contact: Contact
       // if contact.image == "" {
          //  productImage.image = UIImage(named:"defaultImage")
       // } else {
           // productImage.sd_setImage(with: URL(string: contact.image), completed: nil)
      //  }
    //  let status =  UserDefaults.standard.bool(forKey: "status")

        if /*profile.checkUserPresense() == true  &&  */ profile.isOnline == false {
            statusIcon.image = .init(imageLiteralResourceName: "onlineIcon")
        }
        else  /*||  profile.isOnline == false*/  {
            statusIcon.image = .init(imageLiteralResourceName: "offlineIcon")
        }
//        tapGesture = UITapGestureRecognizer(target: self, action: #selector(lblTapped))
//        tapGesture.numberOfTapsRequired = 1
//        productImage.addGestureRecognizer(tapGesture)
//        productImage.isUserInteractionEnabled = true

         if profile.photo == "" {
                   productImage.image = UIImage(named:"defaultImage")
               } else {
                    productImage.sd_setImage(with: URL(string: profile.photo!), completed: nil)
//                    productImage.layer.cornerRadius = 30
//                    productImage.clipsToBounds = true
            productImage.layer.borderWidth = 0.1
            productImage.layer.masksToBounds = false
            //productImage.layer.borderColor = UIColor.black.cgColor
            productImage.layer.cornerRadius = productImage.frame.height/2
            productImage.clipsToBounds = true
               }
        productNameLabel.text = profile.name  /*contact.contactName*/



       // productNameLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        //productNameLabel.font = UIFont(name: "Gill Sans" , size: 21.0)

        //locationLabel.text = profile.address   // contact.location


        //productImage.sd_setImage(with: URL(string: profile.photo?), completed: nil)

        //let formatter = DateFormatter()
        //formatter.dateFormat = "dd.MM.yyyy hh:mm"
        //let curTime = formatter.string(from: advert.time)
        //print(curTime)
       // timeLabel.text = curTime
        //advert.timestamp.calenderTimeSinceNow()
        }



}

