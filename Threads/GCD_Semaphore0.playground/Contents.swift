import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = false

var str = "Semaphore"

//===============================
let queue = DispatchQueue(label: "The queue for handle", attributes: .concurrent)
let semaphore = DispatchSemaphore(value: 2) //Two thread can work no more

queue.async {
    semaphore.wait() //-1 thread occupay place and last 1 thread from 2
    sleep(3)
    print("Some method work 1")
    semaphore.signal() //+1
}

queue.async {
    semaphore.wait() //-1 thread occupay place and last 1 thread from 2
    sleep(3)
    print("Some method work 2")
    semaphore.signal() //+1
}

queue.async {
    semaphore.wait() //-1 thread occupay place and last 1 thread from 2
    sleep(3)
    print("Some method work 3")
    semaphore.signal() //+1
}


let sem = DispatchSemaphore(value: 2)

DispatchQueue.concurrentPerform(iterations: 10) { (id: Int) in
    sem.wait(timeout: DispatchTime.distantFuture)
    sleep(1)
    print("Block \(id)")
    sem.signal()
}

class SemaphoreTest{
    
    private let semaphoreV2 = DispatchSemaphore(value: 2)
    private var array = [Int]()
    
    private func methodWork(_ id: Int){
        semaphoreV2.wait()//-1
        array.append(id)
        print("test array \(array.count)")
        Thread.sleep(forTimeInterval: 2)
        semaphoreV2.signal() //+1
    }
    
    public func startAllThread(){
        DispatchQueue.global().async {
            self.methodWork(111)
            print(Thread.current)
        }
        DispatchQueue.global().async {
            self.methodWork(112)
            print(Thread.current)
        }
        DispatchQueue.global().async {
            self.methodWork(113)
            print(Thread.current)
        }
        DispatchQueue.global().async {
            self.methodWork(14)
            print(Thread.current)
        }
//        DispatchQueue.global().async {
//            self.methodWork(115)
//            print(Thread.current)
//        }
//        DispatchQueue.global().async {
//            self.methodWork(116)
//            print(Thread.current)
//        }
//        DispatchQueue.global().async {
//            self.methodWork(117)
//            print(Thread.current)
//        }
//        DispatchQueue.global().async {
//            self.methodWork(118)
//            print(Thread.current)
//        }
//        DispatchQueue.global().async {
//            self.methodWork(119)
//            print(Thread.current)
//        }
//        DispatchQueue.global().async {
//            self.methodWork(122)
//            print(Thread.current)
//        }
    }
}

let semaphoreTest = SemaphoreTest()
semaphoreTest.startAllThread()
