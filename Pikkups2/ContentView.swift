//
//  ContentView.swift
//  Pikkups2
//
//  Created by Eric Feng on 2020-12-30.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct ContentView: View {
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    //@State var stat:Bool = false
    @ObservedObject var settings = UserSettings()
    
    @State var emver = UserDefaults.standard.value(forKey: "verf") as? Bool ?? false
    @State var proset = UserDefaults.standard.value(forKey: "name") as? Bool ?? false
    
    var body: some View {
        VStack{
            if status{
                HomeView(stat: $settings.sta)
            }else if settings.sta{
                NavigationView{
                    //login(stat: $stat)
                    login(stat: $settings.sta)
                }.navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            }else if emver{
                verf()
            }else if proset{
                name()
            }else {
                NavigationView{
                    //login(stat: $stat)
                    login(stat: $settings.sta)
                }.navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            }
        }.onAppear {
            let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
            let emver = UserDefaults.standard.value(forKey: "verf") as? Bool ?? false
            let proset = UserDefaults.standard.value(forKey: "name") as? Bool ?? false
            self.status = status
            self.emver = emver
            self.status = proset
        }
    }
}
class UserSettings: ObservableObject {
    //need sta to return back to this login view if logout
    @Published var sta:Bool = false
    @Published var driver:Bool = false
    @Published var customer:Bool = false
}

//class what : BindableObject {
//    var email:String = ""
//    func signup(email: String, pswd: String){
//        Auth.auth().createUser(withEmail: email, password: pswd){(res, err) in
//            if err != nil {
//                print("fuck")
//            }
//        }
//    }
//}

struct login: View {
    @State private var email = ""
    @State private var pswd = ""
    @State var attempts: Int = 0
    @State var error:Bool = false
    @State var Sign:Bool = false
    @State var Forgot:Bool = false
    @State var anstop:Bool = false
    @Binding var stat:Bool
    
    @ObservedObject var set = UserSettings()
    
    var body: some View {
        ZStack{
            Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
                .ignoresSafeArea(.all)
            Rectangle()
                .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                .frame(width: 350, height: 275, alignment: .center)
                .cornerRadius(30)
                .padding(.horizontal, 20)
                .modifier(Shake(animatableData: CGFloat(attempts)))
            
            /*Text("Welcome to Pikkups")
                .
             Here idea!: when showing this screen have packages from other places on the screen and carry the packages that have seperate words and assemble it at the top of the screen. if they still havent moved from this screen then dissasblem in pacakges transport in different cars and go everywhere meaning top, sides, bottom of the screen and repeat until they have clicked somewhere.
             */
            VStack(alignment: .center, spacing: 15) {
                TextField("Email or Phone number", text: $email)
                    .padding(.all, 15)
                    .frame(width: 300, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .font(.title2)
                    .background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                    .cornerRadius(20)
                    .autocapitalization(.none)
                SecureField("Password", text: $pswd)
                    .padding(.all, 15)
                    .frame(width: 300, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                    .background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                    .font(.title2)
                    .cornerRadius(20)
                    .autocapitalization(.none)
                VStack(spacing: 5) {
                    if error == true {
                        Text("The information provided is incorrect. Please try again")
                            .foregroundColor(.red)
                            .font(.custom("Times New Roma", size: 10))
                    }
                    Button(action: {
                        print("works")
                        Auth.auth().signIn(withEmail: email, password: pswd) { (result, error) in
                            if error != nil{
                                self.error = true
                                withAnimation(.default) {
                                    self.attempts += 1
                                }
                            }
                        print("good to go")
                        //self.Home = true
                        UserDefaults.standard.set(true, forKey: "status")
                        fetch()
                        print(set.driver)
                        /*this is where youre supposed to have variable to go to different login view*/
                            
                        //cant use anstop here have to use seperate var anstop = true
                        /*DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                           create pop up with logging in animation
                           self.anstop = true
                        }*/
                        }
                    }) {
                        
                        Text("Login")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding()
                            .frame(width: 200, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .background(LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.black)
                    }
                    HStack(spacing: 75) {
                        Button(action: {
                            print("work")
                            self.Forgot = true
                        }) {
                            Text("Forgot password?")
                                .font(.custom("Times New Roman", size: 10))
                                .foregroundColor(.blue)
                        }
                        Button(action: {
                            print("wor")
                            self.Sign = true
                        }) {
                            Text("Don't have an account? Sign up here")
                                .font(.custom("Times New Roman", size: 10))
                        }
                    }.padding(.top, 10)
                    NavigationLink(destination: ForgotPassView(), isActive: $Forgot) {EmptyView()}
                    NavigationLink(destination: SignUpView(), isActive: $Sign) {EmptyView()}
                    //NavigationLink(destination: HomeView(stat: $stat), isActive: $Home) {EmptyView()}
                }
            }.padding()
        }
    }
}
func fetch(){
    let sett = UserSettings()
    
    let userid = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    let docref = db.collection("users").document(userid!)
    guard (Auth.auth().currentUser?.uid) != nil else { return }
    docref.getDocument{ (document, error) in
        if let document = document, document.exists {
            let datadescrip = document.data().map(String.init(describing:)) ?? "nil"
            print("document data: \(datadescrip)")
            if datadescrip.contains("Driver"){
                print("good shit boi")
                sett.driver = true
            }else if datadescrip.contains("Customer"){
                print("no good shit boi")
                sett.customer = true
            }
        }else {
            print("does not exist")
        }
    }
    /*db.collection("users").document("\(uid)").addSnapshotListener{ documentSnapshot, error in
        guard let document = documentSnapshot else {
            print("error fetch")
            return
        }
        guard let data = document.data() else {
            print("empty fetch")
            return
        }
        print("currentdata: \(data)")
    }*/
}

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
