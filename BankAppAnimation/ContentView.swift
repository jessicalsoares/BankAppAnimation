//
//  ContentView.swift
//  BankAppAnimation
//
//  Created by Jessica Soares on 31/10/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader{
            
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ScrollViewReader { proxy in
                Home(proxy: proxy, size: size, safeArea: safeArea)
            }
            .preferredColorScheme(.light)
            .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}
