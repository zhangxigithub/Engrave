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
    
    @IBOutlet weak var preview: NSImageView!
    @IBOutlet var logView: NSTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //robot = EngraveRobot()
        //robot.delegate = self
        //robot.connect()
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
    
    
    
    
    
    @IBAction func importImage(_ sender: Any) {
        
        
        let panel = NSOpenPanel()
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.message = "select *.svg file."
        panel.beginSheetModal(for: self.view.window!) { (result) in
            //print("finish ....")
            
            if panel.url != nil
            {
                if let image = CIImage(contentsOf: panel.url!)
                {
                
                    let f = CIFilter( name: "CILineOverlay", withInputParameters:[kCIInputImageKey:image])
                    

                    /*
                     
                     [f setValue:[NSNumber numberWithFloat:yscale]
                     forKey:@"inputScale"];
                     */
                    let i = f?.value(forKeyPath: kCIOutputImageKey) as! CIImage
                    
                    
                    
                    let f2 = CIFilter(name: "CILanczosScaleTransform", withInputParameters: [kCIInputImageKey:i])
                    
                    f2?.setValue(0.3, forKey: kCIInputScaleKey)
                    
                    let i2 = f2?.value(forKeyPath: kCIOutputImageKey) as! CIImage
                    
                    let r = NSBitmapImageRep(ciImage: i2)
                    print(r.size)
                    print(r.colorAt(x: 10, y: 10))
    
                    
                    /*
                     
                     CIImage * resultimg=[lineFilter valueForKey:kCIOutputImageKey];
                     
                     
                     NSBitmapImageRep* rep = [[NSBitmapImageRep alloc] initWithCIImage:resultimg];
                     
                     NSData *pngdata = [rep representationUsingType:NSPNGFileType properties:nil];
                     self.imgView.image=[[NSImage alloc] initWithData:pngdata];
                     */
                    
                    let ciImage = image.applyingFilter("CILineOverlay", withInputParameters:
                        ["inputThreshold":0.1])
                    print(ciImage)
                    
                    let cgImage = CIContext(options: nil).createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: 1000, height: 1000))
                    //convert cgImage to 500*500px
                    
                    let nsImage = NSImage(cgImage:cgImage! ,size: NSSize(width:100, height:100))
                    
                    self.preview.image = nsImage;

                    
                    
                    let rep = NSBitmapImageRep(cgImage: cgImage!)
                    
                    
                    print(rep.size)
                    
                    print(rep.colorAt(x: 100, y: 100))

                }
                

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
        robot.isLaserOn = true
    }
    
    
    @IBAction func off(_ sender: Any) {
        robot.isLaserOn = false
    }
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

