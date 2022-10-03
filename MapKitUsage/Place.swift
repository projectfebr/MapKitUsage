//
//  Place.swift
//  MapKitUsage
//
//  Created by Aleksandr Bolotov on 03.10.2022.
//

import Foundation
import MapKit

class Place: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D

    init(
        coordinate: CLLocationCoordinate2D
    ) {
        self.coordinate = coordinate

        super.init()
    }

    init?(feature: MKGeoJSONFeature) {
        guard
            let point = feature.geometry.first as? MKPointAnnotation
        else {
            return nil
        }
        coordinate = point.coordinate
        super.init()
    }
}
