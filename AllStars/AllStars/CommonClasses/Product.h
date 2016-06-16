//
//  Product.h
//  AllStars
//
//  Created by Flavio Franco Tunqui on 6/16/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic, strong) NSString *item;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *unitPrice;
@property (nonatomic, strong) NSString *quantity;

@end