//
//  ChannelCell.swift
//  TVPlayer
//
//  Created by Сперанский Никита on 16.09.2022.
//

import UIKit

final class ChannelCell: UICollectionViewCell {

    static var reuseId: String = "ChannelCell"

    @IBOutlet weak var channelImageView: UIImageView!
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var channelProgramTitle: UILabel!
    @IBOutlet weak var isFavoriteButton: UIButton!
    
    private var cellChannel: Channel!
    private var isFavoriteContact = false {
        didSet {
            isFavoriteButton.tintColor = isFavoriteContact ? .systemBlue : .systemGray3
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCell()
    }

    func configure(with channel: Channel, isFavorite: Bool = false) {
        channelTitleLabel.text = channel.nameRu
        channelProgramTitle.text = channel.current.title
        getImageFromUrl(channel.image)
        cellChannel = channel
        
        isFavoriteContact = isFavorite
//        isFavoriteButton.tintColor = isFavoriteContact ? .systemBlue : .systemGray3
    }
    
    
    @IBAction func isFavoriteAction(_ sender: UIButton) {
        isFavoriteContact.toggle()
        DataManager.shared.changeFavoriteStatus(at: cellChannel)
//        isFavoriteButton.tintColor = isFavoriteContact ? .systemBlue : .systemGray3
    }
    
    private func setupCell() {
        
        layer.backgroundColor = UIColor(red: 0.192, green: 0.192, blue: 0.208, alpha: 0.5).cgColor
        layer.cornerRadius = 10
        clipsToBounds = true
        
//        isFavoriteButton.tintColor = isFavoriteContact ? .systemBlue : .systemGray3
    }
    
    /// Загрузка  и установка картинки
    private func getImageFromUrl(_ url: String) {
        guard let url = URL(string: url) else { return }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async {
                self.channelImageView.image = UIImage(data: imageData)
            }
        }
    }

}
