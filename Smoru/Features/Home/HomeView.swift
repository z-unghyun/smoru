import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 20) {
            SleepFragmentView()
            PlaceholderScreen(
                title: "Home",
                subtitle: "Today's sleep fragment and routine summary placeholder."
            )
        }
    }
}
