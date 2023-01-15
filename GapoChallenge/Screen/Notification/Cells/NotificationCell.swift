//
//  NotificationCell.swift
//  GapoChallenge
//
//  Created by Chu Hung on 15/01/2023.
//

import UIKit
import SDWebImage

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var notificationContentLabel: UILabel!
    @IBOutlet weak var notificationTimeLabel: UILabel!
    
    var notificationData: NotificationData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(_ data: NotificationData?) {
        self.notificationData = data
        setStatusUI()
        setThumbnalUI()
        setIconUI()
        setNotificationContentUI()
        setNotificationTimeUI()
    }
    
    private
    func setStatusUI() {
        guard let status = notificationData?.status,
              status == "unread" else {
            self.contentView.backgroundColor = .systemBackground
            return
        }
        self.contentView.backgroundColor = UIColor.lighter2
    }
    
    private
    func setThumbnalUI() {
        guard let notificationData = notificationData,
              let thumbUrlString = notificationData.imageThumb,
              !thumbUrlString.isEmpty else {
            return
        }
        thumbImageView.sd_setImage(with: URL(string: thumbUrlString), placeholderImage: UIImage(named: "gp_logo"))
    }
    
    private
    func setIconUI() {
        guard let notificationData = notificationData,
              let iconUrlString = notificationData.icon,
              !iconUrlString.isEmpty else {
            return
        }
        iconImageView.sd_setImage(with: URL(string: iconUrlString))
    }
    
    private
    func setNotificationContentUI() {
        guard let message = notificationData?.message?.text,
              !message.isEmpty else {
            return
        }
        let contentAttributed = NSMutableAttributedString(string: message,
                                                          attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        
        notificationData?.message?.highlights.forEach {
            if let offset = $0.offset,
               let length = $0.length {
                contentAttributed.setAttributes(
                    [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14,
                                                                    weight: .semibold)],
                    range: NSRange(location: offset,
                                   length: length))
            }
        }
        notificationContentLabel.attributedText = contentAttributed
    }
    
    private
    func setNotificationTimeUI() {
        guard let time = notificationData?.receivedAt else {
            return
        }
        let dateTime = Date(timeIntervalSince1970: TimeInterval(time))
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd/MM/YYYY, HH:mm"
        let dateTimeString = dateFormater.string(from: dateTime)
        notificationTimeLabel.text = dateTimeString
    }
}
