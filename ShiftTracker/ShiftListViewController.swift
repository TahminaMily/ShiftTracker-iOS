//
//  ShiftListViewController.swift
//  ShiftTracker
//
//  Created by Tahmina Khanam on 4/3/18.
//  Copyright © 2018 Deputy. All rights reserved.
//

import UIKit
import Kingfisher

class ShiftListViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    var shifts: [Shift] = []
    let dataSource = DateSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource.fetchShifts { [weak self] shifts in
            DispatchQueue.main.async {
                guard let this = self, let shifts = shifts else { return }
                this.shifts = shifts
                this.collectionView.reloadData()
            }
        }
    }
}

extension ShiftListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shifts.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShiftCell", for: indexPath)
        guard let cell = collectionViewCell as? ShiftCell else { return collectionViewCell }
        
        cell.configure(shift: shifts[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        let columns: CGFloat
        if traitCollection.horizontalSizeClass == .regular {
            columns = 3.0
        } else {
            columns = 2.0
        }
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let width: CGFloat = (screenSize.width - layout.sectionInset.left - layout.sectionInset.right - layout.minimumInteritemSpacing * columns)/columns
        let height: CGFloat = width + 50
        
        return CGSize(width: width, height: height)
    }
}


class ShiftCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var startTimeLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    
    func configure(shift: Shift) {
        let url = shift.image.addOrUpdateQueryStringParameter(key: "key", value: UUID().uuidString)
        imageView.kf.setImage(with: url)
        
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
