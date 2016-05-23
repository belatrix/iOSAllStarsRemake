//
//  OSPOptionList.m
//  InterbankCuentaSueldo
//
//  Created by Kenyimetal on 22/04/15.
//  Copyright (c) 2015 Online Studio Productions LLC. All rights reserved.
//

#import "OSPOptionList.h"
#import "OSPOptionListCell.h"



@interface OSPOptionList () <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>{
    
    IBOutlet UICollectionView *clvItemList;
    IBOutlet UIView *vistaFondo;
}

@end




@implementation OSPOptionList



#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}


/**
 @brief Método para cerrar la vista de la lista de opciones de manera animada.
 */
-(IBAction)tapCerrar:(id)sender{
    
    [UIView animateWithDuration:0.30 animations:^{
        
        vistaFondo.alpha = 0;
        clvItemList.alpha = 0.3;
        clvItemList.transform = CGAffineTransformMakeScale(0.4, 0.4);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
    
}



/**
 @brief Método encargado de obtener el item seleccionado en una lista
 @param arrayItem es la lista de elementos en la que se buscará el item seleccionado.
 @return elemento seleccionado
 */
+(OSPOptionListItem *)obtenerItemSeleccionadoEnArray:(NSArray *)arrayItem{
    
    NSPredicate *predicado = [NSPredicate predicateWithFormat:@"estaSeleccionado == 1"];
    NSArray *arrayResultado = [arrayItem filteredArrayUsingPredicate:predicado];
    
    return arrayResultado.count ? arrayResultado[0] : nil;
}






-(OSPOptionListItem *)obtenerItemSeleccionado{
    
    NSPredicate *predicado = [NSPredicate predicateWithFormat:@"estaSeleccionado == 1"];
    NSArray *arrayResultado = [self.arrayItemList filteredArrayUsingPredicate:predicado];
    
    return arrayResultado.count ? arrayResultado[0] : nil;
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.arrayItemList.count;
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = @"OSPOptionListCell";
    
    OSPOptionListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell setObjItem:self.arrayItemList[indexPath.row]];
    [cell actualizarData];
    
    return cell;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    OSPOptionListItem *itemAnterior = [self obtenerItemSeleccionado];
    
    if (itemAnterior) {
        
        NSIndexPath *indexPathAnterior = [NSIndexPath indexPathForItem:[self.arrayItemList indexOfObject:itemAnterior] inSection:0];
        OSPOptionListCell *cellAnterior = (OSPOptionListCell *)[collectionView cellForItemAtIndexPath:indexPathAnterior];
        itemAnterior.estaSeleccionado = @0;
        [cellAnterior animarSeleccion];
    }
    
    
    OSPOptionListItem *itemNuevo = self.arrayItemList[indexPath.row];
    OSPOptionListCell *cellNuevo = (OSPOptionListCell *)[collectionView cellForItemAtIndexPath:indexPath];
    itemNuevo.estaSeleccionado = @1;
    [cellNuevo animarSeleccion];
    
    [self.delegate optionListSeleccionarItem:self.arrayItemList[indexPath.row] enOptionList:self];
    
    [self tapCerrar:nil];
    
}


-(void)agregarParallax{
    

    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-20);
    verticalMotionEffect.maximumRelativeValue = @(20);
    

    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-10);
    horizontalMotionEffect.maximumRelativeValue = @(10);
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    [clvItemList addMotionEffect:group];
}


-(void)mostrarEnVista:(UIView *)aVista{
    
    [aVista addSubview:self];
    
    [clvItemList registerNib:[UINib nibWithNibName:@"OSPOptionListCell" bundle:nil] forCellWithReuseIdentifier:@"OSPOptionListCell"];
    clvItemList.layer.cornerRadius = 6;
    clvItemList.frame = CGRectMake(0, 0, 300, self.arrayItemList.count < 7 ? self.arrayItemList.count * 50 : 350);
    clvItemList.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    vistaFondo.alpha = 0;
    clvItemList.alpha = 0.3;
    clvItemList.transform = CGAffineTransformMakeScale(0.4, 0.4);
    
    OSPOptionListItem *item = [OSPOptionList obtenerItemSeleccionadoEnArray:self.arrayItemList];
    
    if (item) {
        NSInteger index = [self.arrayItemList indexOfObject:item];
        [clvItemList setContentOffset:CGPointMake(0, index * 50) animated:NO];
    }
    
    
    
    [UIView animateWithDuration:0.35 animations:^{
       
        vistaFondo.alpha = 1;
    }];
    
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        clvItemList.alpha = 1;
        clvItemList.transform = CGAffineTransformMakeScale(1, 1);
        
    } completion:^(BOOL finished) {
        
        [self agregarParallax];
    }];

}









@end
