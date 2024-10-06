import SwiftUI
import MessageUI

class MailHelper: NSObject, MFMailComposeViewControllerDelegate {
    static let shared = MailHelper()
    
    private override init() {}
    
    func sendEmail(subject: String, body: String, to: String) {
        guard MFMailComposeViewController.canSendMail() else {
            print("Cannot send mail")
            return
        }
        
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
        mailComposeViewController.setToRecipients([to])
        mailComposeViewController.setSubject(subject)
        mailComposeViewController.setMessageBody(body, isHTML: false)
        
        MailHelper.getRootViewController()?.present(mailComposeViewController, animated: true, completion: nil)
    }
    
    static func getRootViewController() -> UIViewController? {
        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return nil }
        guard let firstWindow = firstScene.windows.first else { return nil }
        return firstWindow.rootViewController
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            print("Email sent.")
        case .cancelled:
            print("Email cancelled.")
        case .failed:
            print("Failed to send email.")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
