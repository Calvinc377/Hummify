//
//  VocalRangePage.swift
//  Hummify
//
//  Created by Calvin Christiano on 06/06/24.
//

import Foundation
import SwiftUI
import AVKit
import Accelerate

struct VocalRangeHome: View {
    @EnvironmentObject var navigationState: NavigationState
    @StateObject private var audioManager = AudioManager()
    @State var isRecordingLowest = false
    @State var isRecordingHighest = false
    @State var isDone = true
    @State var lowKey = ""
    @State var highKey = ""
    @State var voiceType = ""
    
    var body: some View {
        VStack {
            if(isDone){
                
                Text("Vocal Range")
                    .font(.system(size: 32))
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding()
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.lighttgrey)
                        .frame(width: 340.0, height: 250.0)
                    Text("Click and Start Singing")
                        .font(.system(size: 27))
                        .fontWeight(.semibold)
                        .padding(.bottom, 200.0)
                    Text("Hold The Note for 2s")
                        .font(.system(size: 20))
                        .padding(.bottom, 140.0)
                    
                    HStack {
                        //                        ZStack {
                        //                            RoundedRectangle(cornerRadius: 10)
                        //                                .fill(Color.button)
                        //                                .frame(width: 106.0, height: 120.0)
                        //                            VStack {
                        //                                if(lowKey.isEmpty){
                        //                                    Image(systemName: "waveform")
                        //                                        .resizable()
                        //                                        .foregroundColor(Color.white)
                        //                                        .frame(width: 50.0, height: 60.0)
                        //                                }else{
                        //                                    Text("\(lowKey)")
                        //                                        .font(.system(size: 36))
                        //                                        .fontWeight(.bold)
                        //                                }
                        //                                Text("Low")
                        //                                    .font(.system(size: 24))
                        //                                    .fontWeight(.bold)
                        //                            }
                        //                            .foregroundStyle(.white)
                        //                        }
                        //
                        //                        ZStack {
                        //                            RoundedRectangle(cornerRadius: 10)
                        //                                .fill(Color.button)
                        //                                .frame(width: 106.0, height: 120.0)
                        //                            VStack {
                        //                                if(highKey.isEmpty){
                        //                                    Image(systemName: "waveform")
                        //                                        .resizable()
                        //                                        .foregroundColor(Color.white)
                        //                                        .frame(width: 50.0, height: 60.0)
                        //                                }else{
                        //                                    Text("\(highKey)")
                        //                                        .font(.system(size: 36))
                        //                                        .fontWeight(.bold)
                        //
                        //                                }
                        //                                Text("High")
                        //                                    .font(.system(size: 24))
                        //                                    .fontWeight(.bold)
                        //                            }
                        //                            .foregroundStyle(.white)
                        //                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.button)
                                .frame(width: 106.0, height: 120.0)
                            Button(action: {
                                if lowKey.isEmpty {
                                    audioManager.startRecording(for: .lowest, with: self)
                                    print("recording")
                                    
                                } else {
//                                    audioManager.stopRecording()
                                    //                                    lowKey = ""
                                    lowKey = ""
                                    audioManager.startRecording(for: .lowest, with: self)

                                    
                                }
                            }) {
                                VStack{
                                    Text(lowKey.isEmpty ? "-" : lowKey)
                                        .font(.system(size: 36))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Text((isRecordingLowest||isRecordingHighest) ? "Recording" : "Low")
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                            }
                            .symbolEffect(.bounce, value: isRecordingLowest||isRecordingHighest)
                            
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.button)
                                .frame(width: 106.0, height: 120.0)
                            Button(action: {
                                if highKey.isEmpty {
                                    audioManager.startRecording(for: .highest, with: self)
                                    print("recording")
                                    
                                } else {
//                                    audioManager.stopRecording()
                                    highKey = ""
                                    audioManager.startRecording(for: .highest, with: self)

                                    //                                    highKey = ""
                                    print("stop recording")
                                    
                                }
                            }) {
                                VStack{
                                    Text(highKey.isEmpty ? "-" : highKey)
                                        .font(.system(size: 36))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Text((isRecordingLowest||isRecordingHighest) ? "Recording" : "High")
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                }
                            }
                            .symbolEffect(.bounce, value: isRecordingLowest||isRecordingHighest)
                        }
                    }
                    .padding(.top, 30)
                    
                    
                }
                List{
                    VStack(alignment: .leading){
                        Text("What is your voice type?")
                            .font(.headline)
                            .padding(.vertical, 4)
                        Text((!lowKey.isEmpty && !highKey.isEmpty && (!(isRecordingLowest || isRecordingHighest))) ? "You are a \(voiceType)" : "Find your vocal range and find out")
                            .font(.callout)
                            .fontWeight(.medium)
                            .padding(.vertical, 12)
                    }
                    .foregroundStyle(.white)
                    .listRowBackground(Color(.blue))
                }
                .scrollContentBackground(.hidden)
                
                
            }else{
                Text("TO BE IMPLEMENTED SOON")
                    .font(.title)
                    .fontWeight(.black)
            }
        }
        .onAppear(){
            audioManager.startAudioProcessing()
            print("processing")
            
        }
        .onDisappear(){
            audioManager.stopAudioProcessing()
            print("stop process")
            
        }
        .onChange(of: isRecordingLowest) {
            if (!(lowKey.isEmpty || highKey.isEmpty) && (!(isRecordingLowest || isRecordingHighest))){
                print("CHANGE")
                audioManager.updateVoiceType(with: self)
            }
        }
        .onChange(of: isRecordingHighest) {
            if (!(lowKey.isEmpty || highKey.isEmpty) && (!(isRecordingLowest || isRecordingHighest))){
                print("CHANGE")
                audioManager.updateVoiceType(with: self)
            }
        }
    }
    
    
    
    class AudioManager: ObservableObject {
        private var audioEngine: AVAudioEngine!
        private var inputNode: AVAudioInputNode!
        private var bufferSize: AVAudioFrameCount = 1024
        private var sampleRate: Double = 44100.0
        private var timer: Timer?
        private var recordingType: RecordingType? // Enum for recording type
        
        
        enum RecordingType {
            case lowest
            case highest
        }
        
        @Published var frequency: Double = 0.0
        @Published var note: String? = nil // Change to optional
        
        func startAudioProcessing() {
            audioEngine = AVAudioEngine()
            inputNode = audioEngine.inputNode
            sampleRate = inputNode.inputFormat(forBus: 0).sampleRate
            
            let recordingFormat = inputNode.inputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: bufferSize, format: recordingFormat) { buffer, time in
                self.processAudioBuffer(buffer: buffer)
            }
            
            do {
                try audioEngine.start()
            } catch {
                print("Error starting audio engine: \(error.localizedDescription)")
            }
        }
        
        
        func stopAudioProcessing() {
            audioEngine.stop()
            inputNode.removeTap(onBus: 0)
            timer?.invalidate() // Invalidate timer on stop
        }
        
        private func processAudioBuffer(buffer: AVAudioPCMBuffer) {
            guard let channelData = buffer.floatChannelData?[0] else { return }
            let channelDataArray = Array(UnsafeBufferPointer(start: channelData, count: Int(buffer.frameLength)))
            
            var fftMagnitudes = [Float](repeating: 0.0, count: channelDataArray.count / 2)
            let log2n = UInt(round(log2(Double(channelDataArray.count))))
            let fftSetup = vDSP_create_fftsetup(log2n, Int32(kFFTRadix2))
            
            var realp = [Float](repeating: 0.0, count: channelDataArray.count / 2)
            var imagp = [Float](repeating: 0.0, count: channelDataArray.count / 2)
            var output = DSPSplitComplex(realp: &realp, imagp: &imagp)
            
            channelDataArray.withUnsafeBufferPointer { pointer in
                pointer.baseAddress!.withMemoryRebound(to: DSPComplex.self, capacity: channelDataArray.count) { typeConvertedTransferBuffer in
                    vDSP_ctoz(typeConvertedTransferBuffer, 2, &output, 1, vDSP_Length(channelDataArray.count / 2))
                }
            }
            
            vDSP_fft_zrip(fftSetup!, &output, 1, log2n, Int32(FFT_FORWARD))
            vDSP_zvmags(&output, 1, &fftMagnitudes, 1, vDSP_Length(channelDataArray.count / 2))
            
            var normalizedMagnitudes = [Float](repeating: 0.0, count: fftMagnitudes.count)
            var squaredMagnitudes = [Float](repeating: 0.0, count: fftMagnitudes.count)
            vDSP_vsq(fftMagnitudes, 1, &squaredMagnitudes, 1, vDSP_Length(fftMagnitudes.count))
            
            let scalingFactor = 2.0 / Double(channelDataArray.count)
            var floatScalingFactor = Float(scalingFactor)
            vDSP_vsmul(squaredMagnitudes, 1, &floatScalingFactor, &normalizedMagnitudes, 1, vDSP_Length(fftMagnitudes.count))
            
            if let maxMagnitude = normalizedMagnitudes.max(), let maxIndex = normalizedMagnitudes.firstIndex(of: maxMagnitude) {
                let frequency = Double(maxIndex) * sampleRate / Double(channelDataArray.count)
                DispatchQueue.main.async {
                    self.frequency = frequency
                    self.note = self.frequencyToNoteName(frequency: frequency)
                }
            } else {
                DispatchQueue.main.async {
                    self.note = nil // Set note to nil if no valid frequency is detected
                }
            }
            
            vDSP_destroy_fftsetup(fftSetup)
        }
        
        func startRecording(for type: RecordingType, with view: VocalRangeHome) {
            recordingType = type
            timer?.invalidate() // Invalidate previous timer if any
            
            var lastNote: String?
            var noteStayedForSeconds: Double = 0.0
            
            switch type {
            case .lowest:
                view.isRecordingLowest = true
            case .highest:
                view.isRecordingHighest = true
            }
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                if let currentNote = self.note {
                    if currentNote == lastNote {
                        noteStayedForSeconds += 0.1
                        switch type {
                        case .lowest:
                            view.lowKey = currentNote
                        case .highest:
                            view.highKey = currentNote
                        }
                        if noteStayedForSeconds >= 2.0 {
                            self.timer?.invalidate()
                            switch type {
                            case .lowest:
                                view.lowKey = currentNote
                                view.isRecordingLowest = false
                            case .highest:
                                view.highKey = currentNote
                                view.isRecordingHighest = false
                            }
                            self.recordingType = nil
                            self.stopRecording()
                        }
                    } else {
                        lastNote = currentNote
                        noteStayedForSeconds = 0.0
                    }
                } else {
                    noteStayedForSeconds = 0.0
                }
            }
        }
        
        
        func stopRecording() {
            timer?.invalidate() // Invalidate timer on stop recording
        }
        
        private func frequencyToNoteName(frequency: Double) -> String? {
            if frequency == 0.0 {
                return nil // Return nil if frequency is 0.0
            }
            
            let a4Frequency = 440.0
            let notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
            let noteIndex = 12 * log2(frequency / a4Frequency)
            let roundedNoteIndex = Int(round(noteIndex))
            var octave = (roundedNoteIndex + 9) / 12 + 4
            let noteNameIndex = (roundedNoteIndex % 12 + 12) % 12
            let noteName = notes[noteNameIndex]
            if frequency < 219 && frequency > 135 {
                octave = octave - 1
            }
            return "\(noteName)\(octave)"
        }
        
        func updateVoiceType(with view: VocalRangeHome) {
            print("VOICE APDET")
            
            let lowNote = view.lowKey.dropLast()
            let highNote = view.highKey.dropLast()
            let lowOctave = Int(view.lowKey.last!.description) ?? 0
            let highOctave = Int(view.highKey.last!.description) ?? 0
            
            let range = (lowOctave * 12 + noteToIndex(note: String(lowNote))) ... (highOctave * 12 + noteToIndex(note: String(highNote)))
            
            print(range)
            
            if range.contains(48...59) {
                view.voiceType = "Bass"
            } else if range.contains(60...71) {
                view.voiceType = "Baritone"
            } else if range.contains(72...83) {
                view.voiceType = "Tenor"
            } else if range.contains(84...95) {
                view.voiceType = "Alto"
            } else if range.contains(96...107) {
                view.voiceType = "Mezzo-soprano"
            } else if range.contains(108...119) {
                view.voiceType = "Soprano"
            } else {
                view.voiceType = "Unknown"
            }
        }
        func noteToIndex(note: String) -> Int {
            let notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
            return notes.firstIndex(of: note) ?? 0
        }
        
        
    }
    
}

#Preview{
    TabItem(selection: 0)
}
