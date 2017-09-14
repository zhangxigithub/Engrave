//
//  ViewController.swift
//  engrave
//
//  Created by zhangxi on 31/08/2017.
//  Copyright © 2017 zhangxi. All rights reserved.
//

import Cocoa
import CoreBluetooth
import CoreImage




class ViewController: NSViewController,EngraveRobotDelegate{

    var svg : SVG?
    var robot : EngraveRobot!
    var converter : Converter?
    
    @IBOutlet weak var preview: NSImageView!
    @IBOutlet var logView: NSTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("~~~~")
        print(String(UnicodeScalar(UInt8(1))))
        print(String(UnicodeScalar(UInt8(255))))
        //self.connectRobot("")
    }


    @IBAction func connectRobot(_ sender: Any) {
        robot = EngraveRobot()
        robot.delegate = self
        robot.connect()
        

    }
    
    func didReceviveMessgae(message: String) {
        self.logView.string = (self.logView.string ?? "") + message + "\n"
        
        
        
        if message == "linefinish" && line < 50
        {
            var dot = converter?.colorArray[line]
            if line % 2 == 1
            {
                dot?.reverse()
            }
            
            var ins = "r" + ((line % 2 == 1) ? "1" : "0")
            for c in dot!
            {
                print(c)
                ins += String(Int(c))
                    //String(format:"%3d",c)
            }
            ins += "#"
            robot.send(message: ins)
            //robot.send(message: "r0111#")
            line += 1
        }
        

        
        
    }
    func didConnected() {
        
    }
    func didDisconnected() {
        
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        
        robot.send(message: "m02000020000#")

        
        //robot.send(message:"hah")
    }
    
    
    
    
    
    
    
    @IBAction func importImage(_ sender: Any) {
        
        
        let panel = NSOpenPanel()
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.message = "select *.svg file."
        panel.beginSheetModal(for: self.view.window!) { (result) in
            //print("finish ....")
            
            if panel.url != nil
            {
                self.converter = Converter(path: panel.url!)
             
                //print(self.converter!.originImage.size)
                //print(self.converter!.resizedImage.size)
                //print(self.converter!.filteredImage.size)
                
                self.preview.image = self.converter!.originImage
                print(self.converter!.colorArray[0])
                //self.preview.image = self.converter!.filteredImage
            }
        }
    }
    
    
    
    
    @IBAction func importSVG(_ sender: Any)
    {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.message = "select *.svg file."
        panel.beginSheetModal(for: self.view.window!) { (result) in
            //print("finish ....")
            
            if panel.url != nil
            {
                self.svg = SVG(url: panel.url!, finish: { (svg) in
                    
                    print(svg.pathes)
                })
            }
        }
    }
    
    
    var line = 0
    
    @IBAction func engrave(_ sender: Any) {
        print(self.svg?.pathes ?? "")
        
        
        
        self.didReceviveMessgae(message: "linefinish")
        
        
        
    }

    
    @IBAction func move(_ sender: NSButton) {
        
        
        switch sender.tag
        {
        case 1: robot.send(message: "x0#")
        case 2: robot.send(message: "x1#")
        case 3: robot.send(message: "y0#")
        case 4: robot.send(message: "y1#")
        default:break;
        }
        print(sender);
        
        self.robot.move(to: CGPoint.zero)
        
    }
    
    @IBAction func laser(_ sender: Any) {
        robot.isLaserOn = true
    }
    
    
    @IBAction func off(_ sender: Any) {
        robot.isLaserOn = false
    }
    
    @IBAction func laserChanged(_ sender: NSSlider) {
        //print(sender.intValue)
        robot.laser(value: Int(sender.intValue))
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

