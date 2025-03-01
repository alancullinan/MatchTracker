import SwiftUI
import Combine

struct MatchTimerView: View {
    @Bindable var match: Match
    @Environment(\.scenePhase) private var scenePhase
    @State private var totalPausedTime: TimeInterval = 0
    @State private var isRunning: Bool = false

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var formattedTime: String {
        let minutes = match.elapsedTime / 60
        let seconds = match.elapsedTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var body: some View {
        VStack {
            Text(match.matchPeriod.rawValue.capitalized)
                .font(.headline)
                .padding(.bottom, 5)

            Text(formattedTime)
                .font(.largeTitle)
                .padding()
                .onReceive(timer) { _ in
                    if isRunning && !match.isPaused {
                        updateElapsedTime()
                    }
                }

            HStack {
                Button(action: toggleTimer) {
                    Text(startStopButtonText())
                        .frame(width: 120, height: 40)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                if isPlayPeriod(match.matchPeriod) {
                    Button(action: pauseTimer) {
                        Image(systemName: match.isPaused ? "play.fill" : "pause.fill")
                            .font(.title2)
                            .frame(width: 50, height: 40)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }

                Button(action: resetMatch) {
                    Text("Reset")
                        .frame(width: 100, height: 40)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .background {
                saveTimerState()
            } else if newPhase == .active {
                resumeTimerFromBackground()
            }
        }
        .onAppear {
            validateCurrentPeriodState()
        }
    }

    private func updateElapsedTime() {
        if let start = match.currentPeriodStart {
            match.elapsedTime = Int(Date().timeIntervalSince(start) - totalPausedTime)
        }
    }

    private func startStopButtonText() -> String {
        if !isPlayPeriod(match.matchPeriod) {
            // If not in a play period
            return "Start Half"
        } else if match.currentPeriodStart == nil {
            // If in a play period but not yet started
            return "Start Half"
        } else {
            // If period is running (regardless of paused state)
            return "End Half"
        }
    }

    private func toggleTimer() {
        if match.currentPeriodStart == nil {
            startNextPeriod()
        } else {
            stopPeriod()
        }
    }

    private func startNextPeriod() {
        // Always set a new start time when starting a period
        match.currentPeriodStart = Date()
        
        // Reset paused time
        totalPausedTime = 0
        
        // Reset elapsed time at the start of any period
        match.elapsedTime = 0
        
        match.isPaused = false
        isRunning = true
        
        // Move to the next period in MatchPeriod enum sequence
        if let currentIndex = MatchPeriod.allCases.firstIndex(of: match.matchPeriod),
           currentIndex + 1 < MatchPeriod.allCases.count {
            match.matchPeriod = MatchPeriod.allCases[currentIndex + 1]
        }
    }

    private func stopPeriod() {
        // Don't call updateElapsedTime() here as it may not account for the paused state correctly
        
        // Instead, use the current elapsedTime value which should already be correct
        // whether the timer is running or paused
        
        match.isPaused = true
        isRunning = false
        
        // Reset currentPeriodStart to nil to indicate period is not running
        match.currentPeriodStart = nil
        
        // Move to the next non-play period in MatchPeriod sequence
        if let currentIndex = MatchPeriod.allCases.firstIndex(of: match.matchPeriod),
           currentIndex + 1 < MatchPeriod.allCases.count {
            match.matchPeriod = MatchPeriod.allCases[currentIndex + 1]
        }
    }

    private func pauseTimer() {
        if match.isPaused {
            resumeTimer()
        } else {
            match.isPaused = true
            match.lastPausedAt = Date()
        }
    }

    private func resumeTimer() {
        if let pausedAt = match.lastPausedAt {
            // Only increment the total paused time
            totalPausedTime += Date().timeIntervalSince(pausedAt)
        }
        match.isPaused = false
        match.lastPausedAt = nil
    }

    private func isPlayPeriod(_ period: MatchPeriod) -> Bool {
        return period == .firstHalf || period == .secondHalf ||
               period == .extraTimeFirstHalf || period == .extraTimeSecondHalf
    }

    private func saveTimerState() {
        if !match.isPaused {
            match.lastPausedAt = Date()
        }
    }

    private func resumeTimerFromBackground() {
        if let lastPausedAt = match.lastPausedAt, !match.isPaused, isPlayPeriod(match.matchPeriod) {
            let timeAway = Date().timeIntervalSince(lastPausedAt)
            totalPausedTime += timeAway
            match.lastPausedAt = nil
        }
        validateCurrentPeriodState() // Ensure state is in sync after returning from background
    }

    private func resetMatch() {
        match.matchPeriod = .notStarted
        match.currentPeriodStart = nil
        match.elapsedTime = 0
        totalPausedTime = 0
        match.isPaused = true
        isRunning = false
    }
    
    // New function to ensure timer state consistency
    private func validateCurrentPeriodState() {
        // Make sure isRunning state matches proper conditions
        if match.currentPeriodStart != nil && isPlayPeriod(match.matchPeriod) && !match.isPaused {
            isRunning = true
        } else {
            isRunning = false
        }
    }
}

// Preview for SwiftUI Canvas
struct MatchTimerView_Previews: PreviewProvider {
    static var previews: some View {
        let testMatch = Match()
        testMatch.isPaused = true
        testMatch.matchPeriod = .firstHalf

        return MatchTimerView(match: testMatch)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
