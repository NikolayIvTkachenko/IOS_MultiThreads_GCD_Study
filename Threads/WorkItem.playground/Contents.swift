import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var str = "Work Item"



class DispatchWorkItem1{
    
    private let queue = DispatchQueue(label: "DispatchWorkItem1", attributes: .concurrent)
    
    func create(){
        let workItem = DispatchWorkItem{
            print(Thread.current)
            print("Start task")
        }
        
        workItem.notify(queue: .main) {
            print(Thread.current)
            print("Finish task")
        }
        queue.async(execute: workItem)
    }
}

//let dispatchWorkItem1 = DispatchWorkItem1()
//dispatchWorkItem1.create()

class DispatchWorkItem2{
    
    private let queue = DispatchQueue(label: "DispatchWorkItem2") //serial queie
    
    func create(){
        
        queue.async{
            sleep(1)
            print(Thread.current)
            print("task 1")
        }
        
        queue.async{
            sleep(1)
            print(Thread.current)
            print("task 2")
        }
        
        let workItem = DispatchWorkItem{
            print(Thread.current)
            print("Start work item task")
        }
        
        queue.async(execute: workItem)
        
        //workItem.cancel()
    }
}

//let dispatchWorkItem2 = DispatchWorkItem2()
//dispatchWorkItem2.create()

let imageURL = URL(string: "https://upload.wikimedia.org/wikipedia/ru/8/85/Terminator2poster.jpg")!

var view = UIView(frame: CGRect(x: 0, y: 0, width: 800, height: 800))
var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 800, height: 800))

imageView.backgroundColor = .red
imageView.contentMode = .scaleAspectFit
view.addSubview(imageView)

PlaygroundPage.current.liveView = view

//# classic
func fetchImage(){
    let queue = DispatchQueue.global(qos: .utility)
    queue.async {
        if let data = try? Data(contentsOf: imageURL){
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }
    }
}
//fetchImage()

//# Second case - DispatchWorkItem

func fetchImage2(){
    var data : Data?
    let queue = DispatchQueue.global(qos: .utility)
    
    let workItem = DispatchWorkItem(qos: .userInteractive) {
        data = try? Data(contentsOf: imageURL)
        print(Thread.current)
        print("Get data from internet")
    }
    
    queue.async(execute: workItem)
    
    workItem.notify(queue: DispatchQueue.main) {
        if let imageData = data {
            imageView.image = UIImage(data: imageData)
        }
    }
}
//fetchImage2()


//# Third case - URLSession

func fetchImage3(){
    let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
        print(Thread.current)
        print("get data from internet")
        
        if let imageData = data {
            DispatchQueue.main.async {
                imageView.image = UIImage(data: imageData)
            }
        }
    }
    task.resume()
}
fetchImage3()


