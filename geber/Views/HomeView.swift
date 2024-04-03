//
//  ContentView.swift
//  geber
//
//  Created by bernanda on 30/03/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm = HomeViewModel()
    @StateObject var b = IBeaconManager()
    
    let colors = [
        -1: Color.white,
        0: Color.blue,
        1: Color.red,
        2: Color.green
    ]
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(vm.message)
            if b.distance == .unknown {
                Text("UNKNOWN")
            } else if b.distance == .near {
                Text("NEAR")
            } else if b.distance == .immediate {
                Text("HEREEE!")
            } else {
                Text("FAR")
            }
            Spacer().frame(height: 30)
            if vm.current_key_event.isEmpty {
                Button(action: {
                    Task {
                        vm.getHelp()
                    }
                }) {
                    Text("Get Help")
                }
            } else {
                Button(action: {
                    Task {
                        vm.expireHelp(key: vm.current_key_event)
                    }
                }) {
                    Text("Done")
                }
            }
        }
        .task {
            //            await vm.connect()
        }
        
        .padding()
        .background(colors[Int(truncating: b.minor)])
        
    }
}

#Preview {
    HomeView()
}
