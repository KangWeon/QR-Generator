//
//  PDFGenerator.swift
//  QRGenerator
//
//  Created by Eugene Bokhan on 10/1/17.
//  Copyright © 2017 Eugene Bokhan. All rights reserved.
//

import Cocoa
import Quartz

let defaultRowHeight  = CGFloat(23.0)
let defaultColumnWidth = CGFloat(150.0)
let numberOfRowsPerPage = 50

let topMargin = CGFloat(40.0)
let leftMargin = CGFloat(20.0)
let rightMargin = CGFloat(20.0)
let bottomMargin = CGFloat (40.0)
let textInset = CGFloat(5.0)
let verticalPadding = CGFloat (10.0)

class BasePDFPage :PDFPage{
    
    var hasMargin = true
    var headerText = "Default Header Text"
    var footerText = "Default Footer Text"
    
    var hasPageNumber = true
    var pageNumber = 1
    
    var pdfHeight = CGFloat(1024.0) //This is configurable
    var pdfWidth = CGFloat(768.0)   //This is configurable and is calculated based on the number of columns
    
    func drawLine( _ fromPoint:NSPoint,  toPoint:NSPoint){
        let path = NSBezierPath()
        NSColor.lightGray.set()
        path.move(to: fromPoint)
        path.line(to: toPoint)
        path.lineWidth = 0.5
        path.stroke()
        
    }
    
    func drawHeader(){
        let headerTextX = leftMargin
        let headerTextY = self.pdfHeight - CGFloat(35.0)
        let headerTextWidth = self.pdfWidth - leftMargin - rightMargin
        let headerTextHeight = CGFloat(20.0)
        
        let headerFont = NSFont(name: "Helvetica", size: 15.0)
        
        let headerParagraphStyle = NSMutableParagraphStyle()
        headerParagraphStyle.alignment = .right
        
        let headerFontAttributes = [
            NSAttributedStringKey.font: headerFont ?? NSFont.labelFont(ofSize: 12),
            NSAttributedStringKey.paragraphStyle:headerParagraphStyle,
            NSAttributedStringKey.foregroundColor:NSColor.lightGray
        ]
        let headerRect = NSMakeRect(headerTextX, headerTextY, headerTextWidth, headerTextHeight)
        self.headerText.draw(in: headerRect, withAttributes: headerFontAttributes)
        
    }
    
    func drawFooter(){
        let footerTextX = leftMargin
        let footerTextY = CGFloat(15.0)
        let footerTextWidth = self.pdfWidth / 2.1
        let footerTextHeight = CGFloat(20.0)
        
        let footerFont = NSFont(name: "Helvetica", size: 15.0)
        
        let footerParagraphStyle = NSMutableParagraphStyle()
        footerParagraphStyle.alignment = .left
        
        let footerFontAttributes = [
            NSAttributedStringKey.font: footerFont ?? NSFont.labelFont(ofSize: 12),
            NSAttributedStringKey.paragraphStyle:footerParagraphStyle,
            NSAttributedStringKey.foregroundColor:NSColor.lightGray
        ]
        
        let footerRect = NSMakeRect(footerTextX, footerTextY, footerTextWidth, footerTextHeight)
        self.footerText.draw(in: footerRect, withAttributes: footerFontAttributes)
        
    }
    
    func drawMargins(){
        let borderLine = NSMakeRect(leftMargin, bottomMargin, self.pdfWidth - leftMargin - rightMargin, self.pdfHeight - topMargin - bottomMargin)
        NSColor.gray.set()
        borderLine.frame(withWidth: 0.5)
    }
    
    func drawPageNumbers()
    {
        
        let pageNumTextX = self.pdfWidth/2
        let pageNumTextY = CGFloat(15.0)
        let pageNumTextWidth = CGFloat(40.0)
        let pageNumTextHeight = CGFloat(20.0)
        
        let pageNumFont = NSFont(name: "Helvetica", size: 15.0)
        
        let pageNumParagraphStyle = NSMutableParagraphStyle()
        pageNumParagraphStyle.alignment = .center
        
        let pageNumFontAttributes = [
            NSAttributedStringKey.font: pageNumFont ?? NSFont.labelFont(ofSize: 12),
            NSAttributedStringKey.paragraphStyle:pageNumParagraphStyle,
            NSAttributedStringKey.foregroundColor: NSColor.darkGray
        ]
        
        let pageNumRect = NSMakeRect(pageNumTextX, pageNumTextY, pageNumTextWidth, pageNumTextHeight)
        let pageNumberStr = "\(self.pageNumber)"
        pageNumberStr.draw(in: pageNumRect, withAttributes: pageNumFontAttributes)
        
    }
    
    override func bounds(for box: PDFDisplayBox) -> NSRect
    {
        return NSMakeRect(0, 0, pdfWidth, pdfHeight)
    }
    
    override func draw(with box: PDFDisplayBox) {
        if hasPageNumber{
            self.drawPageNumbers()
        }
        if hasMargin{
            self.drawMargins()
        }
        if headerText.characters.count > 0 {
            self.drawHeader()
        }
        if footerText.characters.count > 0{
            self.drawFooter()
        }
    }
    
    init(hasMargin:Bool,
         headerText:String,
         footerText:String,
         pageWidth:CGFloat,
         pageHeight:CGFloat,
         hasPageNumber:Bool,
         pageNumber:Int)
    {
        super.init()
        self.hasMargin = hasMargin
        self.headerText = headerText
        self.footerText = footerText
        self.pdfWidth = pageWidth
        self.pdfHeight = pageHeight
        self.hasPageNumber = hasPageNumber
        self.pageNumber = pageNumber
    }
    
}

class QRPDFPage: BasePDFPage{
    var pdfTitle:NSString = "Default PDF Title"
    var creditInformation = "Default Credit Information"
    var pdfTitleImage: NSImage = NSImage()
    var qrText: String!
    var qrWidth: CGFloat!
    var qrHeight: CGFloat!
    var cutLineX: CGFloat!
    var cutLineY: CGFloat!
    
    init(hasMargin:Bool,
         qrText: String,
         qrWidth: CGFloat,
         qrHeight: CGFloat,
         creditInformation: String,
         headerText: String,
         footerText: String,
         pageWidth: CGFloat,
         pageHeight: CGFloat,
         hasPageNumber: Bool,
         pageNumber: Int)
    {
        super.init(hasMargin: hasMargin,
                   headerText: headerText,
                   footerText: footerText,
                   pageWidth: pageWidth,
                   pageHeight: pageHeight,
                   hasPageNumber: hasPageNumber,
                   pageNumber: pageNumber)
        
        self.pdfTitle = qrText as NSString
        self.creditInformation = creditInformation
        self.qrText = qrText
        self.qrWidth = qrWidth
        self.qrHeight = qrHeight
        self.hasPageNumber = false
    }
    
    func drawPDFTitle()
    {
        let scaleFactor = CGFloat(1.13)
        let pdfTitleImageWidth = self.qrWidth * (self.pdfWidth / 210) * scaleFactor
        let pdfTitleImageHeight = self.qrHeight * (self.pdfHeight / 297) * scaleFactor
        let pdfTitleImageX = (self.pdfWidth - pdfTitleImageWidth) / 2
        let pdfTitleImageY = (self.pdfHeight - pdfTitleImageHeight) / 2
        
        let pdfTitleWidth = pdfTitleImageWidth
        let pdfTitleHeight = pdfTitleImageHeight
        let pdfTitleX = pdfTitleImageX
        let pdfTitleY = pdfTitleImageY - pdfTitleImageHeight - 20
        
        let titleFont = NSFont(name: "Helvetica Bold", size: 22.0)
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center
        
        let titleFontAttributes = [
            NSAttributedStringKey.font: titleFont ?? NSFont.labelFont(ofSize: 12),
            NSAttributedStringKey.paragraphStyle:titleParagraphStyle,
            NSAttributedStringKey.foregroundColor: NSColor.black
        ]
        
        let titleImageRect = NSMakeRect(pdfTitleImageX, pdfTitleImageY, pdfTitleImageWidth, pdfTitleImageHeight)
        let generator = QRCodeGenerator()
        self.pdfTitleImage = generator.createImage(value: self.pdfTitle as String, size: CGSize(width: pdfTitleImageWidth, height: pdfTitleImageHeight))!
        self.pdfTitleImage.draw(in: titleImageRect)
        let titleRect = NSMakeRect(pdfTitleX, pdfTitleY, pdfTitleWidth, pdfTitleHeight)
        self.pdfTitle.draw(in: titleRect, withAttributes: titleFontAttributes)
        
        self.cutLineX = pdfTitleImageX - 30
        self.cutLineY = pdfTitleImageY - 70
        
        let cutLine = NSMakeRect(self.cutLineX, self.cutLineY , pdfTitleImageWidth + 60, pdfTitleImageHeight + 100)
        NSColor.gray.set()
        cutLine.frame(withWidth: 0.5)
    }
    
    func drawPDFCreditInformation()
    {
        let pdfCreditX = 1/4 * self.pdfWidth
        let pdfCreditY = self.cutLineY - 50
        let pdfCreditWidth = 1/2 * self.pdfWidth
        let pdfCreditHeight = CGFloat(40.0)
        let creditFont = NSFont(name: "Helvetica", size: 15.0)
        
        let creditParagraphStyle = NSMutableParagraphStyle()
        creditParagraphStyle.alignment = .center
        
        let creditFontAttributes = [
            NSAttributedStringKey.font: creditFont ?? NSFont.labelFont(ofSize: 12),
            NSAttributedStringKey.paragraphStyle:creditParagraphStyle,
            NSAttributedStringKey.foregroundColor: NSColor.darkGray
        ]
        
        let creditRect = NSMakeRect(pdfCreditX, pdfCreditY, pdfCreditWidth, pdfCreditHeight)
        self.creditInformation.draw(in: creditRect, withAttributes: creditFontAttributes)
        
    }
    
    override func draw(with box: PDFDisplayBox) {
        super.draw(with: box)
        self.drawPDFTitle()
        self.drawPDFCreditInformation()
    }
    
    
}

