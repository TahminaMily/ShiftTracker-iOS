//
//  MapViewController.swift
//  ShiftTracker
//
//  Created by Tahmina Khanam on 5/3/18.
//  Copyright © 2018 Deputy. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    let dataSource = DataSource()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    func loadData() {
        showSpinner()
        dataSource.fetchShifts { [weak self] result in
            guard let this = self else { return }

            this.hideSpinner()
            guard let shifts = result.value else {
                return this.show(error: result.error ?? "Could not fetch shifts")
            }

            shifts.forEach { this.mapView.add(shift: $0) }
            this.mapView.fitAllAnnotations()
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as?  MKPolyline else { return MKOverlayRenderer() }

        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 4
        renderer.strokeColor = UIColor.red
        return renderer
    }
}

