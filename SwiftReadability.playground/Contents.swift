import PlaygroundSupport
import SwiftReadability
import UIKit
import XCPlayground

class SampleViewController: ReadabilityViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
    }
}

let sampleVC = SampleViewController()
PlaygroundPage.current.liveView = sampleVC.view