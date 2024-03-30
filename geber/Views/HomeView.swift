//
//  ContentView.swift
//  geber
//
//  Created by bernanda on 30/03/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm = HomeViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(vm.events)
            Button(action: vm.getValue) {
                Text("Get Value")
            }
        }
        .task {
            vm.setVal(input: "WKWWKWK")
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
