import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true


var str = "Dispatch Source"

//DISPATCH SOURCE========

let timer = DispatchSource.makeTimerSource(queue: .global())

timer.setEventHandler {
    print("!")
}

timer.schedule(deadline: .now(), repeating: 5)
timer.activate()





