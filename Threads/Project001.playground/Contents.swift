import UIKit

//Thread
//Operation
//GCD - Grand Central Dispatch


//Unix - POSIX
var thread = pthread_t(bitPattern: 0) //create thread
var attribut = pthread_attr_t()

pthread_attr_init(&attribut)
pthread_create(&thread, &attribut, { (pointer) -> UnsafeMutableRawPointer? in
    print("Test code here")
    return nil
}, nil)

//2 Thread
var nsthread = Thread {
    print("Test code here 2")
}
nsthread.start()
nsthread.cancel()
nsthread.isExecuting
//nsthread.setValue("34", forKey: "number1")

Thread.setThreadPriority(2)

//Quality Of Service
var pthread = pthread_t(bitPattern: 0)
var attribute = pthread_attr_t()

pthread_attr_init(&attribute)
pthread_attr_set_qos_class_np(&attribute, QOS_CLASS_USER_INITIATED, 0)
pthread_create(&pthread, &attribute, { (pointer) -> UnsafeMutableRawPointer? in
    print("Test code 3")
    pthread_set_qos_class_self_np(QOS_CLASS_BACKGROUND, 0)
    
    return nil
}, nil)

//TRhread
let nsthreadqos = Thread {
    print("Test 4")
    print(qos_class_self())
    
}
nsthreadqos.qualityOfService = .userInteractive
nsthreadqos.start()

print(qos_class_main())

