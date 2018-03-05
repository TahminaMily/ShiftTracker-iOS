//
//  MapKit+Extensions.swift
//  ShiftTracker
//
//  Created by Tahmina Khanam on 5/3/18.
//  Copyright © 2018 Deputy. All rights reserved.
//

import MapKit

extension MKPointAnnotation {
    convenience init(coordinate: CLLocationCoordinate2D, title: String) {
        self.init()
        self.coordinate = coordinate
        self.title = title
    }
}


extension MKMapView {
    public func fitAllAnnotations() {
        let coordinates = annotations.map { $0.coordinate }

        //set region
        let poly = MKPolygon(coordinates: coordinates, count: coordinates.count)
        //zoom out just a little bit
        let padding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let rect = mapRectThatFits(poly.boundingMapRect, edgePadding: padding)
        setVisibleMapRect(rect, animated: true)
    }

    func add(shift: Shift) {
        guard let startLocation = shift.startEvent?.location else { return }
        addAnnotation(MKPointAnnotation(coordinate: startLocation, title: "Start"))
        guard let endLocation = shift.endEvent?.location else { return }
        addAnnotation(MKPointAnnotation(coordinate: endLocation, title: "End"))
        addOverlays([MKPolyline(coordinates: [startLocation, endLocation], count: 2)]) //line
    }
}
