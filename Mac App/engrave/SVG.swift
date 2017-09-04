//
//  SVG.swift
//  engrave
//
//  Created by zhangxi on 31/08/2017.
//  Copyright © 2017 zhangxi. All rights reserved.
//

import Foundation
import Cocoa


class SVG : NSObject, XMLParserDelegate{
    
    var parser : XMLParser?
    var url : URL
    var size : CGSize?
    var finishHandler : ((SVG)->Void)
    
    var pathes = [LaserPath]()
    
    
    init(url:URL,finish:@escaping ((SVG)->Void)) {
        
        self.url = url
        self.finishHandler = finish
        
        super.init()
        
        
        do{
            let content = try String( contentsOf: url)
            print(content)
            
            parser = XMLParser(contentsOf: url)
            parser?.delegate = self
            parser?.parse()
            
            
            
        }catch{}
    }
    
    
    func parserDidStartDocument(_ parser: XMLParser) {
        //print("start")
    }
    func parserDidEndDocument(_ parser: XMLParser) {
        //print("end")
        
        self.finishHandler(self)
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        //print(elementName)
        //print(qName)
        //print(attributeDict)
        /*
         line
         nil
         ["y1": "0.536596415443", "x2": "303.868489034", "id": "7601E0F5", "style": "fill:none", "x1": "107.259114034", "y2": "15.5405026654"]
         polyline
         nil
         ["style": "fill:none", "id": "CC0512F5", "points": "25.6223952845,190.966283915 186.739582784,259.036596415 121.430989034,97.5248776654 244.606770284,113.622533915 307.481770284,204.134252665 298.505207784,258.259252665"]
         path
         */
        
        
        switch elementName {
        case "svg":
            break
        case "path":
            break
        case "line":
            pathes.append(LaserPathPolyline(line: attributeDict))
        case "polyline":
            pathes.append(LaserPathPolyline(polyline: attributeDict))
        default:
            break
        }
        
        
        
    }
    
}




/*

 简单把SVG转换为刀路
 
 
 */

class LaserPath
{

}

class LaserPathPolyline : LaserPath
{
    var points = [CGPoint]()
    
    init(polyline attributeDict:[String : String]) {
        /*
         polyline
         nil
         ["style": "fill:none", "id": "CC0512F5", "points": "25.6223952845,190.966283915 186.739582784,259.036596415 121.430989034,97.5248776654 244.606770284,113.622533915 307.481770284,204.134252665 298.505207784,258.259252665"]
         path
         */
        print("polyline")
        for item in attributeDict["points"]!.components(separatedBy: " ")
        {
            let xy = item.components(separatedBy: ",")
            let point = CGPoint( x: Double(xy[0])! , y: Double(xy[1])!)
            points.append(point)
        }
    }
    init(line attributeDict:[String : String]) {
        /*
         line
         nil
         ["y1": "0.536596415443", "x2": "303.868489034", "id": "7601E0F5", "style": "fill:none", "x1": "107.259114034", "y2": "15.5405026654"]
         */
        print("line")
        points.append(CGPoint( x: Double(attributeDict["x1"]!)! , y: Double(attributeDict["y1"]!)!))
        points.append(CGPoint( x: Double(attributeDict["x2"]!)! , y: Double(attributeDict["y2"]!)!))
    }
}







