import UIKit

//Condition
var str = "NSCondition()"

var available = false
var condition = pthread_cond_t()
var mutex = pthread_mutex_t()

class ConditionMutexPrinter : Thread {
    
    override init(){
        pthread_cond_init(&condition, nil)
        pthread_mutex_init(&mutex, nil)
    }
    
    override func main() {
        printerMethod()
    }
    
    private func printerMethod(){
        pthread_mutex_lock(&mutex)
        
        print("printer start")
        
        while (!available){
            pthread_cond_wait(&condition, &mutex)
            
        }
        
        available = false
        
        //code
        
        defer {
            pthread_mutex_unlock(&mutex)
        }
        print("printer end")
        
    }
}

class ConditionMutexWriter : Thread {
    
    override init(){
        pthread_cond_init(&condition, nil)
        pthread_mutex_init(&mutex, nil)
    }
    
    override func main() {
        writerMethod()
    }
    
    private func writerMethod(){
        pthread_mutex_lock(&mutex)
        
        print("Writer start")
        //code
        //do something
        
        
        available = true
        pthread_cond_signal(&condition)
        defer {
            pthread_mutex_unlock(&mutex)
        }
        print("Writer end")
        
    }
}


let conditionMutexWriter = ConditionMutexWriter()
let conditionMutexPrinter = ConditionMutexPrinter()

conditionMutexPrinter.start()
conditionMutexWriter.start()



//NSCondition

let cond = NSCondition()
var availables = false

class WriterThread: Thread {
    override func main(){
        cond.lock()
        
        //code do something
        print("WriteThread enter")
        
        availables = true
        cond.signal()
        
        defer {
            cond.unlock()
        }
        print("WriteThread quit")
    }
}

class PrinterThread: Thread {
    override func main() {
        cond.lock()
        print("PrinterThread enter")
        while (!availables) {
            
            cond.wait()
        }
        
        availables = false
        
        defer {
            cond.unlock()
        }
        print("PrinterThread quit")
        
    }
}

let writet = WriterThread()
let printet = PrinterThread()

printet.start()
writet.start()
