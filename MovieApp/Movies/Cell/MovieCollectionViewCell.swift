//
//  MovieCollectionViewCell.swift
//  MovieApp
//
//  Created by Cengizhan Tomak on 3.07.2023.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var starRatingStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCell(viewModel: MoviesModels.FetchMovies.ViewModel.DisplayedMovie) {
        if let posterUrl = ImageUrlHelper.imageUrl(for: viewModel.posterPath) {
            posterImage.load(url: posterUrl)
        }
        
        let vote = viewModel.vote / 2
        
        let fullStars = Int(vote)
        let halfStar = vote - Float(fullStars)
        var starImages: [UIImage] = []
        let fullStarImage = UIImage(systemName: "star.fill")
        let halfStarImage = UIImage(systemName: "star.leadinghalf.filled")
        let emptyStarImage = UIImage(systemName: "star")
        for i in 0..<5 {
            if i < fullStars {
                starImages.append(fullStarImage!)
            } else if i == fullStars && halfStar >= 0.5 {
                starImages.append(halfStarImage!)
            } else {
                starImages.append(emptyStarImage!)
            }
        }
        
        starRatingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for image in starImages {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            starRatingStackView.addArrangedSubview(imageView)
            starRatingStackView.spacing = 2
            imageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    imageView.heightAnchor.constraint(equalToConstant: 14),
                    imageView.widthAnchor.constraint(equalToConstant: 14)
                ])
        }
        
        titleLabel.text = viewModel.title
        releaseDateLabel.text = viewModel.releaseDate
    }

}
