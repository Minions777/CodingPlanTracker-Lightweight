import SwiftUI
import CodingPlanSDK

@main
struct CodingPlanTracker_WatchOSApp: App {
    var body: some Scene {
        WindowGroup {
            WatchPlanListView()
        }
    }
}