import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var str = "Dispatch Barrier"

//Serial
var array = [Int]()
var arrayConc = [Int]()

for i in 0...9{
    array.append(i)
}

print(array)
print(array.count)

//Concurent
DispatchQueue.concurrentPerform(iterations: 10) { (index) in
    arrayConc.append(index)
}
print(arrayConc)
print(arrayConc.count)


class SafeArray<T> {
    private var array = [T]()
    private let queue = DispatchQueue(label: "TEST QUEUE",attributes: .concurrent)
    
    public func append(_ value: T){
        queue.async(flags: .barrier){
            self.array.append(value)
        }
    }
    
    public var valueArray: [T]{
        var result = [T]()
        
        queue.async {
            result = self.array
        }
        
        return result
    }
}

var arraySafe = SafeArray<Int>()
DispatchQueue.concurrentPerform(iterations: 10) { (index) in
    arraySafe.append(index)
}

print("arraySafe = \(arraySafe.valueArray)")
print("arraySafeCount = \(arraySafe.valueArray.count)")
