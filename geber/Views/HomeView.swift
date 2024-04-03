//
//  ContentView.swift
//  geber
//
//  Created by bernanda on 30/03/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var homeViewModel = HomeViewModel()
    @StateObject var beaconManager = IBeaconManager()
    
    
    let location = [
        0: "Detected in S1",
        1: "Detected in S2",
        2: "Detected in S3"
    ]
    
    let colors = [
        -1: Color.black,
         0: Color.red,
        1: Color.green,
        2: Color.blue
    ]
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text(location[Int(truncating: beaconManager.minor)] ?? "You're not detected in the parking area")
            if beaconManager.distance == .unknown {
                Text("UNKNOWN")
            } else if beaconManager.distance == .near {
                Text("NEAR")
            } else if beaconManager.distance == .immediate {
                Text("HEREEE!")
            } else {
                Text("FAR")
            }
            Spacer().frame(height: 30)
            
            Text(homeViewModel.message)
            Spacer().frame(height: 12)
            
            if homeViewModel.current_key_event.isEmpty {
                Button(action: {
                    Task {
                        homeViewModel.getHelp(minor: beaconManager.minor)
                    }
                }) {
                    Text("Get Help")
                }.buttonStyle(.bordered).disabled(beaconManager.minor == -1)
            } else {
                Button(action: {
                    Task {
                        homeViewModel.expireHelp(key: homeViewModel.current_key_event)
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
        .background(colors[Int(truncating: beaconManager.minor)])
        
    }
}

#Preview {
    HomeView()
}
