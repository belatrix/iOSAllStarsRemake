//
//  OSPImageDownloaded.m
//  OSPImageDownloaded v.2.0.0
//
//  Created by Kenyimetal on 10/12/14.
//  Copyright (c) 2014 Belatrix SF. All rights reserved.
//

#import "OSPImageDownloaded.h"
#import <UIKit/UIKit.h>


NSString *const OSPImageDownloadedDirectorioDescarga = @"Caches";

@implementation OSPImageDownloaded


/**
 @brief Función encargada de guardar una imagen en un directorio especificado.
 @param aImagen es la imagen que se desea guardar.
 @param aNombre es el nombre de la imagen que se desea guardar.
 @param aDirectorio es el nombre de la carpeta donde se desea guardar la imagen. Si no se envia parámetro entonces la carpeta de defecto es "Cache"
 @return Si se guardó o no la imagen.
 */
+ (BOOL)guardarImagen:(UIImage *)aImagen nombre:(NSString *)aNombre enDirectorio:(NSString *)aDirectorio{
    
    if (!aImagen || !aNombre) return NO;
    
    NSString * documentsPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    NSString * cachesPath    = [documentsPath stringByAppendingPathComponent:aDirectorio ? aDirectorio : OSPImageDownloadedDirectorioDescarga];
    NSString * filePath      = [cachesPath stringByAppendingPathComponent:aNombre];
    NSData   * data          = ([aNombre hasSuffix:@"jpg"] == YES) ? UIImageJPEGRepresentation(aImagen, 1.0f) : UIImagePNGRepresentation(aImagen);
   
    BOOL estadoGuardadoImagen = [data writeToFile:filePath atomically:YES];
    
    NSLog(@"OSPImageDownloaded / %@ la imagen %@",estadoGuardadoImagen ? @"Se guardó" : @"NO se guardó", aNombre);
    
    return estadoGuardadoImagen;
}






/**
 @brief Función encargada de buscar una imagen por su nombre en un directorio específico.
 @param aNombre es el nombre de la imagen a buscar.
 @param aDirectorio es el nombre de la carpeta donde se desea buscar la imagen.
 @return La imagen encontrada o nil si no existe el archivo.
 */
+ (UIImage *)obtenerImageConNombre:(NSString *)aNombre enDirectorio:(NSString *)aDirectorio{
    
    if (!aNombre) return nil;
    
    UIImage * imagen = nil;
    
    NSFileManager * fileManager   = [NSFileManager defaultManager];
    NSString      * documentsPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask,YES)[0];
    NSString      * cachesPath    = [documentsPath stringByAppendingPathComponent:aDirectorio ? aDirectorio : OSPImageDownloadedDirectorioDescarga];
    NSString      * filePath      = [cachesPath stringByAppendingPathComponent:aNombre];
    
    if ([fileManager fileExistsAtPath:filePath])
        imagen = [UIImage imageWithContentsOfFile:filePath];
    
    return imagen;
}






/**
 @brief Función encargada de descargar en data binaria una imagen y almacenarla en un UIImage y en el dispositivo. Esta función no es asíncrona.
 @param aUrl es la URL donde se encuentra la imagen.
 @param aNombre es el nommbre de la imagen.
 @return La imagen descargada.
 */
+ (UIImage *)descargarImagenEnURL:(NSString *)aUrl conNombre:(NSString *)aNombre{
    
    if (!aUrl || !aNombre) return nil;
    
    NSData *dataImagenDescargada = [NSData dataWithContentsOfURL:[NSURL URLWithString:aUrl]];
    
    if (dataImagenDescargada) {
        
        UIImage * imgDescargada = [UIImage imageWithData:dataImagenDescargada];
        return [self guardarImagen:imgDescargada nombre:aNombre enDirectorio:nil] ? [self obtenerImageConNombre:aNombre enDirectorio:nil] : nil;
    }
    
    return nil;
}






/**
 @brief Función encargada de asignar a un UIImageView un UIImage mostrando una animación de transición.
 @param aNuevaImagen imagen a asignar.
 @param aImageView contenedor de la imagen.
 @param aTransicion es el tipo de transición. Este parámetro es opcional, su valor por defecto es kCATransitionFade y su tiempo de transición es 0.35.
 */
+ (void)asignarConAnimacionLaImagen:(UIImage *)aNuevaImagen enImagenView:(UIImageView *)aImageView conTransicion:(NSString *)aTransicion{
    
    [aImageView setImage:aNuevaImagen];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = aTransicion ? aTransicion : kCATransitionFade;
    
    [aImageView.layer addAnimation:transition forKey:nil];
}







/**
 @brief Función encargada de descargar una imagen de internet y asignarla a un UIImageView y mientras esta en proceso asigna un placeHolder. Ademas permite asignarle una animación de transición cuando la imagen ya descargo e indica si el proceso fue realizado correctamente o no.
 @param aUrl es la URL de la imagen a descargar.
 @param aImgFoto es el UIImageView donde se asignara la imagen descargada.
 @param aImgPlaceHolder es la imagen de placeHolder, la cual se asignara mientras se esta descargando el archivo o en caso no se logre completar el proceso.
 @param aTransicion es el tipo de transición. Este parámetro es opcional, su valor por defecto es kCATransitionFade y su tiempo de transición es 0.35.
 @param completion devuelve el estado del proceso si se descargó y guardo correctamente o no el archivo.
 */
+ (void)descargarImagenEnURL:(NSString *)aUrl paraImageView:(UIImageView *)aImgFoto conPlaceHolder:(UIImage *)aImgPlaceHolder conTransicion:(NSString *)aTransicion conCompletion:(void (^)(BOOL descargaCorrecta, NSString *nombreArchivo))completion{
    
    [aImgFoto setImage:aImgPlaceHolder];
    
    __block NSString * nombre = [aUrl lastPathComponent];
    
    nombre = ([nombre hasSuffix:@"jpg"]) ? [nombre stringByReplacingOccurrencesOfString:@".jpg" withString:@"@2x.jpg"] : [nombre stringByReplacingOccurrencesOfString:@".png" withString:@"@2x.png"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        UIImage * imagenGuardada = [self obtenerImageConNombre:nombre enDirectorio:nil];
        
        if (!imagenGuardada) {
            
            UIImage *imgDescargada = [self descargarImagenEnURL:aUrl conNombre:nombre];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [self asignarConAnimacionLaImagen:imgDescargada ? imgDescargada : aImgPlaceHolder enImagenView:aImgFoto conTransicion:aTransicion];
                
                if (completion)
                    completion(imgDescargada ? YES : NO, aUrl);
            });
            
        }else{
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [aImgFoto setImage:imagenGuardada];
                
                if (completion)
                    completion(YES, aUrl);
            });
            
        }
        
    });
    
}






/**
 @brief Función encargada de descargar una imagen de internet y asignarla a un UIImageView y mientras esta en proceso asigna un placeHolder. Ademas indica si el proceso fue realizado correctamente o no.
 @param aUrl es la URL de la imagen a descargar.
 @param aImgFoto es el UIImageView donde se asignara la imagen descargada.
 @param aImgPlaceHolder es la imagen de placeHolder, la cual se asignara mientras se esta descargando el archivo o en caso no se logre completar el proceso.
 @param completion devuelve el estado del proceso si se descargó y guardo correctamente o no el archivo.
 */
+ (void)descargarImagenEnURL:(NSString *)aUrl paraImageView:(UIImageView *)aImgFoto conPlaceHolder:(UIImage *)aImgPlaceHolder conCompletion:(void (^)(BOOL descargaCorrecta, NSString *nombreArchivo, UIImage *imagen))completion{
    
    [aImgFoto setImage:aImgPlaceHolder];
    
    __block NSString * nombre = [aUrl lastPathComponent];
    
    nombre = ([nombre hasSuffix:@"jpg"]) ? [nombre stringByReplacingOccurrencesOfString:@".jpg" withString:@"@2x.jpg"] : [nombre stringByReplacingOccurrencesOfString:@".png" withString:@"@2x.png"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        UIImage * imagenGuardada = [self obtenerImageConNombre:nombre enDirectorio:nil];
        
        if (!imagenGuardada) {
            
            UIImage *imgDescargada = [self descargarImagenEnURL:aUrl conNombre:nombre];
        
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                if (completion)
                    completion(imgDescargada ? YES : NO, aUrl,imgDescargada ? imgDescargada : aImgPlaceHolder);
            });
            
        }else{
            
            dispatch_sync(dispatch_get_main_queue(), ^{
        
                if (completion)
                    completion(YES, aUrl, imagenGuardada);
            });

        }

    });
}






/**
 @brief Función encargada de descargar una imagen de internet y asignarla a un UIImageView y mientras esta en proceso asigna un placeHolder. Ademas permite asignarle una animación de transición cuando la imagen ya descargo.
 @param aUrl es la URL de la imagen a descargar.
 @param aImgFoto es el UIImageView donde se asignara la imagen descargada.
 @param aImgPlaceHolder es la imagen de placeHolder, la cual se asignara mientras se esta descargando el archivo o en caso no se logre completar el proceso.
 @param aTransicion es el tipo de transición. Este parámetro es opcional, su valor por defecto es kCATransitionFade y su tiempo de transición es 0.35.
 */
+ (void)descargarImagenEnURL:(NSString *)aUrl paraImageView:(UIImageView *)aImgFoto conPlaceHolder:(UIImage *)aImgPlaceHolder conTransicion:(NSString *)aTransicion{
    
    [aImgFoto setImage:aImgPlaceHolder];
    
    __block NSString * nombre = [aUrl lastPathComponent];
    
    nombre = ([nombre hasSuffix:@"jpg"]) ? [nombre stringByReplacingOccurrencesOfString:@".jpg" withString:@"@2x.jpg"] : [nombre stringByReplacingOccurrencesOfString:@".png" withString:@"@2x.png"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        UIImage * imagenGuardada = [self obtenerImageConNombre:nombre enDirectorio:nil];
        
        if (!imagenGuardada) {
            
            UIImage *imgDescargada = [self descargarImagenEnURL:aUrl conNombre:nombre];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [self asignarConAnimacionLaImagen:imgDescargada ? imgDescargada : aImgPlaceHolder enImagenView:aImgFoto conTransicion:aTransicion];
            });
            
        }else{
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [aImgFoto setImage:imagenGuardada];
            });
            
        }
        
    });
    
}




+ (void)descargarImagenPerfilFacebookConId:(NSString *)aID paraImageView:(UIImageView *)aImgFoto conPlaceHolder:(UIImage *)aImgPlaceHolder conTransicion:(NSString *)aTransicion{
    
    [aImgFoto setImage:aImgPlaceHolder];
    
    __block NSString * nombre = [NSString stringWithFormat:@"%@.png",aID];
    __block NSString * aUrl   = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", aID];
    
    nombre = ([nombre hasSuffix:@"jpg"]) ? [nombre stringByReplacingOccurrencesOfString:@".jpg" withString:@"@2x.jpg"] : [nombre stringByReplacingOccurrencesOfString:@".png" withString:@"@2x.png"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        UIImage * imagenGuardada = [self obtenerImageConNombre:nombre enDirectorio:nil];
        
        if (!imagenGuardada) {
            
            UIImage *imgDescargada = [self descargarImagenEnURL:aUrl conNombre:nombre];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [self asignarConAnimacionLaImagen:imgDescargada ? imgDescargada : aImgPlaceHolder enImagenView:aImgFoto conTransicion:aTransicion];
            });
            
        }else{
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [aImgFoto setImage:imagenGuardada];
            });
            
        }
        
    });
    
}



+ (void)descargarImagenPerfilFacebookConURL:(NSString *)url paraImageView:(UIImageView *)aImgFoto conPlaceHolder:(UIImage *)aImgPlaceHolder conTransicion:(NSString *)aTransicion{
    
    [aImgFoto setImage:aImgPlaceHolder];
    
    __block NSString * nombre = [[url componentsSeparatedByString:@"="] lastObject];
    __block NSString * aUrl   = url;
    
    nombre = ([nombre hasSuffix:@"jpg"]) ? [nombre stringByReplacingOccurrencesOfString:@".jpg" withString:@"@2x.jpg"] : [nombre stringByReplacingOccurrencesOfString:@".png" withString:@"@2x.png"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        UIImage * imagenGuardada = [self obtenerImageConNombre:nombre enDirectorio:nil];
        
        if (!imagenGuardada) {
            
            UIImage *imgDescargada = [self descargarImagenEnURL:aUrl conNombre:nombre];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [self asignarConAnimacionLaImagen:imgDescargada ? imgDescargada : aImgPlaceHolder enImagenView:aImgFoto conTransicion:aTransicion];
            });
            
        }else{
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [aImgFoto setImage:imagenGuardada];
            });
            
        }
        
    });
    
}




/**
 @brief Función encargada de descargar una imagen de internet y asignarla a un UIImageView y mientras esta en proceso asigna un placeHolder.
 @param aUrl es la URL de la imagen a descargar.
 @param aImgFoto es el UIImageView donde se asignara la imagen descargada.
 @param aImgPlaceHolder es la imagen de placeHolder, la cual se asignara mientras se esta descargando el archivo o en caso no se logre completar el proceso.
 */
+ (void)descargarImagenEnURL:(NSString *)aUrl paraImageView:(UIImageView *)aImgFoto conPlaceHolder:(UIImage *)aImgPlaceHolder{
    
    [aImgFoto setImage:aImgPlaceHolder];
    
    __block NSString * nombre = [aUrl lastPathComponent];
    
    nombre = ([nombre hasSuffix:@"jpg"]) ? [nombre stringByReplacingOccurrencesOfString:@".jpg" withString:@"@2x.jpg"] : [nombre stringByReplacingOccurrencesOfString:@".png" withString:@"@2x.png"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        UIImage * imagenGuardada = [self obtenerImageConNombre:nombre enDirectorio:nil];
        
        if (!imagenGuardada) {
            
            UIImage *imgDescargada = [self descargarImagenEnURL:aUrl conNombre:nombre];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [aImgFoto setImage:imgDescargada ? imgDescargada : aImgPlaceHolder];

            });
            
        }else{
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [aImgFoto setImage:imagenGuardada];

            });
            
        }
        
    });
}




@end
