import UIKit
import PlaygroundSupport

var str = "MainQueue"

class QueueTest1 {
    private let serialQueue = DispatchQueue(label: "serialTest")
    private let concurrentQueue = DispatchQueue(label: "concurentTest",  attributes: .concurrent)
    
}


class QueueTest2 {
    private let globalQueue = DispatchQueue.global() // 5 entity
    private let mainQueue = DispatchQueue.main
    
}

//=================
var str1 = "GCD"

class TestViewController: UIViewController {
    
    var button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "vc 1"
        view.backgroundColor = .white
        
        button.addTarget(self, action: #selector(pressAction), for: .touchUpInside)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        initButton()
        
    }
    
    func initButton() {
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = view.center
        button.setTitle("Press", for: .normal)
        
        button.layer.cornerRadius = 10
        
        button.backgroundColor = .green
        button.setTitleColor(UIColor.white, for: .normal)
        
        view.addSubview(button)
    }
    
    @objc
    func pressAction(){
        print ("Button pressed")
        let vc = TestViewControllerV2()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

class TestViewControllerV2: UIViewController {
    
    var image = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("vc 2 viewDidLoad")
        
        self.title = "vc 2"
        view.backgroundColor = .red
        
        
        
//        let imageUrl: URL = URL(string: "https://upload.wikimedia.org/wikipedia/ru/8/85/Terminator2poster.jpg")!
//
//        if let data = try? Data(contentsOf: imageUrl){
//            print("download data")
//            self.image.image = UIImage(data: data)
//        }else{
//            print("download error")
//        }
        
        
        loadPhoto()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("vc 2 viewDidAppear")
        initImage()
    }
    
    func initImage(){
        print("vc 2 initImage()")
        image.frame  = CGRect(x: 0, y: 0, width: 300, height: 300)
        image.center = view.center
        view.addSubview(image)
    }
    
    func loadPhoto(){
        let imageUrl: URL = URL(string: "https://upload.wikimedia.org/wikipedia/ru/8/85/Terminator2poster.jpg")!
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            if let data = try? Data(contentsOf: imageUrl){
                print("download data")
                DispatchQueue.main.async {
                    self.image.image = UIImage(data: data)
                }
                
            }
        }
        
    }
    
}

let vc = TestViewController()
let navbar = UINavigationController(rootViewController: vc)

PlaygroundPage.current.liveView = navbar


