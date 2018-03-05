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
    @IBOutlet var barButtonItem: UIBarButtonItem!
    @IBOutlet var collectionView: UICollectionView!
    var shifts: [Shift] = []
    let dataSource = DataSource()
    
    private enum Constants {
        enum BarButtonTitle {
            static let start = "Start"
            static let end = "End"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        dataSource.fetchShifts { [weak self] result in
            DispatchQueue.main.async {
                guard let this = self else { return }

                guard let shifts = result.value else {
                    return this.show(error: result.error ?? "Could not fetch shifts")
                }

                this.shifts = shifts
                this.collectionView.reloadData()
                
                // see if there is a running shift
                if shifts.first(where: { $0.isRunning }) == nil {
                    this.barButtonItem.title = Constants.BarButtonTitle.start
                } else {
                    this.barButtonItem.title = Constants.BarButtonTitle.end
                }
                this.barButtonItem.isEnabled = true
            }
        }
    }
    
    @IBAction func dtdTapBarButtonItem(_ sender: UIBarButtonItem) {
        sender.isEnabled = false
        LocationManager.shared.fetchLocation { [weak self] location, error in
            guard let coordinate = location?.coordinate else { return }
            
            let event = Shift.Event(time: Date(), latitude: coordinate.latitude, longitude: coordinate.longitude)
            let route: APIRouter
            switch self?.barButtonItem.title {
            case Constants.BarButtonTitle.end?:
                route = APIRouter.shiftEnd(event: event)
            default:
                route = APIRouter.shiftStart(event: event)
            }
            APIRouter.sessionManager.request(route)
                .responseData(completionHandler: { (response) in
                    guard let this = self else { return }
                    this.loadData()
                })
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
        let screenSize = collectionView.bounds.size
        let columns: CGFloat = (traitCollection.horizontalSizeClass == .compact) ? 2.0 : 3.0
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let width: CGFloat = (screenSize.width - layout.sectionInset.left - layout.sectionInset.right - layout.minimumInteritemSpacing * columns)/columns
        let height: CGFloat = width + 50
        
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShiftDetailViewController") as? ShiftDetailViewController else { return }

        detailViewController.shift = shifts[indexPath.row]
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
