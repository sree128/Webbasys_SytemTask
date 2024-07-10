//
//  ProductCell.swift
//  SystemTask
//
//  Created by Kanchireddy sreelatha on 08/07/24.
//

import UIKit
import AVFoundation

class ProductCell: UICollectionViewCell {
    static let reuseIdentifier = "ProductCell"
    @IBOutlet weak var imgVU: UIImageView!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var videoPlayerView: UIView!
    var playerLayer: AVPlayerLayer?
    var playpauseTimer : Timer?
    
    let url  = ""// Asset URL
    var asset: AVAsset!
    var player: AVPlayer!
    var playerItem: AVPlayerItem!
    var playerObserver:AnyObject!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.playerLayer = AVPlayerLayer()
        // self.playerLayer?.backgroundColor = UIColor.black.cgColor
        self.playerLayer!.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.playerLayer!.videoGravity = .resizeAspectFill
        self.videoPlayerView.layer.insertSublayer(self.playerLayer!, at: 0)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imgVU.image = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
    }
    public var maximumDuration: TimeInterval {
        get {
            if let playerItem = self.playerItem {
                return CMTimeGetSeconds(playerItem.duration)
            } else {
                return CMTimeGetSeconds(CMTime.indefinite)
            }
        }
    }
    
    public var currentTime: TimeInterval {
        get {
            if let playerItem = self.playerItem {
                return CMTimeGetSeconds(playerItem.currentTime())
            } else {
                return CMTimeGetSeconds(CMTime.indefinite)
            }
        }
    }
    func resetTimer(){
        if self.playpauseTimer != nil {
            self.playpauseTimer?.invalidate()
        }
    }
    func configure(with product: Post) {
        notesLabel.text = product.notes
        descriptionLabel.text = product.description
        if let videoURLString = product.attachments?[0].url, let videoURL = URL(string: videoURLString) {
            let player = AVPlayer(url: videoURL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.videoGravity = .resizeAspectFill
            playerLayer?.frame = videoPlayerView.bounds
            if let playerLayer = playerLayer {
                videoPlayerView.layer.addSublayer(playerLayer)
                player.play()
            }
        }
        
    }
   
    func loadImg(urlstring: String){
        
        if let url = URL(string: urlstring) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self.imgVU.image = image
                    
                }
            }
            
            task.resume()
        }

        }

    }
    



extension ProductCell {
    func playVideoIfNeeded() {
        if let playerLayer = playerLayer, playerLayer.player?.rate == 0 {
            playerLayer.player?.play()
        }
    }
}
