//
//  Home.swift
//  Crypto App
//
//  Created by Phat Vuong Vinh on 19/10/24.
//

import SwiftUI

struct Home: View {
    @State var currentCoin = "BTC"
    @Namespace var animation
    
    @StateObject var appModel: AppViewModel = AppViewModel()

    var body: some View {
        VStack {
            if let coins = appModel.coins, let coin = appModel.selectedCoin {
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
                CustomControl(coins: coins)
                GraphView(coin: coin)
                
                Controls()
            } else {
                ProgressView()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // Custom segmented Control
    
    @ViewBuilder
    func CustomControl(coins: [CryptoModel]) -> some View {
        
        // sample data
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                
                ForEach(coins) { coin in
                   let coinString = coin.symbol.uppercased()
                    Text(coinString)
                        .foregroundStyle(currentCoin == coinString ? .white : .gray)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background {
                            if currentCoin == coinString {
                                Rectangle()
                                    .fill(.gray.opacity(0.5))
                                    .matchedGeometryEffect(id: "SEGMENTEDCONTROLTAB", in: animation)
                            }
                        }
                        .onTapGesture {
                            appModel.selectedCoin = coin
                            withAnimation {
                                currentCoin = coinString

                            }
                        }
                }
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .stroke(.white.opacity(0.2), lineWidth:1)
        }
        .padding(.vertical)
        
    }
    
    
    @ViewBuilder
    func Controls() -> some View {
        
        HStack(spacing: 20) {
            Button {
                
            } label: {
                Text("Sell")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.white)
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
    Home()
        .preferredColorScheme(.dark)
}
