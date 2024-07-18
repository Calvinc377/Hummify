import Foundation
import SwiftUI
import MusicKit

struct SongList: View {
    @Binding var classificationResults: [ClassifiedResult]
    @State var searchTerm: String = ""
    @State var searchResults: [Song] = []
    @State var showSearchResults: Bool = false // Control navigation to SongSearchView
    @State var isLoading: Bool = false // Control loading state
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                if isLoading {
                    VStack(){
                        HStack(alignment: .center){
                            ProgressView("Searching...")
                        }
                    }
                } else {
                    HStack(alignment: .top){
                        List {
                            ForEach(classificationResults) { result in
                                HStack{
                                    VStack(alignment: .leading) {
                                        Text(result.identifier)
                                            .multilineTextAlignment(.leading)
                                        Text("Accuracy: " + result.confidence)
                                            .multilineTextAlignment(.leading)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .frame(width: 20, height: 30)
                                }
                                .onTapGesture {
                                    Task {
                                        isLoading = true
                                        searchTerm = result.identifier
                                        await searchForSongs(searchTerm: searchTerm)
                                        isLoading = false
                                        showSearchResults = true // Set to true after searching
                                    }
                                }
                            }
                        }
                        .sheet(isPresented: $showSearchResults) {
                            SongSearchView(searchTerm: $searchTerm, searchResults: $searchResults)
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden((true && isLoading))
    }
    
    func searchForSongs(searchTerm: String) async {
        do {
            let searchRequest = MusicCatalogSearchRequest(term: searchTerm, types: [Song.self])
            let searchResponse = try await searchRequest.response()
            DispatchQueue.main.async {
                self.searchResults = Array(searchResponse.songs)
            }
        } catch {
            print("Error searching for songs: \(error)")
        }
    }
}


struct SongSearchView: View {
    @Binding var searchTerm: String
    @Binding var searchResults: [Song]
    
    var body: some View {
        NavigationStack{
            List {
                Text("Search Results of \(searchTerm)")
                    .font(.title2)
                    .listRowBackground(Color(white: 1, opacity: 0))
                    .padding()
                ForEach(searchResults) { song in
                    NavigationLink(destination: SongDetailsView(song: song)) {
                        HStack{
                            ArtworkImage(song.artwork!, width: 100)
                            VStack(alignment: .leading){
                                Text(song.title)
                                    .multilineTextAlignment(.leading)
                                Text(song.artistName)
                                    .font(.caption2)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                    }
                    .padding()
                }
            }
            
        }
    }
}

struct SongDetailsView: View {
    @State var musicSubscription: MusicSubscription?
    @State var isShowingOffer = false
    let song: Song
    
    /// The MusicKit player to use for Apple Music playback.
    private let player = ApplicationMusicPlayer.shared
    
    /// The state of the MusicKit player to use for Apple Music playback.
    @ObservedObject private var playerState = ApplicationMusicPlayer.shared.state
    
    /// `true` when the album detail view sets a playback queue on the player.
    @State private var isPlaybackQueueSet = false
    
    /// `true` when the player is playing.
    private var isPlaying: Bool {
        return (playerState.playbackStatus == .playing)
    }
    /// The localized label of the Play/Pause button when in the play state.
    private let playButtonTitle: LocalizedStringKey = "Play"
    
    /// The localized label of the Play/Pause button when in the paused state.
    private let pauseButtonTitle: LocalizedStringKey = "Pause"
    
    /// `true` when the album detail view needs to disable the Play/Pause button.
    private var isPlayButtonDisabled: Bool {
        let canPlayCatalogContent = musicSubscription?.canPlayCatalogContent ?? false
        return !canPlayCatalogContent
    }
    
    var offerOptions: MusicSubscriptionOffer.Options {
        var offerOptions = MusicSubscriptionOffer.Options()
        offerOptions.itemID = song.id
        return offerOptions
    }
    
    private var shouldOfferSubscription: Bool {
        let canBecomeSubscriber = musicSubscription?.canBecomeSubscriber ?? false
        return canBecomeSubscriber
    }
    
    private var subscriptionOfferButton: some View {
        Button(action: handleSubscriptionOfferButtonSelected) {
            HStack {
                Image(systemName: "applelogo")
                Text("Join")
            }
            .frame(maxWidth: 200)
        }
        .buttonStyle(.prominent)
    }
    
    /// The state that controls whether the album detail view displays a subscription offer for Apple Music.
    @State private var isShowingSubscriptionOffer = false
    
    /// The options for the Apple Music subscription offer.
    @State private var subscriptionOfferOptions: MusicSubscriptionOffer.Options = .default

    
    private func handleSubscriptionOfferButtonSelected() {
        subscriptionOfferOptions.messageIdentifier = .playMusic
        subscriptionOfferOptions.itemID = song.id
        isShowingSubscriptionOffer = true
    }
    
    var body: some View {
        VStack {
            ArtworkImage(song.artwork!, width: 200)
            Text(song.title).font(.largeTitle)
                .multilineTextAlignment(.center)
            Text(song.artistName).font(.title2).foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            HStack {
                Button(action: handlePlayButtonSelected) {
                    HStack {
                        Image(systemName: (isPlaying ? "pause.fill" : "play.fill"))
                        Text((isPlaying ? pauseButtonTitle : playButtonTitle))
                    }
                    .frame(maxWidth: 200)
                }
                .buttonStyle(.prominent)
//                .disabled(isPlayButtonDisabled)
                .animation(.easeInOut(duration: 0.1), value: isPlaying)
                
                if shouldOfferSubscription {
                    subscriptionOfferButton
                }
            }
            
        }
        .padding()
        .navigationTitle("Song Details")
        
    }
    
    func showSubscriptionOffer() {
        isShowingOffer = true
    }
    
    func handlePlayButtonSelected() {
        if !isPlaying {
            if !isPlaybackQueueSet {
                player.queue = [song]
                isPlaybackQueueSet = true
                beginPlaying()
            } else {
                Task {
                    do {
                        try await player.play()
                    } catch {
                        print("Failed to resume playing with error: \(error).")
                    }
                }
            }
        } else {
            player.pause()
        }
    }
    
    func beginPlaying() {
        Task {
            do {
                try await player.play()
            } catch {
                print("Failed to prepare to play with error: \(error).")
            }
        }
    }


}
