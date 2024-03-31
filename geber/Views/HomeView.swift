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
            Spacer().frame(height: 30)
            Button(action: {
                Task {
                    await vm.expireKey()
                }
            }) {
                Text("Expire the val")
            }
        }
        .task {
            await vm.connect()
        }

        .padding()
    }
}

#Preview {
    HomeView()
}
