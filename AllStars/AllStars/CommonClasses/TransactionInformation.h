//
//  TransactionInformation.h
//  AllStars
//
//  Created by Flavio Franco Tunqui on 6/16/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransactionInformation : NSObject

@property (nonatomic, strong) NSString *idAcquirer;
@property (nonatomic, strong) NSString *idEntCommerce;
@property (nonatomic, strong) NSString *codAsoCardHolderWallet;
@property (nonatomic, strong) NSString *codCardHolderCommerce;
@property (nonatomic, strong) NSString *mail;
@property (nonatomic, strong) NSString *nameCardholder;
@property (nonatomic, strong) NSString *lastNameCardholder;

@end