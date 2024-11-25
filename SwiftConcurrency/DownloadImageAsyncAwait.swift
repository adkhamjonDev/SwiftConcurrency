//
//  DownloadImageAsyncAwait.swift
//  SwiftConcurrency
//
//  Created by Adkhamjon Rakhimov on 25/11/24.
//

import SwiftUI
import Combine

class DownloadImageAsyncLoader {
    let url = URL(string: "https://picsum.photos/200")!
    
    func handleResponse(data:Data?,response:URLResponse?) -> UIImage? {
        guard
            let data = data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            return nil
        }
        return image
    }
    
    func downloadWithEscaping(completionHandler: @escaping (_ image:UIImage?,_ error:Error?)-> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] data,response,error in
            let image = self?.handleResponse(data: data, response: response)
            
            completionHandler(image,error)
        }
        .resume()
    }
    
    func downloadWithCombine() -> AnyPublisher<UIImage?, Error>{
        URLSession.shared.dataTaskPublisher(for: url)
            .map(handleResponse)
            .mapError( {$0})
            .eraseToAnyPublisher()
    }
    
    func downloadAsnyc() async throws -> UIImage?{
        do {
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
            return handleResponse(data: data, response: response)
             
        } catch {
            throw error
        }
        
    }
    
}

class DownloadImageAsyncViewModel:ObservableObject {
    @Published var image:UIImage?=nil
    let loader = DownloadImageAsyncLoader()
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchimage() async {
//        loader.downloadWithEscaping { [weak self] image, error in
//            DispatchQueue.main.async{
//                self?.image = image
//            }
//            
//        }
         
//        loader.downloadWithCombine()
//            .receive(on: DispatchQueue.main)
//            .sink{ _ in
//                
//            } receiveValue: { [weak self] image in
//                self?.image = image
//            }
//            .store(in: &cancellables)
        
        let image = try? await loader.downloadAsnyc()
        await MainActor.run {
            self.image = image
        }
    }
}

struct DownloadImageAsyncAwait: View {
    
    @StateObject private var viewModel = DownloadImageAsyncViewModel()
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable().scaledToFit()
                    .frame(width: 250,height: 250)
            }
        }
        .onAppear{
            Task {
                await viewModel.fetchimage()
            }
        }
    }
}

#Preview {
    DownloadImageAsyncAwait()
}
