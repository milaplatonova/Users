//
//  DetailedViewController.swift
//  Users
//
//  Created by Lyudmila Platonova on 18.08.21.
//

import UIKit
import MessageUI

class DetailedViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UINavigationItem!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var address1Label: UILabel!
    @IBOutlet weak var address2Label: UILabel!
    @IBOutlet weak var address3Label: UILabel!
    @IBOutlet var contactButtons: [UIButton]!
    
    var selectedUser = User(title: "", name: "", surname: "", dob: "", street: "", building: "", postcode: "", city: "", state: "", country: "", phone: "", cell: "", email: "", thumbnailImage: "", mediumImage: "", largeImage: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.configureGradientBackground(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.6369693225, green: 0.8708638103, blue: 0.7402992324, alpha: 1), #colorLiteral(red: 0.5733122256, green: 0.8107450601, blue: 0.9764705896, alpha: 1))
        titleLabel.title = selectedUser.fullName
        adjustView()
        
        
        for button in contactButtons {
            button.layer.cornerRadius = 8.0
            button.backgroundColor = #colorLiteral(red: 0.1939297679, green: 0.5451529899, blue: 0.7774620556, alpha: 1)
            button.layer.borderWidth = 1.5
            button.layer.borderColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
            button.setTitleColor(#colorLiteral(red: 0.6425400734, green: 0.8892919367, blue: 0.7576688043, alpha: 1), for: .normal)
            let title: String
            switch button.tag {
            case 0:
                title = "✉️ " + selectedUser.email
            case 1:
                title = "📱 " + selectedUser.cell
            case 2:
                title = "☎️ " + selectedUser.phone
            default:
                title = ""
            }
            button.setTitle(title, for: .normal)
        }
        
        guard let url = URL(string: selectedUser.largeImage) else { return }
        if let data = try? Data(contentsOf: url) {
            userImage.image = UIImage(data: data)
        }
        nameLabel.text = selectedUser.title + " " + selectedUser.fullName
        dobLabel.text = convertDateFormater(date: selectedUser.dob)
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        adjustView()
    }
    
    func adjustView() {
        var windowInterfaceOrientation: UIInterfaceOrientation? {
            if #available(iOS 13.0, *) {
                return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
            } else {
                return UIApplication.shared.statusBarOrientation
            }
        }
        if UIDevice.current.orientation.isLandscape || UIDevice.current.userInterfaceIdiom == .pad {
            address1Label.text = selectedUser.street + " " + selectedUser.building + ", " + selectedUser.postcode + " " + selectedUser.city + ", " + selectedUser.state + ", " + selectedUser.country
            address1Label.textAlignment = .center
            address2Label.isHidden = true
            address3Label.isHidden = true
            
        } else {
            address1Label.text = selectedUser.street + " " + selectedUser.building + ","
            address1Label.textAlignment = .left
            address2Label.text = selectedUser.postcode + " " + selectedUser.city + ", " + selectedUser.state + ","
            address3Label.text = selectedUser.country
            address2Label.isHidden = false
            address3Label.isHidden = false
        }
    }
    
    func convertDateFormater(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let date = dateFormatter.date(from: date) else {
            assert(false, "no date from string")
            return ""
        }
        
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
    }
    
    func alertMessage (_ sender: UIButton, _ withMessage: String) {
        let title: String
        let actions: [UIAlertAction]
        switch sender.tag {
        case 0:
            title = ""
            let yes = UIAlertAction(title: "Yes", style: .default, handler: { action in
                self.sendEmail()
            })
            let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
            actions = [yes, no]
        case 1:
            title = "Please, choose the option"
            let call = UIAlertAction(title: "Make a call", style: .default, handler: { action in
                self.makeCall(self.selectedUser.cell)
            })
            let message = UIAlertAction(title: "Send a message", style: .default, handler: { action in
                self.sendMessage()
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            actions = [call, message, cancel]
        default:
            title = "Error"
            actions = []
        }
        let alert = UIAlertController(title: title, message: withMessage, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func errorAlert (_ withMessage: String) {
        let alert = UIAlertController(title: "Error", message: withMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sendEmailAction(_ sender: UIButton) {
        alertMessage(sender, "Do you want to send an e-mail to " + selectedUser.title + " " + selectedUser.fullName + "?")
    }
    
    @IBAction func cellCallAction(_ sender: UIButton) {
        alertMessage(sender, "Do you want to send a message to " + selectedUser.title + " " + selectedUser.fullName + " or to make a call?")
    }
    
    @IBAction func phoneCallAction(_ sender: UIButton) {
        makeCall(selectedUser.phone)
    }
    
    func makeCall (_ phone: String) {
        let number = phone.filter("0123456789".contains)
        if let url = URL(string: ("tel:" + number)) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                errorAlert("Calls are not available on this device.")
            }
        }
    }
    
    func sendMessage() {
        if MFMessageComposeViewController.canSendText() {
            let message = MFMessageComposeViewController()
            message.messageComposeDelegate = self
            message.recipients = [selectedUser.cell.filter("0123456789".contains)]
            message.body = "Hello " + selectedUser.title + " " + selectedUser.fullName + "!"
            present(message, animated: true, completion: nil)
        } else {
            errorAlert("Messaging is not available on this device.")
        }
    }
    
    func sendEmail() {
        let recipientEmail = selectedUser.email
        let subject = "Greeting"
        let body = "Hello " + selectedUser.title + " " + selectedUser.fullName + "!"
        
        // Using default mail composer:
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)
            present(mail, animated: true)
            
            // Using third party mail composer if default Mail app is not present:
        } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
            if UIApplication.shared.canOpenURL(emailUrl) {
                UIApplication.shared.open(emailUrl)
            } else {
                print("Can't open URL on this device.")
                errorAlert("Emailing is not available on this device. Please, install a Mail App.")
            }
            
        }
    }
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        
        return defaultUrl
    }
    
    
}

