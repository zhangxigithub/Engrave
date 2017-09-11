//
//  File.swift
//  engrave
//
//  Created by zhangxi on 31/08/2017.
//  Copyright © 2017 zhangxi. All rights reserved.
//

import Foundation
import CoreBluetooth

/*
 m[000][000][0/1]
 x[0/1]
 y[0/1]
 
 */

protocol EngraveRobotDelegate
{
    func didConnected()
    func didDisconnected()
    func didReceviveMessgae(message:String)
}
class EngraveRobot : NSObject,CBCentralManagerDelegate,CBPeripheralDelegate {

    
    var delegate : EngraveRobotDelegate?


    var isLaserOn : Bool = false
    {
        didSet{
            if isLaserOn
            {
                self.send(message: "l255#")
            }else
            {
                self.send(message: "l000#")
            }
        }
    }
    
    func laser(value:Int)
    {
        self.send(message: String(format:"l%3d#",value))
    }
    

    func move(to point:CGPoint)
    {
        
    }
    
    
    override init() {
        super.init()
        manager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }
    
    //MARK: - serial port
    
    func connect()
    {

    }
    
    func send(message:String)
    {
    print("send \(message)")
        peripheral?.writeValue(message.data(using: .utf8)!, for: characteristic!, type: CBCharacteristicWriteType.withResponse)
    }
    func didReceive(message: String)
    {
        self.delegate?.didReceviveMessgae(message: message)
        //print(message)
    }

    


    var manager         : CBCentralManager?
    var peripheral      : CBPeripheral?
    var characteristic  : CBCharacteristic?
    var flush : String = ""
    
    func stop()
    {
        manager?.stopScan()
    }
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state
        {
        case .poweredOn:
            print("poweredOn")
            central.scanForPeripherals(withServices: nil, options: nil)
            
        case .poweredOff:
            print("poweredOff")
        case .unsupported:
            print("unsupported")
        case .unauthorized:
            print("unauthorized")
        case .unknown:
            print("unknown")
        case .resetting:
            print("resetting")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("didFailToConnect")
    }
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("didDisconnectPeripheral")
        if peripheral.name == "ZHANGXI"
        {
            self.delegate?.didDisconnected()
        }
    }
    
    
    func connect(peripheral:CBPeripheral)
    {
        print("connect \(peripheral)")
        
        self.peripheral = peripheral
        self.peripheral?.delegate = self
        manager?.connect(self.peripheral!, options: nil)
    }
    func disConnect()
    {
        if self.peripheral != nil
        {
            manager?.cancelPeripheralConnection(self.peripheral!)
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        print(peripheral)
        print(advertisementData)
        print(RSSI)


        if peripheral.name == "ZHANGXI"
        {
            self.connect(peripheral: peripheral)
            self.stop()
        }
        
        
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("didConnect")
        print(peripheral)
        if peripheral.name == "ZHANGXI"
        {
            self.delegate?.didDisconnected()
        }
        peripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        print("didDiscoverServices")
        if error == nil
        {
            for s in peripheral.services ?? [CBService]()
            {
                print(s)
                print(s.uuid)
                print("=====")
                peripheral.discoverCharacteristics(nil, for: s)
            }
        }
    }
    
   
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        print("didDiscoverCharacteristicsFor")
        for c in service.characteristics ?? [CBCharacteristic]()
        {
            print(c.uuid)
            
            if c.uuid.uuidString == "FFE1"
            {
                self.characteristic = c
                print("FFE1 \(c)")
                print(c.properties)


                peripheral.setNotifyValue(true, for: c)
                print("可以写入")

            }
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
       
        print(characteristic)
        if characteristic.value != nil
        {
            flush += String(data: characteristic.value!, encoding: .utf8) ?? ""
            if flush.contains("\r\n")
            {
                let arr = flush.components(separatedBy: "\r\n")
                
                for  i  in 0 ..< arr.count-1 {
                    self.didReceive(message: arr[i])
                }
                
                flush = arr.last ?? ""
            }
            print()
        }

    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        peripheral.readValue(for: characteristic)
        //print("didUpdateNotificationStateFor \(characteristic) \(characteristic.value) \(error)")
    }
}




