//
//  Home.swift
//  Crypto App
//
//  Created by Phat Vuong Vinh on 19/10/24.
//

import SwiftUI

struct Home: View {
    
    @StateObject var appModel: AppViewModel = AppViewModel()

    var body: some View {
        NavigationStack {
            
            if let coins = appModel.coins {
                ScrollView {
                    ForEach(coins) { coin in
                        
                        NavigationLink(destination: DetailView(coin: coin)) {
                            VStack {
                                CardView(coin: coin)
                                Divider()
                            }
                        }
                        .buttonStyle(.plain)
                        .padding()

                    }
                }
                .navigationTitle("List of Coins")

            }
            
        }
    }
    
    
    @ViewBuilder
    
    func CardView(coin: CryptoModel) -> some View {
        HStack {
            VStack (alignment: .leading, spacing: 6) {
                Text(coin.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(coin.symbol.uppercased())
                    .font(.caption)
                    .foregroundStyle(.gray)
            }.frame(width: 80, alignment: .leading)
            
            LineGraph(data: coin.last7DaysPrice.price ,profit: coin.priceChange > 0, showModelOnly: true)

            VStack (alignment: .trailing, spacing: 6) {
                Text(coin.currentPrice.convertDoubleToCurrency())
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("\(coin.priceChange > 0 ? "+" : "")\(String(format: "%.2f", coin.priceChange))")
                    .font(.caption)
                    .foregroundStyle(coin.priceChange > 0 ? .green : .red)
            }
        }
    }
   
}

#Preview {
    Home()
        .preferredColorScheme(.dark)
}
