//
//  Card.h
//  AllStars
//
//  Created by Flavio Franco Tunqui on 6/16/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

    @property (nonatomic, strong) NSString *idCard;
    @property (nonatomic, strong) NSString *brand;
    @property (nonatomic, strong) NSString *idAddress;
    @property (nonatomic, strong) NSString *cardDescription;
    @property (nonatomic, strong) NSString *cardNumber;
    @property (nonatomic, strong) NSString *cardExpired;
    @property (nonatomic, strong) NSString *primaryCard;
    @property (nonatomic, strong) NSString *bank;
    @property (nonatomic, strong) NSString *cardType;
    
    @property (nonatomic, strong) NSString *email;
    @property (nonatomic, strong) NSString *expiryDate;
    @property (nonatomic, strong) NSString *tokken2Mask;
    @property (nonatomic, assign) BOOL lastUse;
    
    @property (nonatomic, assign) BOOL isNew;
    @property (nonatomic, assign) BOOL isEdited;
    @property (nonatomic, strong) NSString *cardNumberComplete;
    
    @property (nonatomic, assign) BOOL enable;

@end