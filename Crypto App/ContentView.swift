//
//  ContentView.swift
//  Crypto App
//
//  Created by Phat Vuong Vinh on 18/10/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                
                ForEach(0..<10) { index in
                    HStack {
//                        AsyncImage(
//                            url: URL(string: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400"),
//                            content: { image in
//                                image.resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(maxWidth: 30, maxHeight: 30)
//                            },
//                            placeholder: {
//                                ProgressView()
//                            }
//                        )
                        Text("Bitcoin")
                        Spacer()
                        Text("$12,345.67")
                    }
                }
               
                
            }
            .navigationTitle("Today's Prices ")
        }
    }
}

#Preview {
    ContentView()
}
