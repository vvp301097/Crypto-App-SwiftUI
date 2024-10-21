//
//  DetailView.swift
//  Crypto App
//
//  Created by Phat Vuong Vinh on 21/10/24.
//

import SwiftUI

struct DetailView: View {
    
    var coin: CryptoModel
    var body: some View {
        VStack {
                HStack(spacing: 15) {
                    AsyncImage(url: URL(string: coin.image), content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                    }) {
                        ProgressView()
                    }
                        
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(coin.name)
                            .font(.callout)
                        Text(coin.symbol.uppercased())
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(coin.currentPrice.convertDoubleToCurrency())
                        .font(.largeTitle.bold())
                    
                    Text("\(coin.priceChange > 0 ? "+" : "")\(String(format: "%.2f", coin.priceChange))")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(coin.priceChange < 0 ? .white : .black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background {
                            Capsule()
                                .fill(coin.priceChange < 0 ? Color.red : Color.green)
                        }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                GraphView(coin: coin)
                
                Controls()
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
        
    
    
    @ViewBuilder
    func Controls() -> some View {
        
        HStack(spacing: 20) {
            Button {
                
            } label: {
                Text("Sell")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.red)
                    )
            }
            
            Button {
                
            } label: {
                Text("Buy")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.green)
                    )
            }
        }
    }
    
    @ViewBuilder
    func GraphView(coin: CryptoModel) -> some View {
        GeometryReader { geometry in
            LineGraph(data: coin.last7DaysPrice.price, profit: coin.priceChange > 0)
        }
        .padding(.vertical, 30)
        .padding(.bottom,20)
    }
}

#Preview {
    ContentView()
}
