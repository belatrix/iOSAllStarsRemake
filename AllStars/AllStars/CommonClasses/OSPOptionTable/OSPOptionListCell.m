//
//  OSPOptionListCell.m
//  InterbankCuentaSueldo
//
//  Created by Kenyimetal on 22/04/15.
//  Copyright (c) 2015 Online Studio Productions LLC. All rights reserved.
//

#import "OSPOptionListCell.h"
#import "OSPOptionListItem.h"

@interface OSPOptionListCell () {
    
    IBOutlet UILabel *lblTitulo;
    IBOutlet UIImageView *imgSeleccionado;
}

@end


@implementation OSPOptionListCell


-(void)drawRect:(CGRect)rect{
    
    self.layer.borderColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1].CGColor;
    self.layer.borderWidth = 0.5;
}




/**
 @brief Método usado para actualizar la información de la celda.
 */
-(void)actualizarData{
    
    imgSeleccionado.alpha = self.objItem.estaSeleccionado.boolValue;
    lblTitulo.text = self.objItem.titulo;
}



/**
 @brief Función para animar la selección o deseslección de la celda según sea el valor de su flag.
 */
-(void)animarSeleccion{
    
    if (self.objItem.estaSeleccionado.boolValue) {
        [self seleccionar];
    }else{
        [self deseleccionar];
    }
}



-(void)seleccionar{
    
    [UIView animateWithDuration:0.15 animations:^{
        
        imgSeleccionado.alpha = 1;
        imgSeleccionado.transform = CGAffineTransformMakeScale(0.8, 0.8);
        
    } completion:^(BOOL finished) {
       
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            imgSeleccionado.transform = CGAffineTransformMakeScale(1, 1);
            
        } completion:nil];
        
    }];
}

-(void)deseleccionar{
    
    [UIView animateWithDuration:0.1 animations:^{
        imgSeleccionado.alpha = 0;
    }];
}


@end
