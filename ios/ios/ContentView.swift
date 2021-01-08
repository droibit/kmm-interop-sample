import SwiftUI
import Shared

struct ContentView: View {
    
    @StateObject
    private var viewModel = SampleViewModel()
    
    var body: some View {
        VStack(spacing: 32) {
            VStack {
                Text("UUID(Oneshot):")
                    .font(.headline)
                Text(viewModel.oneshotUUID)
                    .font(.callout)

                Button("Refresh", action: viewModel.getUUID)
                    .padding(.all, 8)
            }
            
            VStack {
                Text("UUID(Streaming):")
                    .font(.headline)
                Text(viewModel.streamedUUID)
                    .font(.callout)

                Button(
                    viewModel.isWatchingUUID ? "Stop" : "Start",
                    action: viewModel.toggleWatchingUUID
                ).padding(.all, 8)
            }

        }
        .onAppear(perform: viewModel.onAppear)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
