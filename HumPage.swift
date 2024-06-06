import SwiftUI
import CoreML
import SoundAnalysis
import AVFoundation
import MusicKit

// Navigation state object to control navigation across views
class NavigationState: ObservableObject {
    @Published var shouldPopToRoot = false
}

struct TabItem: View {
    @State private var selection = 0
    @StateObject private var navigationState = NavigationState()
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                HumPage()
                    .navigationBarTitle("Hum")
                    .navigationBarHidden(true)
                    .environmentObject(navigationState)
            }
            .tabItem {
                Label("Hum", systemImage: "music.mic")
            }
            .tag(0)
            
            NavigationView {
                VocalRangeHome()
                    .navigationBarTitle("My Vocal Range")
                    .navigationBarHidden(true)
                    .environmentObject(navigationState)
            }
            .tabItem {
                Label("My Vocal Range", systemImage: "music.quarternote.3")
            }
            .tag(1)
        }
        .onChange(of: selection) { _ in
            navigationState.shouldPopToRoot = false
        }
        .environmentObject(navigationState)
    }
}

struct HumPage: View {
    @EnvironmentObject var navigationState: NavigationState
    @State var isListening = false;
    @State var isRecording = false;
    @State private var timeCount = 0.0
    @State private var timer: Timer? = nil
    @State private var searchTerm: String = ""
    @State var recorder: AVAudioRecorder?
    @State var observer: ResultsObservers!
    @State var classificationResults: [ClassifiedResult] = [] // Initialize an empty array
    @State var finishedClassify = false

    
    
    var body: some View {
        VStack {
            Text(isListening ? "Please Hum for 15 Seconds" : "Tap and Start Humming")
                .font(.system(size: 28))
                .font(.headline)
                .fontWeight(.bold)
            
            Text(isListening ? "\(Int(round(timeCount))) / 15 s" : "to search songs")
                .font(.system(size: 25))
                .fontWeight(.light)
                .padding(.bottom)
            
            ZStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 202, height: 202)
                Circle()
                    .stroke(lineWidth: 8)
                    .fill(Color.lightgrey)
                    .frame(width: 210, height: 210)
                
                Image(systemName: isListening ? "mic.fill" : "mic")
                    .resizable()
                    .frame(width: 88.0, height: 120.0)
                    .imageScale(.medium)
                    .foregroundColor(Color.white)
                    .padding()
                    .symbolEffect(.bounce, value: isListening)
            }
            .onTapGesture {
                isListening.toggle()
            }
            .onChange(of: isListening){newValue in
                if newValue {
                    startTimer()
                    requestMicrophonePermission()
                } else {
                    stopTimer()
                    stopRecording()
                }
            }
            .onChange(of: finishedClassify){
                if finishedClassify{
                    
                }
            }
        }
        .onAppear(){
            isListening = false
            finishedClassify = false
            isRecording = false
            setupRecorder()
            observer = ResultsObservers(result: $classificationResults) // Use the new binding
            print("mainview loaded")

        }
        .padding(.bottom, 50.0)
    }
    func setupRecorder() {
        // Define the filename and path for the recording
        let fileName = "my_recording.m4a"
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentsPath.appendingPathComponent(fileName)
        
        // Specify recording settings (modify as needed)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            print("berhasil setup")
            recorder = try AVAudioRecorder(url: filePath, settings: settings)
        } catch {
            print("Error creating AVAudioRecorder: \(error.localizedDescription)")
        }
    }
    
    func requestMicrophonePermission() {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission { allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.startRecording()
                    } else {
                        // Handle permission denial, inform user
                        print("Microphone permission denied. Please allow access in Settings.")
                    }
                }
            }
        } catch {
            print("Error setting up recording session: \(error.localizedDescription)")
        }
    }
    
    func startRecording() {
        if recorder != nil {
            recorder?.prepareToRecord()
            recorder?.record()
            isRecording = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 16.0) { [self] in
                self.stopRecording()
                print("finishrecord")
            }
        }
    }
    
    func stopRecording() {
        recorder?.stop()
        isRecording = false
        
        do{
            Task {
                try await Task.sleep(nanoseconds:2500000)
                classifyRecording()
            }
        }
    }
    
    func classifyRecording() {
        guard let recorderURL = recorder?.url else { return }
        
        // Check if recording file exists before proceeding
        if FileManager.default.fileExists(atPath: recorderURL.path) {
            do {
                let audioFileAnalyzer = try SNAudioFileAnalyzer(url: recorderURL)
                
                let request = try SNClassifySoundRequest(mlModel: SongHum(configuration: MLModelConfiguration()).model)
                
                do {
                    try audioFileAnalyzer.add(request, withObserver: observer)
                    try audioFileAnalyzer.analyze()
                } catch {
                    print(error)
                }
                
            } catch {
                print(error)
            }
        } else {
            print("Recording file not found. Please try again.")
        }
    }
    
    private func startTimer() {
        timeCount = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeCount < 15 {
                timeCount += 1
            } else {
//                isListening = false
                stopTimer()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

class ResultsObservers: NSObject, SNResultsObserving {
    @Binding var classificationResults: [ClassifiedResult] // Changed to an array of ClassifiedResult
    
    init(result: Binding<[ClassifiedResult]>) {
        _classificationResults = result
    }
    
    /// Notifies the observer when a request generates a prediction.
    func request(_ request: SNRequest, didProduce result: SNResult) {
        // Downcast the result to a classification result.
        guard let result = result as? SNClassificationResult else { return }
        
        // Get all classifications
        let classifications = result.classifications
        
        // Convert classifications to a list of ClassifiedResult
        var classifiedResults: [ClassifiedResult] = []
        for classification in classifications {
            let confidence = classification.confidence * 100.0
            let percentString = String(format: "%.2f%%", confidence)
            classifiedResults.append(ClassifiedResult(identifier: classification.identifier, confidence: percentString))
        }
        
        // Update the binding with the list
        classificationResults = classifiedResults
    }
    
    
    
    
    /// Notifies the observer when a request generates an error.
    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("The analysis failed: \(error.localizedDescription)")
    }
    
    
    /// Notifies the observer when a request is complete.
    func requestDidComplete(_ request: SNRequest) {
        print("The request completed successfully!")
        print(self.classificationResults.first!)
    }
}

struct ClassifiedResult: Identifiable {
    let id: String // Add an id property
    let identifier: String
    let confidence: String
    
    init(identifier: String, confidence: String) {
        self.id = UUID().uuidString // Generate a unique id
        self.identifier = identifier
        self.confidence = confidence
    }
}

#Preview {
    TabItem()
}
