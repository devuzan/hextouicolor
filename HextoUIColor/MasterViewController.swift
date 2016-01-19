//
//  MasterViewController.swift
//  HextoUIColor
//
//  Created by Yusuf U. on 16/01/16.
//  Copyright © 2016 Yusuf U. All rights reserved.
//

import Cocoa

class MasterViewController: NSViewController,NSTextFieldDelegate{
    
    //MARK: - Properties.
    
    let firstCharacter:Character = "#"

    
    //MARK: - IBOutlets
    
    @IBOutlet weak var labelPreview: NSTextField!
    @IBOutlet weak var buttonObjcCopy: NSButton!
    @IBOutlet weak var buttonSwiftCopy: NSButton!
    @IBOutlet weak var textFieldObjc: NSTextField!
    @IBOutlet weak var textFieldSwift: NSTextField!
    @IBOutlet weak var iconObjc: NSImageView!
    @IBOutlet weak var iconSwift: NSImageView!
    @IBOutlet weak var colorView: NSView!
    @IBOutlet weak var hexTextField: NSTextField!
    
    
    //MARK: IBActions
    
    @IBAction func actionObjcCopy(sender: AnyObject) {
        
        NSPasteboard.generalPasteboard().clearContents()
        NSPasteboard.generalPasteboard().setString(textFieldObjc.stringValue, forType: NSStringPboardType)
        
        sendNotification("Copied!")
        
    }
    
    
    @IBAction func actionSwiftCopy(sender: AnyObject) {
        
        //when copy button clicked, copied to pana from fieldString
        
        NSPasteboard.generalPasteboard().clearContents()
        NSPasteboard.generalPasteboard().setString(textFieldSwift.stringValue, forType: NSStringPboardType)
        sendNotification("Copied!")
        
    }

    //MARK: - Settings methods.
    
    func firstInitial(){
        
        iconSwift.hidden = true
        iconObjc.hidden = true
        colorView.hidden = true
        labelPreview.hidden = true
        textFieldSwift.hidden = true
        textFieldObjc.hidden = true
        buttonObjcCopy.hidden = true
        buttonSwiftCopy.hidden = true
        hexTextField.delegate = self
        self.view.wantsLayer = true

    }
    
    func reset(){
        
        colorView.hidden = true
        colorView.layer?.backgroundColor = NSColor.clearColor().CGColor
        iconSwift.hidden = true
        iconObjc.hidden = true
        textFieldSwift.hidden = true
        textFieldObjc.hidden = true
        buttonObjcCopy.hidden = true
        buttonSwiftCopy.hidden = true
        labelPreview.hidden = true
        
    }

    
    //MARK: View methods.

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstInitial()
        // Do view setup here.
    }
    
    //MARK: - TextField Delegate methods.
    
    func control(control: NSControl, textShouldBeginEditing fieldEditor: NSText) -> Bool {
        
        return true
        
    }
    
    
    override func controlTextDidChange(obj: NSNotification) {
        
        if let field = obj.object as? NSTextField{
            
            if field.stringValue.characters.count > 6 && field.stringValue.characters.count < 8 && field.stringValue.characters.first == firstCharacter{
                
                let colorString = field.stringValue
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.changeColorViewWithColor(self.colorWithHexString(colorString))

                })
                
            }else{
                
                reset()
                
            }
        }
    }
    
    //MARK: - Helper methods.

    func changeColorViewWithColor(color: NSColor){

        colorView.hidden = false
        colorView.layer?.backgroundColor = color.CGColor
        iconSwift.hidden = false
        iconObjc.hidden = false
        textFieldSwift.hidden = false
        textFieldObjc.hidden = false
        buttonObjcCopy.hidden = false
        buttonSwiftCopy.hidden = false
        labelPreview.hidden = false
        
        let colorDescription = color.description
        let myStringArray = colorDescription.componentsSeparatedByString(" ")
        
        let floatArray = myStringArray.map{
            
            CGFloat(($0 as NSString).floatValue)
        }
        
        if let result = returnStringWithColors(floatArray[4], g: floatArray[5], b: floatArray[6], a: 1.0) as (String, String)?{
            
            textFieldSwift.stringValue = result.0
            textFieldObjc.stringValue = result.1

        }else {
            
            textFieldObjc.stringValue = "Error!"
            textFieldSwift.stringValue = "Error!"
        }
        
    }
    
    
    func returnStringWithColors(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> (String, String){

        return ("UIColor(red: \(NSString(format: "%.2f", r).floatValue), green: \(NSString(format: "%.2f", g).floatValue), blue: \(NSString(format: "%.2f", b).floatValue), alpha: \(NSString(format: "%.2f", a).floatValue))","[UIColor colorWithRed:\(NSString(format: "%.2f", r).floatValue) green:\(NSString(format: "%.2f", g).floatValue) blue:\(NSString(format: "%.2f", b).floatValue) alpha:\(NSString(format: "%.2f", a).floatValue)];")
    }
    

    func colorWithHexString (hex:String) -> NSColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return NSColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return NSColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
        

    }
    
    func sendNotification(message: String){
        
        let notificationCenter = NSUserNotification()
        notificationCenter.title = "Hex to Color says:"
        notificationCenter.informativeText = message
        notificationCenter.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notificationCenter)
        
    }
    
}