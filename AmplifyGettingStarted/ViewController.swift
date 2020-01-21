//
//  ViewController.swift
//  AmplifyGettingStarted
//
//  Created by 中山 陽介 on 2020/01/17.
//  Copyright © 2020 Yosuke Nakayama. All rights reserved.
//

import UIKit
import Amplify
import AmplifyPlugins

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        apiMutate()
//        apiQuery(id: "F91ECB47-16CF-40E2-BA72-AE2C0C8F0BF3")
        createSubscription()
    }


    func apiMutate() {
        let note = Note(content: "いいい")
        Amplify.API.mutate(of: note, type: .create) { (event) in
            switch event {
            case .completed(let result):
                switch result {
                case .success(let note):
                    print("API Mutate successful, created note: \(note)")
                case .failure(let error):
                    print("Completed with error: \(error.errorDescription)")
                }
            case .failed(let error):
                print("Failed with error \(error.errorDescription)")
            default:
                print("Unexpected event")
            }
        }
    }
    
    func apiQuery(id: String) {
        Amplify.API.query(from: Note.self, byId: id) { (event) in
            switch event {
            case .completed(let result):
                switch result {
                case .success(let note):
                    guard let note = note else {
                        print("API Query completed but missing note")
                        return
                    }
                    print("API Query successful, got note: \(note)")
                case .failure(let error):
                    print("Completed with error: \(error.errorDescription)")
                }
            case .failed(let error):
                print("Failed with error \(error.errorDescription)")
            default:
                print("Unexpected event")
            }
        }
    }
    
    func createSubscription() {
        let subscriptionOperation = Amplify.API.subscribe(from: Note.self, type: .onCreate) { (event) in
            switch event {
            case .inProcess(let subscriptionEvent):
                switch subscriptionEvent {
                case .connection(let subscriptionConnectionState):
                    print("Subsription connect state is \(subscriptionConnectionState)")
                case .data(let result):
                    switch result {
                    case .success(let todo):
                        print("Successfully got note from subscription: \(todo)")
                    case .failure(let error):
                        print("Got failed result with \(error.errorDescription)")
                    }
                }
            case .completed:
                print("Subscription has been closed")
            case .failed(let error):
                print("Got failed result with \(error.errorDescription)")
            default:
                print("Should never happen")
            }
        }
    }
}

