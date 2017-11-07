//
//  JXOrganizationTradeRepository.swift
//  JuXianBossComments
//
//  Created by juxian on 16/12/15.
//  Copyright © 2016年 jinghan. All rights reserved.
//

import Foundation

class JXOrganizationTradeRepository: NSObject {
    
    class func getTradeHistory(companyId:Int64,mode:Int, pageIndex:Int, success:(JSONModelArray?)->Void, fail:(NSError!)->Void){
        let apiUrl = String(format: JXApiEnvironment.Organization_TradeHistory_Endpoint,companyId,mode, pageIndex, JXApiEnvironment.OnceLoadItemCount);
        WebAPIClient.getJSONWithUrl(apiUrl, parameters: nil,
        success: {(data:AnyObject!) -> Void in
            var result :JSONModelArray?  = nil;
            if(false == (data is NSNull)) {
                result = JSONModelArray.init(array: data as! [AnyObject]!, modelClass: InLineModel.self)
            }
                success(result);
            }, fail: { (error:NSError!) -> Void in fail(error);}
        );
    }
}

