//  ContentView.swift
//  BeaconTest
//
//  Created by Michele Colella on 23/02/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var beaconManager = BeaconManager()
    
    var body: some View {
        NavigationView {
            List(beaconManager.detectedBeacons) { beacon in
                HStack {
                    VStack(alignment: .leading) {
                        Text(beacon.name)
                            .font(.headline)
                        Rectangle().foregroundColor(beacon.color)
                        Text("Major: \(beacon.major), Minor: \(beacon.minor)")
                            .font(.subheadline)
                    }
                    Spacer()
                    if let distance = beacon.distance {
                        Text("\(distance, specifier: "%.2f") m")
                            .foregroundColor(.gray)
                    } else {
                        Text("Distanza sconosciuta")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
            }
            .navigationBarTitle("Beacon Rilevati")
        }
        .onAppear {
            self.beaconManager.startRanging()
        }
    }
}

#Preview {
    ContentView()
}
