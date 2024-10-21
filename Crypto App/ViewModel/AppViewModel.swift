//
//  AppViewModel.swift
//  Crypto App
//
//  Created by Phat Vuong Vinh on 20/10/24.
//

import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    private var timer: Timer? = nil

    @Published var coins: [CryptoModel]?
    
    @Published var selectedCoin: CryptoModel?
    
    init() {
        Task {
            do {
                try await fetchCryptoData()

            } catch {
                
                
                print(error.localizedDescription)
            }

        }
    }
    
    
    func fetchCryptoData() async throws {
        guard let url = url else { return }
        let session = URLSession.shared
        
        let response = try await session.data(from: url)
        
        let jsonData = try JSONDecoder().decode([CryptoModel].self, from: response.0)
        
        
        await MainActor.run {
            self.coins = jsonData
            
            if let firstCoin = self.coins?.first {
                self.selectedCoin = firstCoin
            }
        }
    }
}
