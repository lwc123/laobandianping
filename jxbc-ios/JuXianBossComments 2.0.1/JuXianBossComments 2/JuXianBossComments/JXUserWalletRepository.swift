//
//  JXUserWalletRepository.swift
//  JuXianBossComments
//
//  Created by juxian on 16/11/4.
//  Copyright © 2016年 jinghan. All rights reserved.
//

import Foundation
class JXUserWalletRepository : NSObject {
    
    class func getTradeHistory(pageIndex:Int, success:(JSONModelArray?)->Void, fail:(NSError!)->Void){
        let apiUrl = String(format: JXApiEnvironment.UserWallet_TradeHistory_Endpoint, pageIndex, JXApiEnvironment.OnceLoadItemCount);
        
        WebAPIClient.getJSONWithUrl(apiUrl, parameters: nil,
            success: {(data:AnyObject!) -> Void in
                var result :JSONModelArray?  = nil;
                if(false == (data is NSNull)) {
                    result = JSONModelArray.init(array: data as! [AnyObject]!, modelClass: TradeJournalEntity.self)
                }
                success(result);
            }, fail: { (error:NSError!) -> Void in fail(error);}
        );
    }
}