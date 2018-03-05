//
//  ShiftCell.swift
//  ShiftTracker
//
//  Created by Tahmina Khanam on 5/3/18.
//  Copyright © 2018 Deputy. All rights reserved.
//

import UIKit

class ShiftCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var startTimeLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!

    func configure(shift: Shift) {
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: shift.uncachedImageURL, options: [.transition(.fade(0.2))])

        startTimeLabel.text = Formatters.displayDateFormatter.string(for: shift.startEvent?.time)
        if let startTime = shift.startEvent?.time, let endTime = shift.endEvent?.time {
            durationLabel.text = Formatters.dateComponentFormatter.string(from: startTime, to: endTime)
        } else {
            durationLabel.text = "ongoing..."
        }
    }

    override func prepareForReuse() {
        imageView.kf.cancelDownloadTask()
    }
}
