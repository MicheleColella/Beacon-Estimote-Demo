//BeaconManager

import Foundation
import CoreLocation
import SwiftUI


class BeaconManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager?
    @Published var beaconDataManager = BeaconDataManager() // Gestore dati beacon definiti
    @Published var detectedBeacons: [BeaconInfo] = [] // Array dei beacon rilevati

    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.requestAlwaysAuthorization() // Richiede l'autorizzazione dell'utente per l'accesso alla localizzazione
        
        // Monitora tutti i beacon definiti in beaconInfos
        for beaconInfo in beaconDataManager.beaconInfos {
            let uuid = UUID(uuidString: beaconInfo.proximityUUID)!
            let beaconRegion = CLBeaconRegion(uuid: uuid, major: CLBeaconMajorValue(beaconInfo.major), minor: CLBeaconMinorValue(beaconInfo.minor), identifier: "\(beaconInfo.name)")
            self.locationManager?.startMonitoring(for: beaconRegion)
            self.locationManager?.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: uuid, major: CLBeaconMajorValue(beaconInfo.major), minor: CLBeaconMinorValue(beaconInfo.minor)))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for beacon in beacons {
            // Continua solo se la distanza del beacon è maggiore di 0
            guard beacon.accuracy > 0 else {
                continue
            }

            if let index = beaconDataManager.beaconInfos.firstIndex(where: { $0.proximityUUID == beacon.uuid.uuidString && $0.major == beacon.major.intValue && $0.minor == beacon.minor.intValue }) {
                DispatchQueue.main.async {
                    var updatedBeacon = self.beaconDataManager.beaconInfos[index]
                    updatedBeacon.distance = beacon.accuracy
                    updatedBeacon.distanceDescription = self.updateDistanceDescription(with: beacon)
                    
                    // Aggiorna l'array detectedBeacons solo se la distanza è minore o uguale di 10 metri
                    if beacon.accuracy <= 10.0 {
                        if let detectedIndex = self.detectedBeacons.firstIndex(where: { $0.id == updatedBeacon.id }) {
                            self.detectedBeacons[detectedIndex] = updatedBeacon
                        } else {
                            self.detectedBeacons.append(updatedBeacon)
                        }
                    } else {
                        // Rimuovi il beacon dall'array detectedBeacons se la distanza diventa maggiore di 10 metri o non valida
                        self.detectedBeacons.removeAll { $0.id == updatedBeacon.id }
                    }
                }
            }
        }
    }

    
    func startRanging() {
        // Riavvia il monitoraggio e il ranging dei beacon in caso sia necessario dopo l'inizializzazione
        for beaconInfo in beaconDataManager.beaconInfos {
            let uuid = UUID(uuidString: beaconInfo.proximityUUID)!
            let beaconRegion = CLBeaconRegion(uuid: uuid, major: CLBeaconMajorValue(beaconInfo.major), minor: CLBeaconMinorValue(beaconInfo.minor), identifier: "\(beaconInfo.name)")
            self.locationManager?.startMonitoring(for: beaconRegion)
            self.locationManager?.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: uuid, major: CLBeaconMajorValue(beaconInfo.major), minor: CLBeaconMinorValue(beaconInfo.minor)))
        }
    }
    
    private func updateDistanceDescription(with beacon: CLBeacon) -> String {
        switch beacon.proximity {
        case .immediate:
            return "Molto vicino"
        case .near:
            return "Vicino"
        case .far:
            return "Lontano"
        default:
            return "Fuori portata"
        }
    }

}
