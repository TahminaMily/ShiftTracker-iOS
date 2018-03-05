//
//  ShiftDetailViewController.swift
//  ShiftTracker
//
//  Created by Tahmina Khanam on 5/3/18.
//  Copyright © 2018 Deputy. All rights reserved.
//

import UIKit
import MapKit
import Kingfisher

class ShiftDetailViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var startLabel: UILabel!
    @IBOutlet var endLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    public var shift: Shift?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let shift = shift else { return show(error: "No Shift Found") }

        configure(shift: shift)
    }

    func configure(shift: Shift) {
        imageView.kf.setImage(with: shift.image)
        startLabel.text = Formatters.displayDateFormatter.string(for: shift.startEvent?.time).flatMap { "Started: " + $0 }
        endLabel.text = Formatters.displayDateFormatter.string(for: shift.endEvent?.time).flatMap { "Ended: " + $0 } ?? "Current Shift"

        mapView.add(shift:shift)
        mapView.fitAllAnnotations()
    }
}

extension ShiftDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as?  MKPolyline else { return MKOverlayRenderer() }

        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 4
        renderer.strokeColor = UIColor.red
        return renderer
    }
} 


