//
//  SecondViewController.swift
//  GCDMultiThreadingIOS
//
//  Created by Nikolay Tkachenko on 23.09.2020.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        for i in 0...20000{
//            print(i)
//        }
        
//        let queue = DispatchQueue.global(qos: .utility)
//        queue.async {
//            DispatchQueue.concurrentPerform(iterations: 200000) {
//                print("\($0) times")
//                print(Thread.current)
//            }
//        }
        
        
        
        testInnactiveQueue()
    }
    

    func testInnactiveQueue(){
        let inactiveQueue = DispatchQueue(label: "The Swift dev", attributes: [.concurrent, .initiallyInactive])
        
        inactiveQueue.async {
            print("Done!")
            
        }
        
        print("Not yet startet...")
        inactiveQueue.activate()
        print("activate")
        inactiveQueue.suspend()
        
        print("Pause!")
        inactiveQueue.resume()
        print("activate again")
        
    }


}
