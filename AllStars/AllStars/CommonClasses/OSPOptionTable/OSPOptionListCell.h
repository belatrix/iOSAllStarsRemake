//
//  OSPOptionListCell.h
//  InterbankCuentaSueldo
//
//  Created by Kenyimetal on 22/04/15.
//  Copyright (c) 2015 Online Studio Productions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OSPOptionListItem;

@interface OSPOptionListCell : UICollectionViewCell

@property (nonatomic, strong) OSPOptionListItem *objItem;  //!< Objeto que contiene la data de la celda.



/**
 @brief Método usado para actualizar la información de la celda.
 */
-(void)actualizarData;



/**
 @brief Función para animar la selección o deseslección de la celda según sea el valor de su flag.
 */
-(void)animarSeleccion;





@end
