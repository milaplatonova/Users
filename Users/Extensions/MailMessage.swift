//
//  MailMessage.swift
//  Users
//
//  Created by Lyudmila Platonova on 4.10.21.
//

import Foundation
import MessageUI

extension DetailedViewController: MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
