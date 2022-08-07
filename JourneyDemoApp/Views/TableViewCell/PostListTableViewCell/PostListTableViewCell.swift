//
//  PostListTableViewCell.swift
//  JourneyDemoApp
//
//  Created by HarishPatidar on 06/08/22.
//

import UIKit

class PostListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(post: Post) {
        lblTitle.text = post.title
        lblDescription.text = post.body
    }
}
