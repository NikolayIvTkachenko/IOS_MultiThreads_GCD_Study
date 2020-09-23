import UIKit

//проблемы у потоков
//-условия гонки
//-конкуренция за ресурс
//-вечная блокировка
//-голодание
//-нверсия приоритетов
//-неопределнность и справедливость

//NSRecursiveLock

//let recursiveLock = NSRecursiveLock()
class RecursiveMutexTest {
    
    private var mutex = pthread_mutex_t()
    
    private var attribute = pthread_mutexattr_t()
    
    init(){
        pthread_mutexattr_init(&attribute)
        pthread_mutexattr_settype(&attribute, PTHREAD_MUTEX_RECURSIVE)
        pthread_mutex_init(&mutex, &attribute)
    }
    
    func firstSomeMethod(){
        pthread_mutex_lock(&mutex)
        
        //some code
        secondSomeMethod()
        defer {
            pthread_mutex_unlock(&mutex)
        }
        
    }
    
    func secondSomeMethod(){
        pthread_mutex_lock(&mutex)
        
        //some code
        print("Finish")
        
        defer {
            pthread_mutex_unlock(&mutex)
        }
        
    }
    
}


let recurcive = RecursiveMutexTest()
recurcive.firstSomeMethod()


//--------
let recursiveLock = NSRecursiveLock()

class RecursiveThread: Thread {
    override func main() {
        
        recursiveLock.lock()
        print("Thread locked <main>")
        callMethod()
        defer {
            recursiveLock.unlock()
        }
        print("Quit from main")
        
    }
    
    func callMethod(){
        recursiveLock.lock()
        print("Thread locked <callMethod>")
        defer {
            recursiveLock.unlock()
        }
        print("Quit from callMethod")
    }
}

let threadV2 = RecursiveThread()
threadV2.start()
