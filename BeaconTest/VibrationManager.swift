import Foundation
import UIKit

class VibrationManager {
    static let shared = VibrationManager()
    private var timer: Timer?
    var currentDistance: Double? {
        didSet {
            adjustTimerBasedOnDistance()
        }
    }

    func hapticFeedback() {
        guard let distance = currentDistance else { return }
        print(distance)
        let minDistance = 0.0
        let maxDistance = 10.0
        let distancePercentage = min(max((distance - minDistance) / (maxDistance - minDistance), 0), 1)
        
        let feedbackGenerator: UIImpactFeedbackGenerator.FeedbackStyle
        if distancePercentage <= 0.3 {
            print("Heavy: \(distance)")
            feedbackGenerator = .heavy
        } else if distancePercentage <= 0.7 {
            print("Medium: \(distance)")
            feedbackGenerator = .medium
        } else {
            print("Light: \(distance)")
            feedbackGenerator = .light
        }
        
        let generator = UIImpactFeedbackGenerator(style: feedbackGenerator)
        generator.impactOccurred()
    }
    
    func startVibrating() {
        stopVibrating()
        adjustTimerBasedOnDistance()
    }
    
    func stopVibrating() {
        timer?.invalidate()
        timer = nil
    }

    func updateDistance(_ distance: Double) {
        currentDistance = distance
    }
    
    private func adjustTimerBasedOnDistance() {
        guard let distance = currentDistance else { return }
        
        let minDistance = 0.0
        let maxDistance = 10.0
        let distancePercentage = min(max((distance - minDistance) / (maxDistance - minDistance), 0), 1)
        
        // Calcola l'intervallo del timer in modo che sia più corto (più veloce) per le distanze minori
        // e più lungo (più lento) per le distanze maggiori.
        let timerInterval = 0.1 + (0.9 * distancePercentage) // Varia da 0.1 a 1 secondo
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { [weak self] _ in
            self?.hapticFeedback()
        }
    }


}
