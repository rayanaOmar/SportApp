//
//  SportTableViewCell.swift
//  SportApp
//
//  Created by admin on 29/12/2021.
//

import UIKit

class SportTableViewCell: UITableViewCell {

    @IBOutlet weak var sportImage: UIImageView!
    @IBOutlet weak var sportName: UILabel!
    
    weak var delegate: Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.imageSelected))
        sportImage.isUserInteractionEnabled = true
        sportImage.addGestureRecognizer(tap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        sportImage.image = UIImage(named: "AddImage")
    }
    
    func configure(_ name: String,_ imageData: Data?){
        sportName.text = name
        
        if let imageData = imageData {
            sportImage.image = UIImage(data: imageData)
        }
    }
    
    @objc func imageSelected(_ sender: UITableViewDataSource){
        delegate?.updateImage(self)
    }

}
