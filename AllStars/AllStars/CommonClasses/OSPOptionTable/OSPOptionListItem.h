//
//  OSPOptionListItem.h
//  InterbankCuentaSueldo
//
//  Created by Kenyimetal on 22/04/15.
//  Copyright (c) 2015 Belatrix SF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSPOptionListItem : NSObject

@property NSInteger aNumero;
@property (nonatomic, strong) NSString *titulo;            //!< Titulo a mostrar en la celda como opcción.
@property (nonatomic, strong) id objeto;                   //!< Objeto asignado a la celda y contiene todos los datos de la entidad.
@property (nonatomic, strong) NSNumber *estaSeleccionado;  //!< Flag que identifica si la celda esta seleccionada junto con su objeto asignado.

@end
