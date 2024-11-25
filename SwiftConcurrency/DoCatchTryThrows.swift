//
//  DoCatchTryThrows.swift
//  SwiftConcurrency
//
//  Created by Adkhamjon Rakhimov on 25/11/24.
//

import SwiftUI
// do-catch
// try
// thows


class DoCatchTryThrowDataManager {
    let isActive: Bool = true
    func getTitle() -> (title:String?, error: Error?) {
        return if isActive {
            ("NEW TEXT",nil)
        } else {
            (nil,URLError(.badURL))
        }
    }
    
    func getTitle2() -> Result<String,Error> {
        if isActive {
            return .success("NEW TEXT!")
        } else {
            return .failure(URLError(.badURL))
        }
    }
    
    func getTitle3() throws -> String {
        if isActive {
            return "NEW TEXT URAAA"
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
    func getTitle4() throws -> String {
        if isActive {
            return "FINAL TEXT URAAA"
        } else {
            throw URLError(.badServerResponse)
        }
    }
}

class DoCatchTryThrowsCoordinator: ObservableObject {
    @Published var text = "Starting here..."
    let manager = DoCatchTryThrowDataManager()
    
    func fetchTiltle() {
        let returnedValue = manager.getTitle()
        
        if let newTitle = returnedValue.title {
            self.text = newTitle
        } else if let error = returnedValue.error {
            self.text = error.localizedDescription
        }
    }
    
    func fetchTiltle2() {
        let result = manager.getTitle2()
        
        switch result {
        case .success(let newTitle):
            self.text = newTitle
        case .failure(let error):
            self.text = error.localizedDescription
        }
    }
    
    func fetchTiltle3() {
        
        let newTitle = try? manager.getTitle3()

        if let newTitle = newTitle {
            self.text = newTitle
        }
        
        do {
            let newTitle = try manager.getTitle3()
            self.text = newTitle
            
            let finalTitle = try manager.getTitle4()
            self.text = finalTitle
        } catch {
            self.text = error.localizedDescription
        }
        
       
    }
}

struct DoCatchTryThrows: View {
    
    @StateObject private var viewModel = DoCatchTryThrowsCoordinator()
    
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300,height: 300)
            .background(.blue)
            .onTapGesture {
                viewModel.fetchTiltle3()
            }
    }
}

#Preview {
    DoCatchTryThrows()
}
