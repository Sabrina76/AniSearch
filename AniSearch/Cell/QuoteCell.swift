//
//  QuoteCell.swift
//  AniSearch
//
//  Created by Sabrina Chen on 4/3/22.
//

import UIKit

class QuoteCell: UITableViewCell {
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var animeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
