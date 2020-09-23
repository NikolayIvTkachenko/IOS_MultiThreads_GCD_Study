import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var str = "Operation , Iperation, Queue"


//Operation - абстрактный класс, представляющий код и данные связанные с одной задачей
//потокобезопасная структура
//Operation Queue - Операционая очередь выполняет свои очереди Operation объектов на основе их приоритета и готовности
//После добавления в операционную очередь операция остается в очерели , пока не сообщит , что она завершена с ее задачей

print(Thread.current)

let operation1 = {
    print("Start")
    print(Thread.current)
    print("Finish")
}

let queue = OperationQueue()
queue.addOperation(operation1)


print(Thread.current)

var result: String?

let concatOperation = BlockOperation{
    result = "Tested " + " " + " SOME "
    print(Thread.current)
}
//concatOperation .start()
//print(result!)

let queue1 = OperationQueue()
queue1.addOperation(concatOperation)
print(result!)

let queue2 = OperationQueue()
queue2.addOperation{
    print("Test queue 2")
    print(Thread.current)
}

class TestThread: Thread {
    override func main() {
        print("Test main thread")
        print(Thread.current)
    }
}

let testThread = TestThread()
testThread.start()

class OperationA: Operation {
    override func main() {
        print("Test operation A")
        print(Thread.current)
    }
}

let operationA = OperationA()
//operationA.start()

let queue4 = OperationQueue()
queue4.addOperation(operationA)
