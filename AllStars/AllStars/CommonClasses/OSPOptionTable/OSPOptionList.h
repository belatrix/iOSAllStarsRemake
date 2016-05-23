//
//  OSPOptionList.h
//  InterbankCuentaSueldo
//
//  Created by Kenyimetal on 22/04/15.
//  Copyright (c) 2015 Online Studio Productions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSPOptionListItem.h"


@class OSPOptionListItem;
@class OSPOptionList;



@protocol OSPOptionListDelegate <NSObject>
@required
-(void)optionListSeleccionarItem:(OSPOptionListItem *)aItem enOptionList:(OSPOptionList *)aOptionList;
@end


@interface OSPOptionList : UIView

@property (nonatomic, strong) NSArray *arrayItemList;
@property (nonatomic, assign) id <OSPOptionListDelegate> delegate;

-(void)mostrarEnVista:(UIView *)aVista;
+(OSPOptionListItem *)obtenerItemSeleccionadoEnArray:(NSArray *)arrayItem;
-(IBAction)tapCerrar:(id)sender;

@end
