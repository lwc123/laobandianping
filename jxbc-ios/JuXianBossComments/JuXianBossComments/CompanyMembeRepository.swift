
//
//  CompanyMembeRepository.swift
//  JuXianBossComments
//
//  Created by juxian on 16/12/13.
//  Copyright © 2016年 jinghan. All rights reserved.
//

import Foundation

class CompanyMembeRepository : NSObject {

    class func delete(membeEntity:CompanyMembeEntity, success:(Bool)->Void, fail:(NSError!)->Void){
        let apiUrl = String(format: JXApiEnvironment.CompanyMember_Delegate_Endpoint, membeEntity);
        
        WebAPIClient.postJSONWithUrl(apiUrl, parameters: [membeEntity .toDictionary()],
                                     success: {(data:AnyObject!) -> Void in
                                        success(data as! Bool);
            }, fail: { (error:NSError!) -> Void in fail(error);}
        );
    }
}
