//
//  ViewController.swift
//  QRGenerator
//
//  Created by Eugene Bokhan on 10/1/17.
//  Copyright © 2017 Eugene Bokhan. All rights reserved.
//

import Cocoa
import Quartz

class ViewController: NSViewController, NSTextFieldDelegate {
    
    // MARK - UI Elemants
    
    @IBOutlet weak var qrTextField: NSTextField!
    @IBOutlet weak var qrSizeTextField: NSTextField!
    @IBOutlet weak var qrImageView: NSImageView!
    @IBOutlet weak var pathLabel: NSTextField!
    
    // MARK - Interface Actions
    
    
    @IBAction func selectPathAction(_ sender: NSButton) {
        let panel = openPanel()
        let clicked = panel.runModal()
        
        if clicked.rawValue == NSApplication.ModalResponse.OK.rawValue {
            for url in panel.urls {
                pathLabel.stringValue = url.path
            }
        }
    }
    
    @IBAction func generatePDFAction(_ sender: NSButton) {
        if qrTextField.stringValue == "" || pathLabel.stringValue == "" || qrSizeTextField.stringValue == ""  {
            showMessagePopup(message: "Type some text for encriprion, choose qr size and select folder to save")
        } else {
            let pdfDocument = PDFDocument()
            
            let coverPage = QRPDFPage(hasMargin: true,
                                         qrText: "\(qrTextField.stringValue)",
                                         qrWidth: CGFloat(qrSizeTextField.intValue),
                                         qrHeight: CGFloat(qrSizeTextField.intValue),
                                         creditInformation: "Created By: Eugene Bokhan",
                                         headerText: "Taqtile",
                                         footerText: "www.taqtile.com",
                                         pageWidth: 900.0,
                                         pageHeight: 1200.0,
                                         hasPageNumber: true,
                                         pageNumber: 1)
     
            pdfDocument.insert(coverPage, at: 0)
            
            let pdfPath = "\(pathLabel.stringValue)/\(qrTextField.stringValue).pdf"
            
            pdfDocument.write(toFile: pdfPath)
            
        }
    }
    
    // MARK - Properties
    
    let generator = QRCodeGenerator()
    var previousStringValue: String!
    
    // MARK - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func setupUI() {        
        let onlyIntFormatter = OnlyIntegerValueFormatter()
        qrSizeTextField.formatter = onlyIntFormatter
        qrTextField.delegate = self
        pathLabel.stringValue = ""
        qrImageView.image = #imageLiteral(resourceName: "ManifestLogo")
    }
    
    // MARK - Text field Delegate Methods
    
    override func controlTextDidChange(_ obj: Notification) {
        if qrTextField.stringValue.count > 13 {
            qrTextField.stringValue = previousStringValue
        } else {
            previousStringValue = qrTextField.stringValue
        }
        if qrTextField.stringValue == "" {
            qrImageView.image = #imageLiteral(resourceName: "ManifestLogo")
        } else {
            qrImageView.image = generator.createImage(value: "\(qrTextField.stringValue)", size: CGSize(width: 1000, height: 1000))
        }
    }
    
    func openPanel() -> NSOpenPanel {
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        return openPanel
    }
    
    func showMessagePopup(message: String) {
        let messagePopup: NSAlert = NSAlert()
        messagePopup.messageText = message
        messagePopup.alertStyle = .warning
        messagePopup.addButton(withTitle: "OK")
        messagePopup.runModal()
    }
    
}
