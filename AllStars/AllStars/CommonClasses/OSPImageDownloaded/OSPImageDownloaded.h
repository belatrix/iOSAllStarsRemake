//
//  OSPImageDownloaded.h
//  OSPImageDownloaded v.2.0.0
//
//  Created by Kenyimetal on 10/12/14.
//  Copyright (c) 2014 Belatrix SF. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;
@class UIImageView;

@interface OSPImageDownloaded : NSObject



/**
 @brief Función encargada de guardar una imagen en un directorio especificado.
 @param aImagen es la imagen que se desea guardar.
 @param aNombre es el nombre de la imagen que se desea guardar.
 @param aDirectorio es el nombre de la carpeta donde se desea guardar la imagen. Si no se envia parámetro entonces la carpeta de defecto es "Cache"
 @return Si se guardó o no la imagen.
 */
+ (BOOL)guardarImagen:(UIImage *)aImagen nombre:(NSString *)aNombre enDirectorio:(NSString *)aDirectorio;




/**
 @brief Función encargada de buscar una imagen por su nombre en un directorio específico.
 @param aNombre es el nombre de la imagen a buscar.
 @param aDirectorio es el nombre de la carpeta donde se desea buscar la imagen.
 @return La imagen encontrada o nil si no existe el archivo.
 */
+ (UIImage *)obtenerImageConNombre:(NSString *)aNombre enDirectorio:(NSString *)aDirectorio;






/**
 @brief Función encargada de descargar en data binaria una imagen y almacenarla en un UIImage y en el dispositivo. Esta función no es asíncrona.
 @param aUrl es la URL donde se encuentra la imagen.
 @param aNombre es el nommbre de la imagen.
 @return La imagen descargada.
 */
+ (UIImage *)descargarImagenEnURL:(NSString *)aUrl conNombre:(NSString *)aNombre;





/**
 @brief Función encargada de asignar a un UIImageView un UIImage mostrando una animación de transición.
 @param aNuevaImagen imagen a asignar.
 @param aImageView contenedor de la imagen.
 @param aTransicion es el tipo de transición. Este parámetro es opcional, su valor por defecto es kCATransitionFade y su tiempo de transición es 0.35.
 */
+ (void)asignarConAnimacionLaImagen:(UIImage *)aNuevaImagen enImagenView:(UIImageView *)aImageView conTransicion:(NSString *)aTransicion;





/**
 @brief Función encargada de descargar una imagen de internet y asignarla a un UIImageView y mientras esta en proceso asigna un placeHolder. Ademas permite asignarle una animación de transición cuando la imagen ya descargo e indica si el proceso fue realizado correctamente o no.
 @param aUrl es la URL de la imagen a descargar.
 @param aImgFoto es el UIImageView donde se asignara la imagen descargada.
 @param aImgPlaceHolder es la imagen de placeHolder, la cual se asignara mientras se esta descargando el archivo o en caso no se logre completar el proceso.
 @param aTransicion es el tipo de transición. Este parámetro es opcional, su valor por defecto es kCATransitionFade y su tiempo de transición es 0.35.
 @param completion devuelve el estado del proceso si se descargó y guardo correctamente o no el archivo.
 */
+ (void)descargarImagenEnURL:(NSString *)aUrl paraImageView:(UIImageView *)aImgFoto conPlaceHolder:(UIImage *)aImgPlaceHolder conTransicion:(NSString *)aTransicion conCompletion:(void (^)(BOOL descargaCorrecta, NSString *nombreArchivo))completion;




/**
 @brief Función encargada de descargar una imagen de internet y asignarla a un UIImageView y mientras esta en proceso asigna un placeHolder. Ademas indica si el proceso fue realizado correctamente o no.
 @param aUrl es la URL de la imagen a descargar.
 @param aImgFoto es el UIImageView donde se asignara la imagen descargada.
 @param aImgPlaceHolder es la imagen de placeHolder, la cual se asignara mientras se esta descargando el archivo o en caso no se logre completar el proceso.
 @param completion devuelve el estado del proceso si se descargó y guardo correctamente o no el archivo.
 */
+ (void)descargarImagenEnURL:(NSString *)aUrl paraImageView:(UIImageView *)aImgFoto conPlaceHolder:(UIImage *)aImgPlaceHolder conCompletion:(void (^)(BOOL descargaCorrecta, NSString *nombreArchivo, UIImage *imagen))completion;





/**
 @brief Función encargada de descargar una imagen de internet y asignarla a un UIImageView y mientras esta en proceso asigna un placeHolder. Ademas permite asignarle una animación de transición cuando la imagen ya descargo.
 @param aUrl es la URL de la imagen a descargar.
 @param aImgFoto es el UIImageView donde se asignara la imagen descargada.
 @param aImgPlaceHolder es la imagen de placeHolder, la cual se asignara mientras se esta descargando el archivo o en caso no se logre completar el proceso.
 @param aTransicion es el tipo de transición. Este parámetro es opcional, su valor por defecto es kCATransitionFade y su tiempo de transición es 0.35.
 */
+ (void)descargarImagenEnURL:(NSString *)aUrl paraImageView:(UIImageView *)aImgFoto conPlaceHolder:(UIImage *)aImgPlaceHolder conTransicion:(NSString *)aTransicion;





/**
 @brief Función encargada de descargar una imagen de internet y asignarla a un UIImageView y mientras esta en proceso asigna un placeHolder.
 @param aUrl es la URL de la imagen a descargar.
 @param aImgFoto es el UIImageView donde se asignara la imagen descargada.
 @param aImgPlaceHolder es la imagen de placeHolder, la cual se asignara mientras se esta descargando el archivo o en caso no se logre completar el proceso.
 */
+ (void)descargarImagenEnURL:(NSString *)aUrl paraImageView:(UIImageView *)aImgFoto conPlaceHolder:(UIImage *)aImgPlaceHolder;







+ (void)descargarImagenPerfilFacebookConId:(NSString *)aID paraImageView:(UIImageView *)aImgFoto conPlaceHolder:(UIImage *)aImgPlaceHolder conTransicion:(NSString *)aTransicion;



+ (void)descargarImagenPerfilFacebookConURL:(NSString *)url paraImageView:(UIImageView *)aImgFoto conPlaceHolder:(UIImage *)aImgPlaceHolder conTransicion:(NSString *)aTransicion;


@end
