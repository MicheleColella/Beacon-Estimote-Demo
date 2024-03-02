import SwiftUI

struct ContentView: View {
    @ObservedObject var beaconManager = BeaconManager()
    @State private var selectedIndex: Int? = nil {
        didSet {
            // Gestisce le vibrazioni in base al beacon selezionato o deselezionato.
            handleVibrationForSelectedBeacon()
        }
    }

    var body: some View {
        NavigationView {
            if let selectedIndex = selectedIndex, beaconManager.detectedBeacons.indices.contains(selectedIndex) {
                selectedBeaconView(for: beaconManager.detectedBeacons[selectedIndex])
            } else {
                beaconListView()
            }
        }
        .onAppear { beaconManager.startRanging() }
        .onReceive(beaconManager.$detectedBeacons) { _ in
            guard let selectedIndex = self.selectedIndex,
                  selectedIndex < beaconManager.detectedBeacons.count else {
                return
            }

            let selectedBeacon = beaconManager.detectedBeacons[selectedIndex]
            // Aggiorna la distanza nel VibrationManager se cambia.
            if VibrationManager.shared.currentDistance != selectedBeacon.distance {
                VibrationManager.shared.updateDistance(selectedBeacon.distance ?? 0.0)
            }
        }

    }

    private func handleVibrationForSelectedBeacon() {
        guard let selectedIndex = selectedIndex, selectedIndex < beaconManager.detectedBeacons.count else {
            VibrationManager.shared.stopVibrating()
            return
        }
        let selectedBeacon = beaconManager.detectedBeacons[selectedIndex]
        VibrationManager.shared.updateDistance(selectedBeacon.distance ?? 0.0)
        VibrationManager.shared.startVibrating()
    }

    private func selectedBeaconView(for beacon: BeaconInfo) -> some View {
        VStack {
            Spacer()
            Text(beacon.name)
                .font(.largeTitle)
            Text("\(beacon.distance ?? 0, specifier: "%.2f") m")
                .font(.title)
                .foregroundColor(beacon.color)
            Spacer()
            Button("Indietro") { self.selectedIndex = nil }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .navigationBarTitle("Distanza Beacon", displayMode: .inline)
    }

    private func beaconListView() -> some View {
        List(beaconManager.detectedBeacons.indices, id: \.self) { index in
            beaconRow(for: beaconManager.detectedBeacons[index])
                .onTapGesture { self.selectedIndex = index }
        }
        .navigationBarTitle("Beacon Rilevati")
    }

    private func beaconRow(for beacon: BeaconInfo) -> some View {
        VStack(alignment: .leading) {
            Text(beacon.name).font(.headline)
            Rectangle().frame(height: 2).foregroundColor(beacon.color)
            Text("Major: \(beacon.major), Minor: \(beacon.minor)").font(.subheadline)
            if let distanceDescription = beacon.distanceDescription {
                Text(distanceDescription).font(.caption).foregroundColor(.blue)
            }
        }
        .padding()
    }
}
