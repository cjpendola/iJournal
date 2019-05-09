//
//  ExportViewController.swift
//  iJournal
//
//  Created by Carlos Javier Pendola on 5/3/19.
//  Copyright © 2019 Carlos Javier Pendola. All rights reserved.
//

import UIKit
import MessageUI

class ExportViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet weak var webPreview: UIWebView!
    
    var invoiceInfo: [String: AnyObject]!
    var invoiceComposer: InvoiceComposer!
    var HTMLContent: String!
    //lazy var mailComposeViewController = MFMailComposeViewController()

    
    var entry:Entry?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "showExportMenu"), object: nil)
        
        self.createInvoiceAsHTML()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: IBAction Methods
    @IBAction func exportToPDF(_ sender: AnyObject) {
        invoiceComposer.exportHTMLContentToPDF(HTMLContent: HTMLContent)
        showOptionsAlert()
    }
    
    
    // MARK: Custom Methods
    
    func createInvoiceAsHTML() {
        invoiceComposer = InvoiceComposer()
        
        if let invoiceHTML = invoiceComposer.renderInvoice(entry:entry!) {
            
            webPreview.loadHTMLString(invoiceHTML, baseURL: NSURL(string: invoiceComposer.pathToInvoiceHTMLTemplate!)! as URL)
            HTMLContent = invoiceHTML
        }
    }
    
    
    
    func showOptionsAlert() {
        let alertController = UIAlertController(title: "Yeah!", message: "Your invoice has been successfully printed to a PDF file.\n\nWhat do you want to do now?", preferredStyle: UIAlertController.Style.alert)
        
        let actionPreview = UIAlertAction(title: "Preview it", style: UIAlertAction.Style.default) { (action) in
            if let filename = self.invoiceComposer.pdfFilename, let url = URL(string: filename) {
                let request = URLRequest(url: url)
                self.webPreview.loadRequest(request)
            }
        }
        
        let actionEmail = UIAlertAction(title: "Send by Email", style: UIAlertAction.Style.default) { (action) in
            DispatchQueue.main.async {
                self.sendEmail()
            }
        }
        
        let actionNothing = UIAlertAction(title: "Nothing", style: UIAlertAction.Style.default) { (action) in
            
        }
        
        alertController.addAction(actionPreview)
        alertController.addAction(actionEmail)
        alertController.addAction(actionNothing)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.setSubject("Invoice")
            mailComposeViewController.mailComposeDelegate = self
            mailComposeViewController.addAttachmentData(NSData(contentsOfFile: invoiceComposer.pdfFilename)! as Data, mimeType: "application/pdf", fileName: "Invoice")
            present(mailComposeViewController, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
