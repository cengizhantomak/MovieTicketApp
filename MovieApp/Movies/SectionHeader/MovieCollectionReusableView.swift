//
//  MovieCollectionReusableView.swift
//  MovieApp
//
//  Created by Kerem Tuna Tomak on 4.07.2023.
//

import UIKit

class MovieCollectionReusableView: UICollectionReusableView {
    
    var title = UILabel()
    var image = UIImageView()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        configureSectionHeader()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSectionHeader() {
        title.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(title)
        addSubview(image)
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 6),
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            image.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 6),
            image.centerYAnchor.constraint(equalTo: centerYAnchor),
            image.widthAnchor.constraint(equalToConstant: 18),
            image.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        title.font = UIFont(name: "SFProText-Semibold", size: 14)
        title.textColor = UIColor(named: "E51937")
        title.text = "Now Showing"
        
        image.tintColor = UIColor(named: "E51937")
        let iconImage = UIImage(systemName: "play.circle.fill")
        image.image = iconImage
    }
}
