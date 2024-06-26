//
//  HomeScreen.swift
//  demoHeadline
//
//  Created by Pavel Semenchenko on 02.06.2024.
//

import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject private var authVM : AuthVM
    @EnvironmentObject private var navigationVM : NavigationRouter
    @EnvironmentObject private var repository: UserRepository
    @State private var selectedButton: Int = 0 // выбор постов
    @State private var showSheet = false // отобрази сайт
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack(path: $navigationVM.currentRoute) {
            ScrollView {
                VStack {
                    if isLoading {
                        Text("zoom")
                        //ProgressView("Loading...").progressViewStyle(CircularProgressViewStyle())
                    }
                    
                    if let userID = authVM.userID {
                        Text("User ID: \(userID)")
                            .foregroundStyle(.orange)
                    } else {
                        Text("No user ID available")
                            .foregroundStyle(.red)
                    }
                    HStack {
                        Text("Hello, \(repository.name)")
                            .fontWeight(.bold)
                            .padding()
                        Text("+\(repository.lastName)")
                            .fontWeight(.bold)
                        Spacer()
                        Button(action: {
                            authVM.signOut(navigationVM: navigationVM)
                        }) {
                            Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        .padding()
                    }
                    CustomDivider(color: .black, height: 2, padding: 32)
                    
                    VStack(alignment: .leading, content: {
                        HStack {
                            Image("cat")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .overlay {
                                    Circle().stroke(.white, lineWidth: 3)
                                }
                                .shadow(radius: 5)
                                .padding(2)
                                .padding(.trailing, 50)
                            Button(action: {}, label: {
                                VStack {
                                    Text("304")
                                    Text("posts")
                                }.foregroundStyle(.gray)
                            })
                            Button(action: {}, label: {
                                VStack {
                                    Text("402")
                                    Text("subscribers")
                                }.foregroundStyle(.gray)
                            })
                            Button(action: {}, label: {
                                VStack {
                                    Text("603")
                                    Text("follovers")
                                }.foregroundStyle(.gray)
                            })
                        }
                        Text("Name")
                            .fontWeight(.bold)
                        Text("Description of the profile about Alice. who has been travelled into major state of Ukraine")
                            .multilineTextAlignment(.leading)
                            .lineLimit(5)
                            .frame(width: UIScreen.main.bounds.width * 0.9)
                    })
                    HStack {
                                Button(action: {
                                    showSheet.toggle()
                                }) {
                                    Label("Your link name", systemImage: "link")
                                        .font(.system(size: 15, weight: .bold))
                                        //.padding()
                                        .foregroundColor(.black)
                                        .cornerRadius(8)
                                        .frame(alignment: .leading)
                                }
                                .sheet(isPresented: $showSheet) {
                                    BottomSheetView()
                                }
                                Spacer()
                            }
                            .padding()
                    CustomDivider(color: .black, height: 2, padding: 32)
                    
                    GrayButton(text: "Professional panel", action: {
                        //
                    }, width: UIScreen.main.bounds.width * 0.9, height: 40)
                    HStack {
                        GrayButton(text: "Open profile", action: {
                            navigationVM.pushScreen(route: .editProfile)
                            print("open")
                        }, width: UIScreen.main.bounds.width * 0.42, height: 30)
                        GrayButton(text: "Share profile", action: {
                            ProfileSetupScreen()
                        }, width: UIScreen.main.bounds.width * 0.45, height: 30)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(0..<4) { index in
                                VStack {
                                    Image("cat")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                                                .overlay {
                                                    Circle().stroke(.white, lineWidth: 3)
                                                }
                                                .shadow(radius: 5)
                                    Text("Post \(index)")
                                        .font(.headline)
                                }
                                .frame(width: 60, height: 90)
                                //.background(Color.blue)
                                .foregroundColor(.black)
                                .cornerRadius(8)
                            }
                            Button(action: {
                                print("Button tapped")
                            }) {
                                VStack {
                                    Image(systemName: "plus.circle.fill")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.gray)
                                    Text("Add Post")
                                        .font(.headline)
                                }
                                .frame(width: 80, height: 80)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(8)
                            }
                        }
                        .padding()
                    }
                    .frame(height: 120)
                    ///
                    CustomDivider()
                    VStack {
                        HStack(spacing: 16) {
                            Spacer()
                            
                            Button(action: {
                                selectedButton = 1
                            }) {
                                Image(systemName: "square.grid.3x3.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Button(action: {
                                selectedButton = 2
                            }) {
                                Image(systemName: "play.square")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Button(action: {
                                selectedButton = 3
                            }) {
                                Image(systemName: "person.2.gobackward")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            .foregroundColor(.gray)
                            
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        
                        // Content based on button selection
                        if selectedButton == 1 {
                            GalleryView()
                        } else if selectedButton == 2 {
                            ListView()
                        } else if selectedButton == 3 {
                            ImagesWithNamesView()
                        }
                    }
                    Spacer()
                }
                
                .onAppear {
                    Task {
                        await repository.getUserInfo()
                        selectedButton = 1
                    }
                }
                .navigationDestination(for: NavigationRoute.self) { route in
                    switch route {
                    case .editProfile:
                        ProfileSetupScreen()
                    default:
                        EmptyView()
                    }
                }
            }.refreshable {
                await refreshData()
                print("refresh begin")
            }/*
            .overlay {
                if isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }*/
        }
    }
    func refreshData() async {
            isLoading = true
            try? await Task.sleep(nanoseconds: 3_000_000_000)  // 2 seconds delay
            await repository.getUserInfo()
        print("refresf in progress")
            isLoading = false
        }
}
struct CustomDivider: View {
    var color: Color = .black
    var height: CGFloat = 1
    var padding: CGFloat = 16
    
    var body: some View {
        Divider()
            .background(color)
            .frame(height: height)
    }
}
struct BottomSheetView: View {
    var body: some View {
        VStack {
            Text("https://headline.team")
                .font(.system(size: 15, weight: .bold))
                .padding()
                //.foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
        .padding()
        .presentationDetents([.fraction(0.2)]) // Высота 20% экрана
    }
}

#Preview {
    // Создаем временные данные для предварительного просмотра
    let authVM = AuthVM()
    let navigationVM = NavigationRouter()
    let repo = UserRepository()
    
    return HomeScreen()
        .environmentObject(authVM)
        .environmentObject(navigationVM)
        .environmentObject(repo)
}

struct GalleryView: View {
    let images = ["photo1", "photo2", "photo3", "photo4", "photo5","cat"]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(images, id: \.self) { image in
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
            }
            .padding()
        }
    }
}

struct ListView: View {
    let items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
    
    var body: some View {
        List(items, id: \.self) { item in
            Text(item)
        }
    }
}

struct ImagesWithNamesView: View {
    let items = ["photo1", "photo2", "photo3", "photo4", "photo5"] // Replace with your image names
    
    var body: some View {
        VStack {
            ForEach(items, id: \.self) { item in
                HStack {
                    Image(systemName: item) // Replace with Image(uiImage: UIImage(named: item))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    Text(item)
                        .font(.headline)
                }
                .padding()
            }
        }
    }
}
