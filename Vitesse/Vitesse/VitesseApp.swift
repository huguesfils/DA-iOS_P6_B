import SwiftUI

@main
struct VitesseApp: App {
    @State private var isLogged = false
    
    var body: some Scene {
        WindowGroup {
            ContentView(isLogged: $isLogged)
        }
    }
}
