//
//  PurchaseInformation.h
//  AllStars
//
//  Created by Flavio Franco Tunqui on 6/16/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PurchaseInformation : NSObject

@property (nonatomic, strong) NSString *currencyCode;
@property (nonatomic, strong) NSString *purchaseAmount;
@property (nonatomic, strong) NSString *operationNumber;
@property (nonatomic, strong) NSString *callerPhoneNumber;
@property (nonatomic, strong) NSString *terminalCode;
@property (nonatomic, strong) NSString *ipAddress;

@end