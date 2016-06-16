//
//  Address.h
//  AllStars
//
//  Created by Flavio Franco Tunqui on 6/16/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSString *zipCode;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *email;

@end