//
//  OSPDateManager.h
//  OSPDateManager v2.0.0
//
//  Created by Kenyimetal on 9/12/14.
//  Copyright (c) 2014 Online Studio Productions LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


//dd    ==> Indica el Dia numerico
//MM    ==> Indica el Mes numerico
//MMM   ==> Indica el Mes en Texto abreviado
//MMMM  ==> Indica el Mes en Texto Completo
//yy    ==> Indica el Año abreviado
//yyyy  ==> Indica el Año Completo
//EEE   ==> Indica dia abrev.
//EEEE  ==> Indica dia Completo.


#define Formato12Horas @"MM-dd-yyyy hh:mm:ss a"    //!< formato de 12 horas (am - pm)
#define Formato24Horas @"MM-dd-yyyy HH:mm:ss"      //!< formato de 24 horas




@interface OSPDiferenciaFechas : NSObject

@property (nonatomic) NSInteger anios;        //!< diferencia de años
@property (nonatomic) NSInteger meses;        //!< diferencia de meses
@property (nonatomic) NSInteger dias;         //!< diferencia de días
@property (nonatomic) NSInteger horas;        //!< diferencia de horas
@property (nonatomic) NSInteger minutos;      //!< diferencia de minutos
@property (nonatomic) NSInteger segundos;     //!< diferencia de segundos

@end





@interface OSPDateManager : NSObject


/**
 @brief Función que convierte un TimeStamp en NSDate.
 @param aTimestamp es el timestamp a convertir a NSDate.
 @return Fecha obtenida a partir del timestamp.
 */
+ (NSDate *)convertirTimestampDate:(NSString *)aTimestamp;




/**
 @brief Función encargada de convertir un texto que tiene la forma de una fecha en una NSDate.
 @param aFecha texto con formato de fecha a convertir.
 @param aFormato formato de fecha en la que se encuentra la fecha recibida como parámetro.
 @return Fecha convertida.
 */
+ (NSDate *)convertirTexto:(NSString *)aFecha conFormato:(NSString *)aFormato;




/**
 @brief Función encargada de dar un tipo de formato de fecha a un NSDate
 @param aFecha es la fecha que se desea cambiar de formato.
 @param aFormato es el formato al cual se cambiara la fecha. estos pueden ser mencionados en el header de la clase.
 @return Cadena de texto con la forma del formato de la fecha.
 */
+ (NSString *)convertirFecha:(NSDate *)aFecha conFormato:(NSString *)aFormato;





/**
 @brief Función encargada de dar un tipo de formato de fecha a un NSDate según el locale de una región.
 @param aFecha es la fecha que se desea cambiar de formato.
 @param aFormato es el formato al cual se cambiara la fecha. estos pueden ser mencionados en el header de la clase.
 @param locale es el parámetro de región. Por defecto se ejecuta en la región de USA (en_US) un posible parámetro es la región de Perú (es_PE).
 @return Cadena de texto con la forma del formato de la fecha.
 */
+ (NSString *)convertirFecha:(NSDate *)aFecha alFormato:(NSString *)aFormato locale:(NSString *)locale;





/**
 @brief Función encargada de calcular la edad de una persona.
 @param fechaNacimiento es la fecha de nacimiento de la persona.
 @return La edad de una persona según la fecha de nacimiento ingresada.
 */
+ (NSUInteger)calcularEdadDeUnaPersonaSegunFechaNacimiento:(NSDate *)fechaNacimiento;





/**
 @brief Función encargada de calcular la diferencia de años entre dos fechas.
 @param aFechaInicial es la fecha inicial de la comparación.
 @param aFechaFinal es la fecha final de la comparación.
 @return años de diferencia entre las fechas. Si la fecha final es menor a la fecha inicial, entonces devolvera una diferencia negativa.
 */
+ (NSTimeInterval)calcularDiferenciaDeAniosEntre:(NSDate *)aFechaInicial conFechaFinal:(NSDate *)aFechaFinal;





/**
 @brief Función encargada de calcular la diferencia de meses entre dos fechas.
 @param aFechaInicial es la fecha inicial de la comparación.
 @param aFechaFinal es la fecha final de la comparación.
 @return meses de diferencia entre las fechas. Si la fecha final es menor a la fecha inicial, entonces devolvera una diferencia negativa.
 */
+ (NSTimeInterval)calcularDiferenciaDeMesesEntre:(NSDate *)aFechaInicial conFechaFinal:(NSDate *)aFechaFinal;





/**
 @brief Función encargada de calcular la diferencia de dias entre dos fechas.
 @param aFechaInicial es la fecha inicial de la comparación.
 @param aFechaFinal es la fecha final de la comparación.
 @return dias de diferencia entre las fechas. Si la fecha final es menor a la fecha inicial, entonces devolvera una diferencia negativa.
 */
+ (NSTimeInterval)calcularDiferenciaDeDiasEntre:(NSDate *)aFechaInicial conFechaFinal:(NSDate *)aFechaFinal;





/**
 @brief Función encargada de calcular la diferencia de horas entre dos fechas.
 @param aFechaInicial es la fecha inicial de la comparación.
 @param aFechaFinal es la fecha final de la comparación.
 @return horas de diferencia entre las fechas. Si la fecha final es menor a la fecha inicial, entonces devolvera una diferencia negativa.
 */
+ (NSTimeInterval)calcularDiferenciaDeHorasEntre:(NSDate *)aFechaInicial conFechaFinal:(NSDate *)aFechaFinal;





/**
 @brief Función encargada de calcular la diferencia de minutos entre dos fechas.
 @param aFechaInicial es la fecha inicial de la comparación.
 @param aFechaFinal es la fecha final de la comparación.
 @return minutos de diferencia entre las fechas. Si la fecha final es menor a la fecha inicial, entonces devolvera una diferencia negativa.
 */
+ (NSTimeInterval)calcularDiferenciaDeMinutosEntre:(NSDate *)aFechaInicial conFechaFinal:(NSDate *)aFechaFinal;





/**
 @brief Función encargada de calcular la diferencia de segundos entre dos fechas.
 @param aFechaInicial es la fecha inicial de la comparación.
 @param aFechaFinal es la fecha final de la comparación.
 @return segundos de diferencia entre las fechas. Si la fecha final es menor a la fecha inicial, entonces devolvera una diferencia negativa.
 */
+ (NSTimeInterval)calcularDiferenciaDeSegundosEntre:(NSDate *)aFechaInicial conFechaFinal:(NSDate *)aFechaFinal;





/**
 @brief Función encargada de calcular la diferencia entre dos fechas. La diferencia se realiza a nivel de todos los componentes: Año, mes, dia, hora y minuto.
 @param aFechaInicial es la fecha inicial de la comparación.
 @param aFechaFinal es la fecha final de la comparación.
 @return estructura que contiene los componentes de la diferencia entre las fechas ingresadas. Si la fecha final es menor a la fecha inicial, entonces devolvera una diferencia negativa en sus componentes.
 */
+ (OSPDiferenciaFechas *)calcularDiferenciaDeFechasEntre:(NSDate *)aFechaInicial conFechaFinal:(NSDate *)aFechaFinal;





/**
 @brief Función encargada de obtener el número de la semana a la cual pertenece una fecha.
 @param aFecha fecha para cualcular a que número de semana del año pertenece.
 @return número de semana de la fecha ingresada.
 */
+ (NSUInteger)obtenerNumeroSemanaEnAnioDeFecha:(NSDate *)aFecha;



+ (NSTimeInterval)calcularDiferenciaDeMesesEntreComponentes:(NSDate *)aFechaInicial conFechaFinal:(NSDate *)aFechaFinal;



+ (NSTimeInterval)calcularDiferenciaDeAniosEntreComponentes:(NSDate *)aFechaInicial conFechaFinal:(NSDate *)aFechaFinal;



+ (NSInteger)obtenerNumeroDiaSemana;



+ (NSDate *)sumarAFecha:(NSDate *)fecha dias:(NSInteger)dias;




@end
