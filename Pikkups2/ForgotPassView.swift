//
//  ForgotPassView.swift
//  Pikkups2
//
//  Created by Eric Feng on 2020-12-31.
//

import SwiftUI

struct ForgotPassView: View {
    @State var forgotemail = ""
    @State var butpush:Bool = false
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))
                    .ignoresSafeArea(.all)
                VStack {
                    Text("It appears you have forgotten your password...")
                        .padding(.horizontal, 5)
                        .font(.largeTitle)
                        .padding(.bottom, 200)
                    
                    TextField("Email", text: $forgotemail)
                        .padding(15)
                        .font(.title)
                        .frame(width: 300, height: 50, alignment: .center)
                        .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                        .cornerRadius(15)
                        
                    
                    Button(action: {
                        
                    }) {
                        Text("Ya whoops :)")
                            .font(.title)
                            .frame(width: 350, height: 50)
                            .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                            .cornerRadius(10)
                            .padding(.top, 25)
                            .padding(.bottom, 100)
                    }
                    
                
                    Button(action: {
                        print("works")
                        self.butpush = true
                        
                    }) {
                        Text("No I didn't")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                            .frame(width: 370, height: 45, alignment: .center)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)), lineWidth: 8))
                            .cornerRadius(15)
                    }
                }
            }
        }.navigationBarHidden(true)
    }
}

struct ForgotPassView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPassView()
    }
}
