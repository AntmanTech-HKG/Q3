//
//  JobDetailsTableViewCell.swift
//  Q3
//
//  Created by Anthony on 23/1/2018.
//  Copyright © 2018 AntmanTech. All rights reserved.
//

import UIKit
import Kingfisher

class JobDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var jobTitleLbl: UILabel!
    @IBOutlet weak var postDateLbl: UILabel!
    @IBOutlet weak var regionLbl: UILabel!
    @IBOutlet weak var jobDescriptionLbl: UILabel!
    @IBOutlet weak var thumbnailIV: UIImageView!
    @IBOutlet weak var labelToThumbnailConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelToTrailingConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func objectFor(_ jobDetails: JobDetails) {
        jobTitleLbl.text = jobDetails.title
        
        postDateLbl.text = "posted on \(jobDetails.createdAt.formatToDayOnly())"
        
        regionLbl.text = jobDetails.address?.state
        jobTitleLbl.text = jobDetails.title

        if let htmlData = NSString(string: jobDetails.jobDescription).data(using: String.Encoding.unicode.rawValue) {
            let attributedString = try! NSAttributedString(data: htmlData, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            jobDescriptionLbl.attributedText = attributedString
        }


        if jobDetails.pictures.count != 0, let pictures = jobDetails.pictures.first {
            labelToThumbnailConstraint.priority = 999
            labelToThumbnailConstraint.isActive = true
            thumbnailIV.isHidden = false
            thumbnailIV.kf.setImage(with: URL(string: (pictures.normal)))
        } else {
            labelToThumbnailConstraint.priority = 250
            labelToThumbnailConstraint.isActive = true
            thumbnailIV.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
