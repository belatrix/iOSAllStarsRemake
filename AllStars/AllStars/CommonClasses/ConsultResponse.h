//
//  ConsultResponse.h
//  AllStars
//
//  Created by Flavio Franco Tunqui on 6/16/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConsultResponse : NSObject

@property (nonatomic, strong) NSString *ansCode;
@property (nonatomic, strong) NSString *ansDescription;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *hour;
@property (nonatomic, strong) NSString *brandList;
@property (nonatomic, strong) NSString *codAsoCardHolderWallet;
@property (nonatomic, strong) NSString *lastnameCardholder;
@property (nonatomic, strong) NSString *nameCardholder;
@property (nonatomic, strong) NSString *needAutorization;
@property (nonatomic, strong) NSString *tokken;
@property (nonatomic, strong) NSMutableArray *listCards;

@end