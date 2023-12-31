//
//  CastCrewTableViewCell.swift
//  MovieApp
//
//  Created by Cengizhan Tomak on 6.07.2023.
//

import UIKit

class CastCrewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var castImage: UIImageView!
    @IBOutlet weak var castNameLabel: UILabel!
    @IBOutlet weak var castCharNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func setCell(viewModel: CastCrewModels.FetchCastCrew.ViewModel.DisplayedCast) {
        castNameLabel.text = viewModel.name
        castCharNameLabel.text = viewModel.character.uppercased()
        
        if let profileUrl = ImageUrlHelper.imageUrl(for: viewModel.profilePhotoPath) {
            castImage.load(url: profileUrl)
        }
    }
}
