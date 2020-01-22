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
import AWSMobileClient
import AWSS3

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        apiMutate()
//        apiQuery(id: "F91ECB47-16CF-40E2-BA72-AE2C0C8F0BF3")
//        createSubscription()
//        showAuthView()
        
//        AWSMobileClient.default()
//            .showSignIn(navigationController: self.navigationController!,
//                             signInUIOptions: SignInUIOptions(
//                                   canCancel: false,
//                                   logoImage: UIImage(named: "MyCustomLogo"),
//                                    backgroundColor: UIColor.black)) { (result, err) in
//                                    //handle results and errors
//        }
        
        AWSMobileClient.default().signUp(
            username: "your_username",
            password: "Abc@123!",
            userAttributes: ["nickname":"Johnny", "badge_number": "ABC123XYZ"]) { (signUpResult, error) in
            //Use results as before
        }
        
    }


    @IBAction func s3Action(_ sender: Any) {
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Update a progress bar.
            })
        }

        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Alert a user for transfer completion.
                // On failed uploads, `error` contains the error object.
            })
        }

        let data: Data = "hello world".data(using: .utf8)! // Data to be uploaded
        let transferUtility = AWSS3TransferUtility.default()

        let format:DateFormatter = DateFormatter()
        format.dateFormat = "yyyyMMdd-hhmmss"
        let dateString:String = format.string(from: Date())

        transferUtility.uploadData(data,
           bucket: SecretConstants.s3BucketName,
           key: "uploads/"+dateString+".txt",
           contentType: "text/plain",
           expression: expression,
           completionHandler: completionHandler).continueWith {
            (task) -> AnyObject? in
            if let error = task.error {
                print("Error: \(error.localizedDescription)")
            }

            if let _ = task.result {
                // Do something with uploadTask.
            }
            return nil
        }
    }
    @IBAction func logoutAction(_ sender: Any) {
        
        AWSMobileClient.sharedInstance().signOut()

        // サインイン画面を表示
        AWSMobileClient.default().showSignIn(navigationController: self.navigationController!, { (userState, error) in
            if(error == nil){       //Successful signin
                DispatchQueue.main.async {
                    print("Sign In")
                }
            }
        })
        
    }
    
    func showSignIn(){
        AWSMobileClient.default().showSignIn(navigationController: self.navigationController!, { (signInState, error) in
            if let signInState = signInState {
                print("Sign in flow completed: \(signInState)")
            } else if let error = error {
                print("error logging in: \(error.localizedDescription)")
            }
        })
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

