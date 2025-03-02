import SwiftUI
import Combine

struct MatchTimerView: View {
    @Bindable var match: Match
    
    // Timer state
    @State private var timerStartedTime: Date?
    @State private var accumulatedTime: TimeInterval = 0
    @State private var timerIsRunning: Bool = false
    @State private var refreshTrigger: Bool = false  // Added to force refresh
    
    // UI refresh timer - increased frequency for more responsive updates
    private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    private var elapsedTime: Int {
        if timerIsRunning, let startTime = timerStartedTime {
            return Int(accumulatedTime + Date().timeIntervalSince(startTime))
        } else {
            return Int(accumulatedTime)
        }
    }
    
    private var formattedTime: String {
        let minutes = elapsedTime / 60
        let seconds = elapsedTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var body: some View {
        VStack {
            Text(match.matchPeriod.rawValue)
                .font(.headline)
            
            Text(formattedTime)
                .font(.largeTitle)
                .onReceive(timer) { _ in
                    // Force view refresh by toggling state
                    refreshTrigger.toggle()
                    // Update match elapsed time
                    match.elapsedTime = elapsedTime
                    
                    // Debug output
                    print("Timer tick: \(formattedTime), Running: \(timerIsRunning)")
                }
            
            // Added current state indicator for debugging
            Text(timerIsRunning ? "Running" : "Stopped")
                .font(.caption)
                .foregroundColor(timerIsRunning ? .green : .red)
            
            HStack {
                Button(action: startStopTimer) {
                    Text(startStopButtonText())
                        .frame(width: 120, height: 40)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                if isPlayPeriod(match.matchPeriod) {
                    Button(action: pauseResumeTimer) {
                        Image(systemName: timerIsRunning ? "pause.fill" : "play.fill")
                            .font(.title2)
                            .frame(width: 50, height: 40)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
                Button(action: resetTimer) {
                    Text("Reset")
                        .frame(width: 100, height: 40)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .onAppear {
            print("MatchTimerView appeared")
            initializeFromMatch()
        }
        .onChange(of: refreshTrigger) { _, _ in
            // This ensures the view updates when refreshTrigger changes
            // No code needed here, just forcing a refresh
        }
    }
    
    private func initializeFromMatch() {
        print("Initializing from match: Period \(match.matchPeriod.rawValue), Paused: \(match.isPaused), ElapsedTime: \(match.elapsedTime)")
        
        // If period is active and not paused, start the timer
        if isPlayPeriod(match.matchPeriod) && !match.isPaused && match.currentPeriodStart != nil {
            accumulatedTime = TimeInterval(match.elapsedTime)
            timerStartedTime = Date()
            timerIsRunning = true
            print("Timer initialized and running")
        } else if match.elapsedTime > 0 {
            // If we have elapsed time but timer isn't running
            accumulatedTime = TimeInterval(match.elapsedTime)
            timerIsRunning = false
            print("Timer initialized but not running")
        } else {
            print("Timer reset on initialization")
            // Ensure we start with clean state
            accumulatedTime = 0
            timerStartedTime = nil
            timerIsRunning = false
        }
    }
    
    private func startStopButtonText() -> String {
        if isPlayPeriod(match.matchPeriod) && match.currentPeriodStart != nil {
            return "End Half"
        } else {
            return "Start Half"
        }
    }
    
    private func startStopTimer() {
        if isPlayPeriod(match.matchPeriod) && match.currentPeriodStart != nil {
            // End current period
            if timerIsRunning {
                // Update accumulated time
                if let startTime = timerStartedTime {
                    accumulatedTime += Date().timeIntervalSince(startTime)
                }
                timerIsRunning = false
                timerStartedTime = nil
            }
            
            // Store elapsed time in match
            match.elapsedTime = elapsedTime
            
            // Update match state
            match.isPaused = true
            match.currentPeriodStart = nil
            
            // Move to next period
            if let currentIndex = MatchPeriod.allCases.firstIndex(of: match.matchPeriod),
               currentIndex + 1 < MatchPeriod.allCases.count {
                match.matchPeriod = MatchPeriod.allCases[currentIndex + 1]
            }
            
            print("Period ended: \(match.matchPeriod.rawValue), ElapsedTime: \(match.elapsedTime)")
        } else {
            // Start new period
            // Reset time
            accumulatedTime = 0
            timerStartedTime = Date()
            timerIsRunning = true
            
            // Update match state
            match.currentPeriodStart = Date()
            match.isPaused = false
            match.elapsedTime = 0
            
            // Move to next period
            if let currentIndex = MatchPeriod.allCases.firstIndex(of: match.matchPeriod),
               currentIndex + 1 < MatchPeriod.allCases.count {
                match.matchPeriod = MatchPeriod.allCases[currentIndex + 1]
            }
            
            print("Period started: \(match.matchPeriod.rawValue)")
        }
    }
    
    private func pauseResumeTimer() {
        if timerIsRunning {
            // Pause timer
            if let startTime = timerStartedTime {
                accumulatedTime += Date().timeIntervalSince(startTime)
            }
            timerStartedTime = nil
            timerIsRunning = false
            
            // Update match
            match.isPaused = true
            match.elapsedTime = elapsedTime
            
            print("Timer paused at: \(formattedTime)")
        } else {
            // Resume timer
            timerStartedTime = Date()
            timerIsRunning = true
            
            // Update match
            match.isPaused = false
            
            print("Timer resumed from: \(formattedTime)")
        }
    }
    
    private func resetTimer() {
        // Reset timer state
        accumulatedTime = 0
        timerStartedTime = nil
        timerIsRunning = false
        
        // Reset match state
        match.matchPeriod = .notStarted
        match.currentPeriodStart = nil
        match.elapsedTime = 0
        match.isPaused = true
        
        print("Timer reset")
    }
    
    private func isPlayPeriod(_ period: MatchPeriod) -> Bool {
        return period == .firstHalf || period == .secondHalf ||
               period == .extraTimeFirstHalf || period == .extraTimeSecondHalf
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
