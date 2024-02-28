//  BeaconInfo.swift
//  BeaconTest
//
//  Created by Michele Colella on 27/02/24.
//

import Foundation
import SwiftUI


struct BeaconInfo: Identifiable {
    let id = UUID()
    let name        : String
    let color       : Color
    let description : String
    let proximityUUID: String
    let major       : Int
    let minor       : Int
    var distance: Double?
}


class BeaconDataManager {
    var beaconInfos: [BeaconInfo] = [BeaconInfo(name: "Quadro 3",
                                                color: Color(red: 84/255, green: 77/255, blue: 160/255),
                                                description: "Una descrizione di Blueberry Pie",
                                                proximityUUID: "B9407F30-F5F8-466E-AFF9-25556B57FE6D",
                                                major: 48657,
                                                minor: 19523),
                                     BeaconInfo(name: "Quadro 2",
                                                color: Color(red: 142/255, green: 212/255, blue: 220/255),
                                                description: "Una descrizione di Icy Marshmallow",
                                                proximityUUID: "B9407F30-F5F8-466E-AFF9-25556B57FE6D",
                                                major: 6439,
                                                minor: 63043),
                                     BeaconInfo(name: "Quadro 1",
                                                color: Color(red: 162/255, green: 213/255, blue: 181/255),
                                                description: "Una descrizione di Mint Cocktail",
                                                proximityUUID: "B9407F30-F5F8-466E-AFF9-25556B57FE6D",
                                                major: 52575,
                                                minor: 36583)
    ]
}

