import UIKit

//Syncronization & Mutex
//mutex - защита объекта для доступа к нему из потоков, один поток имеет доступ к объекту. Другие ждут освобождения mutex

class SaveThread{
    private var mutex = pthread_mutex_t()
    
    init() {
        pthread_mutex_init(&mutex, nil)
        
    }
    
    func someMethod(competion: () -> ()){
        pthread_mutex_lock(&mutex)
        
        //some data
        competion()
        
        //в случае сбоя внутри потока , гарантированно выполняется , освобождает mutex
        defer {
            pthread_mutex_unlock(&mutex)
        }
    }
}

var array = [String]()
let saveThread = SaveThread()

//Protect array for threads
saveThread.someMethod {
    print("Some test 555")
    array.append("Device 1")
}

array.append("Device 2")


//Case 2
class SaveThreadV2{
    private let lockMutex = NSLock()
    
    func someMethod(competion: () -> ()){
        lockMutex.lock()
        
        //some data
        competion()
        
        //в случае сбоя внутри потока , гарантированно выполняется , освобождает mutex
        defer {
            lockMutex.unlock()
        }
    }
}

var arrayV2 = [String]()
let saveThreadV2 = SaveThreadV2()

//Protect array for threads
saveThreadV2.someMethod {
    print("Some test 666")
    arrayV2.append("Device 1")
}

arrayV2.append("Device 2")
