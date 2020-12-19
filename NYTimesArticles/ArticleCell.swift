//
//  ArticleCell.swift
//  NYTimesArticles
//
//  Created by Burhanuddin Sunelwala on 19/12/20.
//

import UIKit
import AlamofireImage

class ArticleCell: UITableViewCell {

    @IBOutlet private weak var photoView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var byLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var dayLabel: UILabel!

    var article: Article? {
        didSet {
            guard let article = article else { return }

            titleLabel.text = article.title
            byLabel.text = article.byline

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
                if let date = article.publishedDate {
                dateLabel.text = dateFormatter.string(from: date)
                dateFormatter.dateFormat = "E"
                    dayLabel.text = dateFormatter.string(from: date).uppercased()
            }


            if let url = article.media?.first(where: { $0.type == "image" })?
                .mediaMetadata?.first(where: { $0.format == "Standard Thumbnail" })?
                .url {
                photoView.af_setImage(withURL: url)
            }
        }
    }
}
