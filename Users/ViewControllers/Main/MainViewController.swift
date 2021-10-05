//
//  ViewController.swift
//  Users
//
//  Created by Lyudmila Platonova on 26.05.21.
//

import UIKit

class MainViewController: UIViewController {

    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet var buttons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.orientation.isLandscape {
            backgroundImage.image = UIImage(named: "users_h")
        } else {
            backgroundImage.image = UIImage(named: "users_v")
        }
        
        for button in buttons {
            button.layer.cornerRadius = 8.0
            button.backgroundColor = #colorLiteral(red: 0.1939297679, green: 0.5451529899, blue: 0.7774620556, alpha: 1)
            button.layer.borderWidth = 1.5
            button.layer.borderColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
            button.setTitleColor(#colorLiteral(red: 0.6425400734, green: 0.8892919367, blue: 0.7576688043, alpha: 1), for: .normal)
        }
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            backgroundImage.image = UIImage(named: "users_h")
        } else {
            backgroundImage.image = UIImage(named: "users_v")
        }
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        var nextViewController = ""
        if sender.tag == 0 {
            nextViewController = "TableViewController"
        } else {
            nextViewController = "CollectionViewController"
        }
        
        let storyboard = UIStoryboard(name: nextViewController, bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: nextViewController)
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.navigationController!.pushViewController(vc, animated: true)
    }

}

