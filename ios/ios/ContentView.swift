import SwiftUI
import Shared

struct ContentView: View {
    
//    @StateObject
//    private var viewModel = SampleViewModel()
    
    var body: some View {
        VStack(spacing: 32) {
            VStack {
                Text("UUID:")
                    .font(.headline)
                Text("1234-5678-901234")
                    .font(.body)

                Button("Refresh") {
                }.padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
