//
//  PaymentRepository.swift
//  JuXianBossComments
//
//  Created by juxian on 16/10/24.
//  Copyright © 2016年 jinghan. All rights reserved.
//

import Foundation

class PaymentRepository : NSObject {
        
    //微信支付
    class func createTrade(entity:PaymentEntity, success:(PaymentResult?)->Void, fail:(NSError!)->Void){
        
        WebAPIClient.postJSONWithUrl(JXApiEnvironment.Payment_CreateTrade_Endpoint, parameters: entity.toDictionary(),
            success: {(data:AnyObject!) -> Void in
                
                if(false == (data is NSNull)) {
                    do {
                        let result = try PaymentResult(dictionary:data as! [NSObject : AnyObject]);
                        success(result);
                    } catch {
                        success(nil as PaymentResult?);
                    }
                } else {
                    success(nil as PaymentResult?);
                }
            }, fail: { (error:NSError!) -> Void in fail(error);}
        );
    }
    
    class func paymentCompleted(entity:PaymentResult, success:(PaymentResult?)->Void, fail:(NSError!)->Void){
        
        WebAPIClient.postJSONWithUrl(JXApiEnvironment.Payment_PaymentCompleted_Endpoint, parameters: entity.toDictionary(),
            success: {(data:AnyObject!) -> Void in
                if(false == (data is NSNull)) {
                    do {
                        let result = try PaymentResult(dictionary:data as! [NSObject : AnyObject]);
                        success(result);
                    } catch {
                        success(nil as PaymentResult?);
                    }
                } else {
                    success(nil as PaymentResult?);
                }
            }, fail: { (error:NSError!) -> Void in fail(error);}
        );
    }
    
}
