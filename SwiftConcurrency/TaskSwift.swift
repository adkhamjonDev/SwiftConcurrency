//
//  TaskSwift.swift
//  SwiftConcurrency
//
//  Created by Adkhamjon Rakhimov on 10/12/24.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func fetchImage() async {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        do {
            
            guard let url = URL(string: "https://picsum.photos/200") else { return }
            
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
             
            await MainActor.run {
                self.image = UIImage(data: data)
                print("IMAGE FETCHED SUCCESSFULLY")
            }
            
        } catch let error {
            print("Error in fetch image = \(error.localizedDescription)")
        }
    }
    
    func fetchImage2() async {
        do {
            
            guard let url = URL(string: "https://picsum.photos/200") else { return }
            
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
             
            await MainActor.run {
                self.image2 = UIImage(data: data)
            }
            
        } catch let error {
            print("Error in fetch image = \(error.localizedDescription)")
        }
    }
    
}

struct TaskHomeView: View {
    
    var body: some View {
        NavigationStack {
            ZStack {
                NavigationLink("Click ME! 😁"){
                    TaskSwift()
                }
            }
        }
    }
}

struct TaskSwift: View {
    
    @StateObject private var vm = TaskViewModel()
    @State private var fetchImageTask: Task<(), Never>? = nil
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            
            if let image = vm.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            await vm.fetchImage()
        }
        //        .onDisappear{
        //           fetchImageTask?.cancel()
        //       } // in newer version no need to camcel
        //        .onAppear{
        //            fetchImageTask = Task {
        //                await vm.fetchImage()
        //            }
        
        //            Task {
        //                print(Thread.current)
        //                print(Task.currentPriority)
        //                await vm.fetchImage2()
        //            }
        
        //            Task(priority: .userInitiated) {
        //                print("USER_INITIATED :  current = \(Thread.current), currentPriority = \(Task.currentPriority)")
        //            }
        //            Task(priority: .medium) {
        //                print("MEDIUM :          current = \(Thread.current), currentPriority = \(Task.currentPriority)")
        //            }
        //            Task(priority: .low) {
        //                print("LOW :             current = \(Thread.current), currentPriority = \(Task.currentPriority)")
        //            }
        //            Task(priority: .utility) {
        //                print("UTILITY :         current = \(Thread.current), currentPriority = \(Task.currentPriority)")
        //            }
        //            Task(priority: .background) {
        //                print("BACKGROUND :      current = \(Thread.current), currentPriority = \(Task.currentPriority)")
        //            }
        //            Task(priority: .high) {
        //                print("HIGH :            current = \(Thread.current), currentPriority = \(Task.currentPriority)")
        //            }
        
    }
}

#Preview {
    TaskSwift()
}
