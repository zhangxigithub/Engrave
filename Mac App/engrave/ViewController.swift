//
//  ViewController.swift
//  engrave
//
//  Created by zhangxi on 31/08/2017.
//  Copyright © 2017 zhangxi. All rights reserved.
//

import Cocoa




class ViewController: NSViewController{

    var svg : SVG?
    var robot : EngraveRobot!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func connectRobot(_ sender: Any) {
        robot = EngraveRobot()
        robot.connect()
    }
    
    
    @IBAction func sendMessage(_ sender: Any) {
        
        robot.send(message:"hah")
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

    
    @IBAction func move(_ sender: Any) {
        self.robot.move(to: CGPoint.zero)
    }
    
    
    
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

