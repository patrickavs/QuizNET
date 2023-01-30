//
//  ResultView.swift
//  GameDemo
//
//  Created by Patrick Alves on 01.01.23.
//

import SwiftUI
import MultipeerConnectivity

/// This view shows the quiz result and differs when the player is playing alone or with someone else
struct ResultView: View {
    @ObservedObject var vm: QuestionVM
    @EnvironmentObject var connectivity: Connectivity
    @State private var retry = false
    @State private var home = false
    @State private var result: Result = .tie
    @State private var messageForResult = ""
    @State private var sentData = false
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("Congratulations, you have answered all the questions!")
                    .bold()
                    .foregroundColor(.primary)
                    .padding()
                    .font(.title)
                
                Text("Your total score: \(vm.score)")
                    .font(.headline)
                    .padding(.bottom, 30)
                    .padding(.top)
                
                if connectivity.getSession().connectedPeers != [] {
                    Text("Score from Opponent: \(connectivity.receivedValue)")
                        .font(.headline)
                        .padding(.bottom, 30)
                    
                    // MARK: Still a problem with displaying the result on both devices
                    Text("Result: \(messageForResult)")
                        .font(.headline)
                }
                
                Spacer()
                
                HStack(alignment: .center, spacing: 20) {
                    Button {
                        vm.resetAll()
                        // MARK: New Invitation to a new session doesn`t work yet
                        if connectivity.getSession().connectedPeers != [] {
                            /*connectivity.getBrowser().invitePeer(connectivity.getSession().connectedPeers.first!, to: connectivity.getSession(), withContext: nil, timeout: 40)*/
                            self.retry = true
                        }
                        if connectivity.getSession().connectedPeers == [] {
                            self.retry = true
                        }
                    } label: {
                        Text("Retry")
                            .frame(width: 100)
                            .padding()
                            .font(.headline)
                            .foregroundColor(.primary)
                            .background {
                                Rectangle()
                                    .fill(.ultraThinMaterial)
                            }
                            .cornerRadius(12)
                    }
                    
                    Button {
                        vm.resetAll()
                        self.home = true
                        if connectivity.getSession().connectedPeers != [] {
                            connectivity.getSession().disconnect()
                        }
                    } label: {
                        Text("Home")
                            .frame(width: 100)
                            .padding()
                            .font(.headline)
                            .foregroundColor(.primary)
                            .background {
                                Rectangle()
                                    .fill(.ultraThinMaterial)
                            }
                            .cornerRadius(12)
                    }
                }
                
                Spacer()
            }
            .onAppear {
                if connectivity.getSession().connectedPeers != [] {
                    connectivity.send(data: String(vm.score))
                    sentData = true
                }
            }
            .onChange(of: connectivity.receivedValue, perform: { _ in
                checkResult()
                messageForResult = resultMessage()
            })
            .alert(isPresented: $connectivity.disconnectedAlert) {
                Alert(title: Text("\(connectivity.disconnectedMessage)"), message: nil, dismissButton: .cancel())
            }
            
            // MARK: Alert doesn`t work yet
            /*.alert(isPresented: $connectivity.receivedInvite) {
             Alert(title: Text("You would like to play again?"), primaryButton: .default(Text("Yes"), action: {
             if (connectivity.invitationHandler != nil) {
             connectivity.invitationHandler!(true, connectivity.getSession())
             }
             self.retry = true
             }), secondaryButton: .default(Text("No"), action: {
             if (connectivity.invitationHandler != nil) {
             connectivity.invitationHandler!(false, nil)
             }
             self.retry = false
             }))
             }*/
            .navigationDestination(isPresented: $retry) {
                ContentView(vm: vm)
                    .environmentObject(connectivity)
            }
            .navigationDestination(isPresented: $home) {
                WelcomeView(vm: vm)
                    .environmentObject(connectivity)
            }
            .navigationBarBackButtonHidden()
        }
    }
    
    /// Checks if you won, loose or if this quiz round was a tie
    func checkResult() {
        if Int(connectivity.receivedValue)! > vm.score {
            result = .loss
        } else if vm.score > Int(connectivity.receivedValue)! {
            result = .win
        } else {
            result = .tie
        }
    }
    
    /// Set the result message and return the result
    /// - Returns: Returns the result message
    func resultMessage() -> String {
        if result == .loss {
            messageForResult = "You lost!"
            return messageForResult
        } else if result == .win {
            messageForResult = "You won!"
            return messageForResult
        } else {
            messageForResult = "It`s a tie!"
            return messageForResult
        }
    }
}

/*struct ResultView_Previews: PreviewProvider {
 static var previews: some View {
 ResultView(vm: QuestionVM())
 }
 }*/

/// This enum is used to choose who of the participants won or loss. If both results are equal the state will be tie.
enum Result {
    case win, loss, tie
}
