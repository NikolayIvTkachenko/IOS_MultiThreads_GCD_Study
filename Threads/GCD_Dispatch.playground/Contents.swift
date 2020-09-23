import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true


//let imageURLs = ["https://upload.wikimedia.org/wikipedia/ru/8/85/Terminator2poster.jpg",
//                 "https://upload.wikimedia.org/wikipedia/ru/c/ca/Terminator_poster.jpg",
//                 "https://st.kp.yandex.net/im/poster/3/4/1/kinopoisk.ru-Terminator-2_3A-Judgment-Day-3418179--o--.jpg",
//                 "https://cdn22.img.ria.ru/images/15121/14/151211437_0:0:0:0_600x0_80_0_0_dcfd35ff2f79b35cb2f815a0b0317106.jpg"]
var str = "Dispatch Group"


class DispatchGroupTest01{
    //Serial start threads
    private let queueSerial = DispatchQueue(label: "Main Queue")
    
    private let groundRed = DispatchGroup()
    
    func loadInfo(){
        queueSerial.async(group: groundRed){
            sleep(1)
            print("1")
        }
        
        queueSerial.async(group: groundRed){
            sleep(1)
            print("2")
        }
        
        groundRed.notify(queue: .main){
            print("groupRed finish all")
        }
        
    }
}

let dispatchGroupTest01 = DispatchGroupTest01()
//dispatchGroupTest01.loadInfo()


class DispatchGroupTest012{
    //start all thread together, not serial
    private let queueSerial = DispatchQueue(label: "Main Queue", attributes: .concurrent)
    
    private let groundRed = DispatchGroup()
    
    func loadInfo(){
        queueSerial.async(group: groundRed){
            sleep(1)
            print("1")
        }
        
        queueSerial.async(group: groundRed){
            sleep(1)
            print("2")
        }
        
       
        
        groundRed.notify(queue: .main){
            print("groupRed finish all")
        }
        
    }
}

let dispatchGroupTest012 = DispatchGroupTest012()
//dispatchGroupTest012.loadInfo()

class DispatchGroupTest02{
    //start all thread together, not serial
    private let queueConc = DispatchQueue(label: "Main Queue", attributes: .concurrent)
    
    private let groundBlack = DispatchGroup()
    
    func loadInfo(){
        groundBlack.enter()
        queueConc.async {
            sleep(1)
            print("1")
            self.groundBlack.leave()
        }
        
        groundBlack.enter()
        queueConc.async {
            sleep(2)
            print("2")
            self.groundBlack.leave()
        }
        
        groundBlack.wait()
        print("Finish 1 and 2")
        
        groundBlack.enter()
        queueConc.async {
            sleep(2)
            print("3")
            self.groundBlack.leave()
        }
        groundBlack.wait()
        print("Finish All")
        
        groundBlack.notify(queue: .main){
            print("GroupBlacj all finish")
        }
    }
}

let dispatchGroupTest02 = DispatchGroupTest02()
//dispatchGroupTest02.loadInfo()

// Download pictures
//===================================

class SomeImage: UIView {
    public var ivs = [UIImageView]()
    
    public override init(frame: CGRect){
        super.init(frame: frame)
        
        //case 1
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 100, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 200, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 300, width: 100, height: 100)))
        
        //case 2
        ivs.append(UIImageView(frame: CGRect(x: 100, y: 0, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 100, y: 100, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 100, y: 200, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 100, y: 300, width: 100, height: 100)))
        
        for i in 0...7{
            ivs[i].contentMode = .scaleAspectFit
            self.addSubview(ivs[i])
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

var view = SomeImage(frame: CGRect(x: 0, y: 0, width: 400, height: 700))
view.backgroundColor = .blue

let imageURLs = ["https://upload.wikimedia.org/wikipedia/ru/8/85/Terminator2poster.jpg",
                 "https://upload.wikimedia.org/wikipedia/ru/c/ca/Terminator_poster.jpg",
                 "https://st.kp.yandex.net/im/poster/3/4/1/kinopoisk.ru-Terminator-2_3A-Judgment-Day-3418179--o--.jpg",
                 "https://cdn22.img.ria.ru/images/15121/14/151211437_0:0:0:0_600x0_80_0_0_dcfd35ff2f79b35cb2f815a0b0317106.jpg"]

var images = [UIImage]()
PlaygroundPage.current.liveView = view


func asyncLoadImage(imageUrl : URL,
                    runQueue: DispatchQueue,
                    completionQueue: DispatchQueue,
                    complition: @escaping(UIImage?, Error?) -> ()){
    
    runQueue.async{
        do{
            let data = try Data(contentsOf: imageUrl)
            completionQueue.async {
                complition(UIImage(data: data), nil)
            }
        }catch let error {
            completionQueue.async {
                complition(nil, error)
            }
        }
    } //as! @convention(block) () -> Void// place with error
}

func asyncGroup(){
    let aGroup = DispatchGroup()
    
    for i in 0...3 {
        aGroup.enter()
        asyncLoadImage(imageUrl: URL(string: imageURLs[i])!,
                       runQueue: .global(),
                       completionQueue: .main) { (result, error) in
            guard let imageData = result else {
                return
            }
            images.append(imageData)
            aGroup.leave()
        }
    }
    
    aGroup.notify(queue: .main){
        for i in 0...3{
            view.ivs[i].image = images[i]
        }
    }
    
}

func asyncUrlSession(){
    for i in 4...7 {
        let url = URL(string: imageURLs[i-4])
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                view.ivs[i].image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}

asyncUrlSession()
//asyncGroup()
