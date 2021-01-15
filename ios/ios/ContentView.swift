import SwiftUI

struct ContentView: View {
    
    @StateObject
    private var viewModel = SampleViewModel()
    
    var body: some View {
        NavigationView {
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
                    ).padding(.all, 4)
                }
                
                Button("Call crashMethod", action: viewModel.printCrashMethod)
                
                NavigationLink("Show Tasks", destination: TaskView())
            }
            .onAppear(perform: viewModel.onAppear)
            .navigationBarTitle("Sample", displayMode: .inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
