![MasterHead](https://estimote.com/assets/gfx/temp/estimote-logo-meta.jpg)
<!--
# Beacon Estimote Demo
This repository contains a Swift demo to calculate the distance of Estimote beacons and provide feedback through vibration. The code utilizes Core Location APIs for beacon detection and interaction. The demo continuously detects beacon signal strength, calculates the distance, and activates vibration accordingly. It's a useful example for understanding beacon interaction and implementing sensory feedback in beacon-based iOS applications.-->

# Estimote Beacon Demo for iOS
## Introduction

This demo provides practical examples of how to detect and interact with Estimote beacons within an iOS application using Swift. It demonstrates beacon detection, distance calculation, and vibration feedback based on proximity.

## Requirements

<ol>
  <li>iOS 13.0 or later.</li>
  <li>An iOS device with Bluetooth Low Energy.</li>
  <li>Estimote beacon with Bluetooth Low Energy.</li>
</ol> 

## Features
### Beacon Detection

* Utilizes Core Location to detect Estimote beacons.

### Distance Calculation

* Calculates the distance to the beacons, updating it in real-time.
### Vibration Feedback

* Provides haptic feedback based on the proximity to the detected beacon.
### Configuring Your Beacon

* Use the Estimote Cloud or the Estimote app to configure the UUID, major, and minor for your beacons.

## API Documentation

Below are the key functionalities provided by the demo, along with actual function implementations from the Swift files.

### BeaconInfo.swift

Defines the beacon information structure.

```
struct BeaconInfo: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
    let description: String
    let proximityUUID: String
    let major: Int
    let minor: Int
    var distance: Double?
    var distanceDescription: String?
}
```

### BeaconListView.swift

Manages the UI for listing detected beacons.

``` 
struct BeaconListView: View {
    var beaconInfos: [BeaconInfo]

    var body: some View {
        List(beaconInfos) { beaconInfo in
            VStack(alignment: .leading) {
                Text("Name: \(beaconInfo.name)")
                Text("UUID: \(beaconInfo.proximityUUID)")
                // Extend with more details as needed
            }
        }
    }
}
```

### BeaconManager.swift

Core functionality for beacon detection and interaction.

```
import CoreLocation

class BeaconManager: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?

    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        // Request authorization
        locationManager?.requestAlwaysAuthorization()
    }

    func startMonitoring() {
        guard let locationManager = locationManager else { return }
        let uuid = UUID(uuidString: "Your-Beacon-UUID")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "YourIdentifier")
        locationManager.startMonitoring(for: beaconRegion)
    }

    func stopMonitoring() {
        guard let locationManager = locationManager, let beaconRegion = locationManager.monitoredRegions.first as? CLBeaconRegion else { return }
        locationManager.stopMonitoring(for: beaconRegion)
    }
}
```

### ContentView.swift

Main view integrating other components.

```
struct ContentView: View {
    @State private var beaconInfos: [BeaconInfo] = []

    var body: some View {
        BeaconListView(beaconInfos: beaconInfos)
            .onAppear {
                // Example: Load beaconInfos from BeaconDataManager or elsewhere
            }
    }
}
```

### VibrationManager.swift

Manages haptic feedback.

```
import UIKit
import CoreHaptics

class VibrationManager {
    private var engine: CHHapticEngine?

    init() {
        try? engine = CHHapticEngine()
    }

    func startVibrating() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        // Example event: a strong, sharp tap
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try engine?.start()
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error).")
        }
    }

    func stopVibrating() {
        engine?.stop(completionHandler: nil)
    }
}
```

## Feedback, Questions, Issues

Please use GitHub issues for reporting bugs and submitting feedback.
