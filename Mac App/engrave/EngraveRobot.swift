//
//  File.swift
//  engrave
//
//  Created by zhangxi on 31/08/2017.
//  Copyright © 2017 zhangxi. All rights reserved.
//

import Foundation
import ORSSerial

/*
 m[000][000][0/1]
 x[0/1]
 y[0/1]
 
 
 
 */

class EngraveRobot : NSObject, ORSSerialPortDelegate {

    
    var serialPort : ORSSerialPort?

    
    var isLaserOn : Bool = false
    {
        didSet{
            if isLaserOn
            {
            }else
            {
            }
        }
    }
    

    func move(to point:CGPoint)
    {
    }
    
    
    
    
    //MARK: - serial port
    
    func connect()
    {
        serialPort = ORSSerialPort(path: "/dev/cu.usbmodem1411")
        serialPort?.delegate = self
        serialPort?.baudRate = 9600
        serialPort?.open()
        //serialPort.sendData(someData) // someData is an NSData object
        //serialPort.close() // Later, when you're done with the port
    }

    
    
    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        print("opened")
        //self.openCloseButton.title = "Close"
    }
    
    func serialPortWasClosed(_ serialPort: ORSSerialPort) {
        print("closed")
    }
    
    func serialPort(_ serialPort: ORSSerialPort, didReceive data: Data) {
        print("didReceive")
        
        //if
            if let string = String(data: data, encoding: String.Encoding.utf8)
            {
            print(string)
        }

    }
    
    func serialPortWasRemoved(fromSystem serialPort: ORSSerialPort) {
        //self.serialPort = nil
        //self.openCloseButton.title = "Open"
    }
    
    func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error) {
        print("SerialPort \(serialPort) encountered an error: \(error)")
    }


    
    
    
    func send(message:String)
    {
        if let data = message.data(using: String.Encoding.utf8)
        {
            serialPort?.send(data)
        }
    }

}









