import UIKit

var str = "ReadWriteLock SpinLock UnfairLock Synchronized in Objc"
var str1 = "Lock"

class ReadWriteLock {
    private var lock = pthread_rwlock_t()
    private var attribute = pthread_rwlockattr_t()
    
    private var globalProperty: Int = 0
    
    init(){
        pthread_rwlock_init(&lock, &attribute)
    }
    
    public var workProperty: Int {
        get {
            pthread_rwlock_wrlock(&lock)
            let temp = globalProperty
            pthread_rwlock_unlock(&lock)
            return temp
        }
        
        set{
            pthread_rwlock_wrlock(&lock)
            globalProperty = newValue
            pthread_rwlock_unlock(&lock)
        }
    }
}

class SpinLock {
    private var lock = OS_SPINLOCK_INIT
    
    func some(){
        //depricated in 10.0
        OSSpinLockLock(&lock)
        
        //do something
        
        OSSpinLockUnlock(&lock)
    }
}

//with 10.0
class UnfairLock{
    private var lock = os_unfair_lock_s()
    
    var array = [Int]()
    
    func some(){
        os_unfair_lock_lock(&lock)
        
        //do something
        array.append(1)
        
        os_unfair_lock_unlock(&lock)
    }
}

class SynchronizedObjc{
    private let lock = NSObject()
    
    var array = [Int]()
    
    func some(){
        objc_sync_enter(lock)
        
        //do something
        array.append(2)
        
        objc_sync_exit(lock)
    }
    
}
