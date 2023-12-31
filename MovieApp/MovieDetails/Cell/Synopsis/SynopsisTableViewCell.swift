//
//  SynopsisTableViewCell.swift
//  MovieApp
//
//  Created by Cengizhan Tomak on 27.06.2023.
//

import UIKit

class SynopsisTableViewCell: UITableViewCell {

//    @IBOutlet weak var synopsisTextView: UITextView!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func setCell(viewModel: String) {
//        synopsisTextView.text = viewModel
        synopsisLabel.text = viewModel
    }
}
