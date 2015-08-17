//
//  Phone.swift
//  SwiftPhone
//
//  Created by Matthew Makai on 8/12/15.
//  Copyright (c) 2015 Matt Makai. All rights reserved.
//

import Foundation

public class Phone : NSObject, TCDeviceDelegate {
    var device:TCDevice?
    var connection:TCConnection?
    var pendingConnection:TCConnection!
    
    func login() {
        
        var url = "https://swiftphonemakai.herokuapp.com/token?client=jenny"
        
        var swiftRequest = SwiftRequest();
        swiftRequest.get(url, callback: { (err, response, body) -> () in
            if (err != nil) {
                return;
            }
            
            var token = body as! String
            println(token);
            
            if err == nil {
                if ( self.device == nil ) {
                    self.device = TCDevice(capabilityToken: token, delegate: self);
                } else {
                    self.device!.updateCapabilityToken(token);
                }
            } else if ( err != nil && response != nil) {
                // We received and error with a response
            } else if (err != nil) {
                // We received an error without a response
            }
        });
    }
    
    func connectWithParams(params dictParams:Dictionary<String,String> = Dictionary<String,String>()) {
        
        if (!self.capabilityTokenValid())
        {
            self.login();
        }
        
        self.connection = self.device?.connect(dictParams, delegate: nil);
    }
    
    func capabilityTokenValid()->(Bool) {
        var isValid:Bool = false;
        
        if (self.device != nil) {
            var capabilities = self.device!.capabilities as NSDictionary;
            
            var expirationTimeObject:NSNumber = capabilities.objectForKey("expiration") as! NSNumber;
            var expirationTimeValue:Int64 = expirationTimeObject.longLongValue;
            var currentTimeValue:NSTimeInterval = NSDate().timeIntervalSince1970;
            
            if( (expirationTimeValue-Int64(currentTimeValue)) > 0 ) {
                isValid = true;
            }
        }
        
        return isValid;
    }
    
    public func deviceDidStartListeningForIncomingConnections(device: TCDevice)->() {
        println("Started listening for incoming connections")
    }
    
    public func device(device:TCDevice, didStopListeningForIncomingConnections error:NSError)->(){
        println("Stopped listening for incoming connections")
    }
    
    public func device(device:TCDevice!, didReceiveIncomingConnection connection:TCConnection!) {
        println("Receiving an incoming connection")
        self.pendingConnection = connection
        
        NSNotificationCenter.defaultCenter().postNotificationName(
            "PendingIncomingConnectionReceived",
            object: nil,
            userInfo:nil)
    }
    
    func acceptConnection() {
        self.connection = self.pendingConnection
        self.pendingConnection = nil
        
        self.connection?.accept()
    }
    
    func rejectConnection() {
        self.pendingConnection?.reject()
        self.pendingConnection = nil
    }
    
    func ignoreConnection() {
        self.pendingConnection?.ignore()
        self.pendingConnection = nil
    }
    
}
