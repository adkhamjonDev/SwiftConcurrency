//
//  AsyncAwait.swift
//  SwiftConcurrency
//
//  Created by Adkhamjon Rakhimov on 25/11/24.
//

import SwiftUI

class AsyncAwaitViewModel:ObservableObject {
    
    @Published var dataArray:[String] = []
    
    func addTitle1() {
        DispatchQueue.main.asyncAfter(deadline: .now()+2){
            self.dataArray.append("Title1 : \(Thread.current)")

        }
    }
    
    func addTitle2() {
        DispatchQueue.global().asyncAfter(deadline: .now()+2){
            let title2 = "Title 2 : \(Thread.current)"
            DispatchQueue.main.async {
                self.dataArray.append(title2)
                
                let title3 = "Title 3 : \(Thread.current)"
                
                self.dataArray.append(title3)
            }
        }
    }
    
    func addAuthor1()  async {
        let author1 = "Author1 : \(Thread.current)"
        self.dataArray.append(author1)
        
        try? await Task.sleep(nanoseconds: 2000000000)
        
        let author2 = "Author1 : \(Thread.current)"
        self.dataArray.append(author2)

    }
}

struct AsyncAwait: View {
    @StateObject private var viewModel = AsyncAwaitViewModel()
    var body: some View {
        List{
            ForEach(viewModel.dataArray,id: \.self) { item in
                    
                Text(item)
            }
        }
        .onAppear{
            Task {
                
                await viewModel.addAuthor1()
            }
            
//            viewModel.addTitle1()
//            viewModel.addTitle2()
        }
        
    }
}

#Preview {
    AsyncAwait()
}
