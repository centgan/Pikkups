//
//  SignUpView.swift
//  Pikkups2
//
//  Created by Eric Feng on 2020-12-31.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import MapKit

struct SignUpView: View {
    var body: some View {
        emailpswd()
    }
}

struct emailpswd: View {
    @State var signemail = ""
    @State var pswd = ""
    @State var cpswd = ""
    @State var paswrong:Bool = false
    @State var infomiss:Bool = false
    @State var invalemail:Bool = false
    @State var show:Bool = false
    @State var attempts: Int = 0
    @State var error:Bool = false
    @State var errormes = ""
    //@ObservedObject var setup = usersetup()
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .top){
                Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1))
                    .ignoresSafeArea(.all)
                VStack(spacing: 15){
                    VStack(alignment:.leading, spacing: 10) {
                        Text("Enter your email")
                            .font(.title2)
                            .fontWeight(.medium)
                            .textContentType(.emailAddress)
                        TextField("Email", text: $signemail)
                            .padding(.all, 9)
                            .font(.title3)
                            .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                            .cornerRadius(10)
                            .autocapitalization(.none)
                    }.padding(.horizontal, 10)
                    
                    if invalemail == true {
                        Text("Please enter a valid email")
                            .foregroundColor(Color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)))
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Enter your password")
                            .font(.title2)
                            .fontWeight(.medium)
                        SecureField("Password", text: $pswd)
                            .padding(.all, 9)
                            .font(.title3)
                            .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                            .cornerRadius(10)
                            .modifier(Shake(animatableData: CGFloat(attempts)))
                            .autocapitalization(.none)
                    }.padding(.horizontal, 10)
                    
                    VStack(alignment:.leading, spacing: 10) {
                        Text("Enter your password again to confirm")
                            .font(.title3)
                            .fontWeight(.medium)
                        SecureField("Password", text: $cpswd)
                            .padding(.all, 9)
                            .font(.title3)
                            .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                            .cornerRadius(10)
                            .modifier(Shake(animatableData: CGFloat(attempts)))
                            .autocapitalization(.none)
                    }.padding(.horizontal, 10)
                    
                    if paswrong {
                        Text("Your passwords do not match")
                            .foregroundColor(Color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)))
                    }else if infomiss {
                        Text("There is some missing information")
                            .foregroundColor(Color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)))
                    }else if error {
                        Text(errormes)
                            .foregroundColor(Color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)))
                            .frame(height: 50)
                    }
                    
                    Button(action: {
                        if (cpswd != pswd) {
                            print("wrong")
                            paswrong = true
                            withAnimation(.default) {
                                self.attempts += 1
                            }
                        }else if !signemail.contains("@") {
                            invalemail = true
                        }else if signemail.isEmpty || pswd.isEmpty || cpswd.isEmpty {
                            infomiss = true
                        }else {
                            self.paswrong = false
                            self.invalemail = false
                            self.infomiss = false
//                            self.setup.signemail = signemail
//                            self.setup.pswd = pswd
                            //print(setup.last)
                            //fix this when signing up cant use this have to do it at the end
                            Auth.auth().createUser(withEmail: signemail, password: pswd) {
                                (result, error) in
                                if error != nil {
                                    print(error as Any)
                                    self.error = true
                                    self.errormes = error!.localizedDescription
                                }else {
                                    /*Auth.auth().currentUser?.delete {error in
                                        if error != nil {
                                            print("there was an error deleting")
                                        }else {
                                            print("no error deleting")
                                        }
                                    }*/
                                    Auth.auth().currentUser?.sendEmailVerification {(err) in
                                        if err != nil {
                                            print("uh oh")
                                        }
                                        UserDefaults.standard.set(true, forKey:"verf")
                                    }
                                    show = true
                                }
                            }
                        }
                    }) {
                        Text("Next")
                            .frame(width: 350, height: 50, alignment:/*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .font(.title2)
                            .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                            .cornerRadius(15)
                    }.padding(.bottom, 50)
                }
                NavigationLink(destination: verf(), isActive: $show) {EmptyView()}
            }
        }.navigationBarTitle(Text("Let's get you set up!"))
        .navigationBarBackButtonHidden(show)
    }
}

//this is your email verificaton view
struct verf: View {
    @State var code:String = ""
    @State var right = false
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
                VStack{
                    Text("Check your email you should have recieved an email from us")
                        .fontWeight(.bold)
                    let emval = Auth.auth().currentUser!.isEmailVerified
                    if emval == true {
                        self.right = true
                    }
                    Button(action: {
                        Auth.auth().currentUser?.sendEmailVerification {(err) in
                            if err != nil {
                                print("uh oh")
                            }
                        }
                    }) {
                        Text("resend the email")
                    }
                }
                NavigationLink(destination:name(), isActive: $right){EmptyView()}
            }
        }.navigationBarBackButtonHidden(true)
    }
}

struct name: View {
    @State var d = false
    @State var c = false
    @State var selection = ""
    @State var noselec = false
    @State var First = ""
    @State var Last = ""
    @State var sh:Bool = false
    
    var body: some View{
        NavigationView{
            ZStack(alignment: .top){
                Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1))
                    .ignoresSafeArea(.all)
                VStack(spacing: 15){
                    VStack(alignment:.leading, spacing: 10) {
                        Text("Enter your first name")
                            .font(.title2)
                            .fontWeight(.medium)
                        TextField("First name", text: $First)
                            .padding(.all, 9)
                            .font(.title3)
                            .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                            .cornerRadius(10)
                    }.padding(.horizontal, 10)
                    
                    VStack(alignment:.leading, spacing: 10) {
                        Text("Enter your last name")
                            .font(.title2)
                            .fontWeight(.medium)
                        TextField("Last name", text: $Last)
                            .padding(.all, 9)
                            .font(.title3)
                            .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                            .cornerRadius(10)
                    }.padding(.horizontal, 10)
                    VStack{
                        Text("Do you intend to be a driver or a customer")
                            .font(.title2)
                            .fontWeight(.medium)
                        HStack{
                            Button(action: {
                                self.d.toggle()
                                if c{
                                    c = false
                                }
                            }) {
                                Text("Driver!")
                                    .frame(width: 100, height: 50)
                                    .foregroundColor(d ? Color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)): Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                                    .background(d ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)))
                                    .cornerRadius(15)
                            }.padding()
                            Button(action: {
                                self.c.toggle()
                                if d{
                                    d = false
                                }
                            }) {
                                Text("Customer!")
                                    .frame(width: 100, height: 50)
                                    .foregroundColor(c ? Color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)): Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                                    .background(c ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)))
                                    .cornerRadius(15)
                            }.padding()
                        }
                        if noselec{
                            Text("You have not selected an option yet")
                                .foregroundColor(Color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)))
                        }
                    }
                    
                    Button(action: {
                        if c{
                            self.selection = "Customer"
                        }else {
                            self.selection = "Driver"
                        }
                        if c == false && d == false {
                            noselec = true
                        }
                        CreateUser(first: First, last: Last, pos: selection){ (sta) in
                            if sta{
                                sh = true
                                print("fine")
                            }
                        }
                    }) {
                        Text("Create")
                            .frame(width: 350, height: 50, alignment:/*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .font(.title2)
                            .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                            .cornerRadius(15)
                    }
                }
                NavigationLink(destination: CustomerView(), isActive: $sh) {EmptyView()}
            }.onAppear(){
                UserDefaults.standard.set(false, forKey: "verf")
                UserDefaults.standard.set(true, forKey: "name")
            }
        }.navigationBarBackButtonHidden(true)
    }
}
func CreateUser(first: String, last: String, pos: String, /*image: Data,*/ completion: @escaping(Bool)-> Void){
    let db = Firestore.firestore()
    //let storage = Storage.storage().reference
    let uid = Auth.auth().currentUser?.uid
    db.collection("users").document(uid!).setData(["First": first, "Last": last, "D or C": pos, "uid": uid as Any]){ (err) in
        if err != nil {
            print((err?.localizedDescription) as Any)
            return
        }
        completion(true)
        UserDefaults.standard.set(true, forKey: "status")
    }
}

/*
 struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}*/

struct SignUpView_Previews: PreviewProvider {
   //@State static var what = true
    static var previews: some View {
        SignUpView()
    }
}
