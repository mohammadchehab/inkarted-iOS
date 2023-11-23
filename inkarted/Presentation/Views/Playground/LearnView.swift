//
//  LearnView.swift
//  inkarted
//
//  Created by Mohammad_Shehab on 22/11/2023.
//

import SwiftUI
import Combine


struct Song : Hashable, Codable, Identifiable {
    var id: UUID
    var title : String
    var year : Int
    var rating : Int
    
    init(title: String, year: Int, rating: Int) {
        self.id = UUID()
        self.title = title
        self.year = year
        self.rating = rating
    }
    
    static func example () -> [ Song ] {
        return [
            Song(title: "Song 1", year: 2020, rating: 5),
            Song(title: "Song 2", year: 2021, rating: 1),
            Song(title: "Song 3", year: 2022, rating: 2),
            Song(title: "Song 4", year: 2023, rating: 3)
        ]
    }
}


struct Book : Hashable, Codable, Identifiable {
    var id: UUID
    var title : String
    var author : String
    var year : Int
    var rating : Int
    
    init (title: String) {
        self.id = UUID()
        self.title = title
        self.author = ""
        self.year = 1000
        self.rating = 0
    }
    
    init(title: String, author: String,  year: Int, rating: Int) {
        self.id = UUID()
        self.title = title
        self.year = year
        self.rating = rating
        self.author = author
    }
    
    static func example () -> [ Book ] {
        return [
            Book(title: "Book 1", author: "Some Author", year: 2020, rating: 5),
            Book(title: "Book 2", author: "Some Author", year: 2018, rating: 1),
            Book(title: "Book 4", author: "Some Author", year: 1990, rating: 4),
            Book(title: "Book 5", author: "Some Author", year: 1887, rating: 2)
        ]
    }
}


struct Movie : Hashable, Codable, Identifiable {
    var id: UUID
    var title : String
    var producer : String
    var year : Int
    var rating : Int
    
    init(title: String, producer: String,  year: Int, rating: Int) {
        self.id = UUID()
        self.title = title
        self.producer = producer
        self.year = year
        self.rating = rating
    }
    
    static func example () -> [ Movie ] {
        return [
            Movie(title: "Movie 1", producer: "Some Producer", year: 2020, rating: 5),
            Movie(title: "Movie 2", producer: "Some Producer", year: 2018, rating: 1),
            Movie(title: "Movie 4", producer: "Some Producer", year: 1990, rating: 4),
            Movie(title: "Movie 5", producer: "Some Producer", year: 1887, rating: 2)
        ]
    }
}


class ModelDataManager : ObservableObject {
    @Published var books = Book.example()
    @Published var songs = Song.example()
    @Published var movies = Movie.example()
}

struct NavigationStackLearning : View {
    
    var body : some View {
        
        TabView {
            FirstTabView()
                .tabItem {
                    Label("First", systemImage : "plus")
                }
            
            SecondTabView()
                .tabItem {
                    Label ( "Second", systemImage: "music.note.house.fill")
                }
            
            ThirdTabView()
                .tabItem{
                    Label("Third", systemImage: "pencil.and.outline")
                }
        }
    }
}



struct RootView : View {
    
    @ObservedObject var modelDataManager = ModelDataManager()
    
    var body : some View {
        NavigationView {
            List {
                Section ("Songs") {
                    ForEach(modelDataManager.songs) { song in
                        NavigationLink(song.title, value:  ScreenSelection.song(song))
                    }
                }
                
                Section ("Books") {
                    ForEach(modelDataManager.books) { book in
                        NavigationLink(book.title, value: ScreenSelection.book(book))
                    }
                }
                
                Section ("Movies") {
                    ForEach(modelDataManager.movies) { movie in
                        NavigationLink(movie.title, value: ScreenSelection.movie(movie))
                    }
                }
            }
            .navigationTitle("Home Page")
            .navigationTitle("Navigation Title")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("Settings", value: ScreenSelection.settings)
                }
            }
        }
    }
}

enum ScreenSelection : Hashable, Codable{
    case movie (Movie)
    case song (Song)
    case book (Book)
    case settings
}

class NavigationStateManager : ObservableObject {
    @Published var selectionPath = [ScreenSelection]()
    
    var data : Data? {
        get {
            try? JSONEncoder().encode(selectionPath)
        }
        set {
            guard let data = newValue,
                  let path = try? JSONDecoder().decode([ScreenSelection].self, from: data) else {
                
                return
            }
            self.selectionPath = path
        }
    }
    
    func popToRoot () {
        self.selectionPath = []
    }
    
    func goToSettings () {
        selectionPath = [ScreenSelection.settings]
    }
    
    var objectWillChangeSequence: AsyncPublisher<Publishers.Buffer<ObservableObjectPublisher>> {
        objectWillChange
            .buffer(size: 1, prefetch:  .byRequest, whenFull: .dropOldest)
            .values
    }
}

struct FirstTabView : View {
    var body : some View {
        NavigationStack {
            
        }
    }
}

struct SettingsView : View {
    
    
    var body : some View {
        VStack {
            Text("Settings Page")
        }
        .navigationTitle("Settings")
    }
}


struct SecondTabView : View {
    
    var body : some View {
        VStack {
            Text("Second Tab View")
        }
    }
}

struct ThirdTabView : View {
    
    @StateObject var modelDataManager = ModelDataManager()
    @StateObject var navigationStateManager = NavigationStateManager()
    @SceneStorage("navigationStateData") var navigationStateData : Data?
    
    var body : some View {
        NavigationStack (path: $navigationStateManager.selectionPath){
            RootView(modelDataManager: modelDataManager)
                .navigationDestination(for: ScreenSelection.self){ state in
                    switch state {
                    case .song (let song):
                        SongDetailView(song: song)
                    case .book (let book):
                        BookDestinationView(book: book)
                    case .movie (let movie):
                        MovieDetailView(movie: movie)
                        Text("Movie")
                    case .settings:
                        SettingsView()
                    }
                }
        }
        .environmentObject(modelDataManager)
        .environmentObject(navigationStateManager)
        .task {
            navigationStateManager.data = navigationStateData
            
            for await _ in navigationStateManager.objectWillChangeSequence {
                navigationStateData = navigationStateManager.data
            }
        }
    }
}

struct SongDetailView : View {
    let song : Song
    
    var body : some View {
        
        VStack {
            Text("Rating \(song.rating)")
            Text("Year \(song.year)")
        }
        .navigationTitle(song.title)
    }
}

struct MovieDetailView : View {
    let movie : Movie
    
    var body : some View {
        
        VStack {
            Text("Rating \(movie.rating)")
            Text("Year \(movie.year)")
        }
        .navigationTitle(movie.title)
    }
}


struct BookDestinationView: View {
    
    let book: Book
    
    @EnvironmentObject var modelData : ModelDataManager
    @EnvironmentObject var navigationStackManager : NavigationStateManager
    
    var body: some View {
        VStack {
            Text("Book detail view")
            
            Text("Rating \(book.rating)")
            Text("Year \(book.year)")
            
            Divider()
            
            ForEach(modelData.books) { book in
                NavigationLink(value: ScreenSelection.book(book)) {
                    Label(book.title, systemImage: "figure.stand")
                }
            }
            
            Button("Go Back To The Top") {
                navigationStackManager.popToRoot()
            }
            
        }
        .navigationTitle(book.title)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    navigationStackManager.goToSettings()
                } label: {
                    Image(systemName:   "gear")
                }
            }
        }
    }
}

struct NavigationStack_Preview : PreviewProvider {
    
    static var previews: some View {
        NavigationStackLearning()
    }
}
