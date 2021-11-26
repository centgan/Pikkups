//
//  HomeView.swift
//  Pikkups2
//
//  Created by Eric Feng on 2021-01-01.
//

import SwiftUI
import Firebase

struct HomeView: View {
    @Binding var stat:Bool
    
    var body: some View {
        NavigationView {
            //ADD A LISTENER
            VStack{
                Button(action: {
                    try! Auth.auth().signOut()
                    UserDefaults.standard.set(false, forKey: "status")
                    print("signout suc")
                    self.stat = true
                }) {
                    Text("logout")
                }
            }.onAppear(){
                UserDefaults.standard.set(false, forKey: "name")
            }
            NavigationLink(destination: ContentView(), isActive: $stat){EmptyView()}
        }.navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    @State static var what = true
    static var previews: some View {
        HomeView(stat: $what)
    }
}
