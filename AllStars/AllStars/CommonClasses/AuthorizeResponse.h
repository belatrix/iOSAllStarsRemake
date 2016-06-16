//
//  AuthorizeResponse.h
//  AllStars
//
//  Created by Flavio Franco Tunqui on 6/16/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthorizeResponse : NSObject

@property (nonatomic, strong) NSString *errorCode;
@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *hour;
@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, strong) NSString *authorizedAmount;
@property (nonatomic, strong) NSString *CVV2mask;
@property (nonatomic, strong) NSString *idCard;
@property (nonatomic, strong) NSString *operationNumber;
@property (nonatomic, strong) NSString *idTransaction;

@end