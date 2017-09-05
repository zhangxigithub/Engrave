//
//  ViewController.swift
//  engrave
//
//  Created by zhangxi on 31/08/2017.
//  Copyright © 2017 zhangxi. All rights reserved.
//

import Cocoa
import CoreBluetooth




class ViewController: NSViewController,EngraveRobotDelegate{

    var svg : SVG?
    var robot : EngraveRobot!
    
    @IBOutlet var logView: NSTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        robot = EngraveRobot()
        robot.delegate = self
        robot.connect()
    }


    @IBAction func connectRobot(_ sender: Any) {
//        robot = EngraveRobot()
//        robot.connect()
    }
    
    func didReceviveMessgae(message: String) {
        self.logView.string = (self.logView.string ?? "") + message + "\n"
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        
        robot.send(message: "m02000020000#")

        
        //robot.send(message:"hah")
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
    
    @IBAction func engrave(_ sender: Any) {
        print(self.svg?.pathes ?? "")
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
        robot.send(message: "l1#")
    }
    
    
    @IBAction func off(_ sender: Any) {
        robot.send(message: "l0#")
    }
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

