//
//  InvoiceComposer.swift
//  iJournal
//
//  Created by Carlos Javier Pendola on 5/3/19.
//  Copyright © 2019 Carlos Javier Pendola. All rights reserved.
//

import UIKit

class InvoiceComposer: NSObject {
    
    let pathToInvoiceHTMLTemplate = Bundle.main.path(forResource: "invoice", ofType: "html")
    let pathToTextItemHTMLTemplate = Bundle.main.path(forResource: "text_item", ofType: "html")
    let pathToImageItemHTMLTemplate = Bundle.main.path(forResource: "image_item", ofType: "html")
    let senderInfo = "Gabriel Theodoropoulos<br>123 Somewhere Str.<br>10000 - MyCity<br>MyCountry"
    let dueDate = ""
    let paymentMethod = "Wire Transfer"
    
    let logoImageURL = "https://firebasestorage.googleapis.com/v0/b/ijournal-b3c03.appspot.com/o/Icon-120.png?alt=media&token=1cae82bd-5079-42a5-bd38-d2f3a9bd49aa"
    
    //let logoImageURL = "http://www.appcoda.com/wp-content/uploads/2015/12/blog-logo-dark-400.png"
    
    //let logoImageURL = "https://files.catbox.moe/z6gesi.png"
    
    var pdfFilename: String!
    
    override init() {
        super.init()
    }
    
    
    func renderInvoice(entry:Entry) -> String! {
        // Store the invoice number for future use.
        
        do {
            // Load the invoice HTML template code into a String variable.
            var HTMLContent = try String(contentsOfFile: pathToInvoiceHTMLTemplate!)
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#LOGO_IMAGE#", with: logoImageURL)
            HTMLContent = HTMLContent.replacingOccurrences(of: "#TITLE_ENTRY#", with: entry.title)
            var allItems = ""
            
            for element in entry.content {
                var itemHTMLContent: String!
                
                // Determine the proper template file.
                var contentItem :String = ""
                if element.file  == .image {
                    itemHTMLContent  = try String(contentsOfFile: pathToImageItemHTMLTemplate!)
                    contentItem = element.info as! String
                }
                else if element.file  == .text {
                    itemHTMLContent  = try String(contentsOfFile: pathToTextItemHTMLTemplate!)
                    contentItem = element.info as! String
                }
                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#CONTENT_ITEM#", with:contentItem)
                allItems += itemHTMLContent
            }
            
            // Set the items.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#ITEMS#", with: allItems)
            
            // The HTML code is ready.
            return HTMLContent
            
        }
        catch {
            print("Unable to open and use HTML template files.")
        }
        
        return nil
    }
    
    
    func exportHTMLContentToPDF(HTMLContent: String) {
        let printPageRenderer = CustomPrintPageRenderer()
        
        let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        
        let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer: printPageRenderer)
        
        pdfFilename = "\(AppDelegate.getAppDelegate().getDocDir())/Invoice.pdf"
        pdfData?.write(toFile: pdfFilename, atomically: true)
        
        dump(pdfFilename)
    }
    
    func drawPDFUsingPrintPageRenderer(printPageRenderer: UIPrintPageRenderer) -> NSData! {
        let data = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
        for i in 0..<printPageRenderer.numberOfPages {
            UIGraphicsBeginPDFPage()
            printPageRenderer.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }
        
        UIGraphicsEndPDFContext()
        return data
    }
}

