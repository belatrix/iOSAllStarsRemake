//
//  OSPDateManager.m
//  OSPDateManager v2.0.0
//
//  Created by Kenyimetal on 9/12/14.
//  Copyright (c) 2014 Belatrix SF. All rights reserved.
//

#import "OSPDateManager.h"


@implementation OSPDiferenciaFechas


@end


@implementation OSPDateManager




/**
 @brief Función que convierte un TimeStamp en NSDate.
 @param aTimestamp es el timestamp a convertir a NSDate.
 @return Fecha obtenida a partir del timestamp.
 */
+ (NSDate *)convertirTimestampDate:(NSString *)aTimestamp{
    
    NSTimeInterval intervalo = [aTimestamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:intervalo];
    return date;
}





/**
 @brief Función encargada de convertir un texto que tiene la forma de una fecha en una NSDate.
 @param aFecha texto con formato de fecha a convertir.
 @param aFormato formato de fecha en la que se encuentra la fecha recibida como parámetro.
 @return Fecha convertida.
 */
+ (NSDate *)convertirTexto:(NSString *)aFecha conFormato:(NSString *)aFormato{
    
    NSLocale *uslocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:uslocale];
    [dateFormat setDateFormat:aFormato];
    return [dateFormat dateFromString:aFecha];
}





/**
 @brief Función encargada de dar un tipo de formato de fecha a un NSDate
 @param aFecha es la fecha que se desea cambiar de formato.
 @param aFormato es el formato al cual se cambiara la fecha. estos pueden ser mencionados en el header de la clase.
 @return Cadena de texto con la forma del formato de la fecha.
 */
+ (NSString *)convertirFecha:(NSDate *)aFecha conFormato:(NSString *)aFormato{
    
    NSLocale *uslocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:uslocale];
    [dateFormat setDateFormat:aFormato];
    return [dateFormat stringFromDate:aFecha];
}





/**
 @brief Función encargada de dar un tipo de formato de fecha a un NSDate según el locale de una región.
 @param aFecha es la fecha que se desea cambiar de formato.
 @param aFormato es el formato al cual se cambiara la fecha. estos pueden ser mencionados en el header de la clase.
 @param locale es el parámetro de región. Por defecto se ejecuta en la región de USA (en_US) un posible parámetro es la región de Perú (es_PE).
 @return Cadena de texto con la forma del formato de la fecha.
 */
+ (NSString *)convertirFecha:(NSDate *)aFecha alFormato:(NSString *)aFormato locale:(NSString *)locale{
    
    NSLocale *uslocale = [[NSLocale alloc] initWithLocaleIdentifier:locale ? locale : @"en_US"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:uslocale];
    [dateFormat setDateFormat:aFormato];
    return [dateFormat stringFromDate:aFecha];
}






/**
 @brief Función encargada de calcular la edad de una persona.
 @param fechaNacimiento es la fecha de nacimiento de la persona.
 @return La edad de una persona según la fecha de nacimiento ingresada.
 */
+ (NSUInteger)calcularEdadDeUnaPersonaSegunFechaNacimiento:(NSDate *)fechaNacimiento{
    
    NSDate *fechaActual = [NSDate date];
    NSDateComponents *componentesEdad = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:fechaNacimiento toDate:fechaActual options:0];
    NSUInteger edad = [componentesEdad year];

    return edad;
}







/**
 @brief Función encargada de calcular la diferencia de años entre dos fechas.
 @param aFechaInicial es la fecha inicial de la comparación.
 @param aFechaFinal es la fecha final de la comparación.
 @return años de diferencia entre las fechas. Si la fecha final es menor a la fecha inicial, entonces devolvera una diferencia negativa.
 */
+ (NSTimeInterval)calcularDiferenciaDeAniosEntre:(NSDate *)aFechaInicial conFechaFinal:(NSDate *)aFechaFinal{
    
    NSDate *fromDate = [aFechaInicial compare:aFechaFinal] == NSOrderedAscending ? aFechaInicial : aFechaFinal;
    NSDate *toDate = [aFechaInicial compare:aFechaFinal] == NSOrderedAscending ? aFechaFinal : aFechaInicial;
    
    NSDateComponents *componenteDiferencia = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:fromDate toDate:toDate options:0];
    NSTimeInterval diferencia = [componenteDiferencia year];
    
    NSInteger factor = [aFechaInicial compare:aFechaFinal] == NSOrderedAscending ? 1 : -1;
    
    return diferencia * factor;
}






/**
 @brief Función encargada de calcular la diferencia de meses entre dos fechas.
 @param aFechaInicial es la fecha inicial de la comparación.
 @param aFechaFinal es la fecha final de la comparación.
 @return meses de diferencia entre las fechas. Si la fecha final es menor a la fecha inicial, entonces devolvera una diferencia negativa.
 */
+ (NSTimeInterval)calcularDiferenciaDeMesesEntre:(NSDate *)aFechaInicial conFechaFinal:(NSDate *)aFechaFinal{
    
    NSDate *fromDate = [aFechaInicial compare:aFechaFinal] == NSOrderedAscending ? aFechaInicial : aFechaFinal;
    NSDate *toDate = [aFechaInicial compare:aFechaFinal] == NSOrderedAscending ? aFechaFinal : aFechaInicial;
    
    NSDateComponents *componenteDiferencia = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:fromDate toDate:toDate options:0];
    NSTimeInterval diferencia = [componenteDiferencia month];
    
    NSInteger factor = [aFechaInicial compare:aFechaFinal] == NSOrderedAscending ? 1 : -1;
    
    return diferencia * factor;
}







/**
 @brief Función encargada de calcular la diferencia de dias entre dos fechas.
 @param aFechaInicial es la fecha inicial de la comparación.
 @param aFechaFinal es la fecha final de la comparación.
 @return dias de diferencia entre las fechas. Si la fecha final es menor a la fecha inicial, entonces devolvera una diferencia negativa.
 */
+ (NSTimeInterval)calcularDiferenciaDeDiasEntre:(NSDate *)aFechaInicial conFechaFinal:(NSDate *)aFechaFinal{
    
    NSDate *fromDate = [aFechaInicial compare:aFechaFinal] == NSOrderedAscending ? aFechaInicial : aFechaFinal;
    NSDate *toDate = [aFechaInicial compare:aFechaFinal] == NSOrderedAscending ? aFechaFinal : aFechaInicial;
    
    NSDateComponents *componenteDiferencia = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    NSTimeInterval diferencia = [componenteDiferencia day];
    
    NSInteger factor = [aFechaInicial compare:aFechaFinal] == NSOrderedAscending ? 1 : -1;
    
    return diferencia * factor;
}







/**
 @brief Función encargada de calcular la diferencia de horas entre dos fechas.
 @param aFechaInicial es la fecha inicial de la comparación.
 @param aFechaFinal es la fecha final de la comparación.
 @return horas de diferencia entre las fechas. Si la fecha final es menor a la fecha inicial, entonces devolvera una diferencia negativa.
 */
+ (NSTimeInterval)calcularDiferenciaDeHorasEntre:(NSDate *)aFechaInicial conFechaFinal:(NSDate *)aFechaFinal{
    
    NSDate *fromDate = [aFechaInicial compare:aFechaFinal] == NSOrderedAscending ? aFechaInicial : aFechaFinal;
    NSDate *toDate = [aFechaInicial compare:aFechaFinal] == NSOrderedAscending ? aFechaFinal : aFechaInicial;
    
    NSDateComponents *componenteDiferencia = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:fromDate toDate:toDate options:0];
    NSTimeInterval diferencia = [componenteDiferencia hour];
    
    NSInteger factor = [aFechaInicial compare:aFechaFinal] == NSOrderedAscending ? 1 : -1;
    
    return diferencia * factor;
}






/**
 @brief Función encargada de calcular la diferencia de minutos entre dos fechas.
 @param aFechaInicial es la fecha inicial de la comparación.
 @param aFechaFinal es la fecha final de la comparación.
 @return minutos de diferencia entre las fechas. Si la fecha final es menor a la fecha inicial, entonces devolvera una diferencia negativa.
 */
+ (NSTimeInterval)calcularDiferenciaDeMinutosEntre:(NSDate *)aFechaInicial conFechaFinal:(NSDate *)aFechaFinal{
    
    NSDate *fromDate = [aFechaInicial compare:aFechaFinal] == NSOrderedAscending ? aFechaInicial : aFechaFinal;
    NSDate *toDate = [aFechaInicial compare:aFechaFinal] == NSOrderedAscending ? aFechaFinal : aFechaInicial;
    
    NSDateComponents *componenteDiferencia = [[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:fromDate toDate:toDate options:0];
    NSTimeInterval diferencia = [componenteDiferencia minute];
    
    NSInteger factor = [aFechaInicial compare:aFechaFinal] == NSOrderedAscending ? 1 : -1;
    
    return diferencia * factor;
}







/**
 @brief Función encargada de calcular la diferencia de segundos entre dos fechas.
 @param aFechaInicial es la fecha inicial de la comparación.
 @param aFechaFinal es la fecha final de la comparación.
 @return segundos de diferencia entre las fechas. Si la fecha final es menor a la fecha inicial, entonces devolvera una diferencia negativa.
 */
+ (NSTimeInterval)calcularDiferenciaDeSegundosEntre:(NSDate *)aFechaInicial conFechaFinal:(NSDate *)aFechaFinal{
    
    NSDate *fromDate = [aFechaInicial compare:aFechaFinal] == NSOrderedAscending ? aFechaInicial : aFechaFinal;
    NSDate *toDate = [aFechaInicial compare:aFechaFinal] == NSOrderedAscending ? aFechaFinal : aFechaInicial;
    
    NSDateComponents *componenteDiferencia = [[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:fromDate toDate:toDate options:0];
    NSTimeInterval diferencia = [componenteDiferencia second];
    
    NSInteger factor = [aFechaInicial compare:aFechaFinal] == NSOrderedAscending ? 1 : -1;
    
    return diferencia * factor;
}







/**
 @brief Función encargada de calcular la diferencia entre dos fechas. La diferencia se realiza a nivel de todos los componentes: Año, mes, dia, hora, minuto y segundo.
 @param aFechaInicial es la fecha inicial de la comparación.
 @param aFechaFinal es la fecha final de la comparación.
 @return estructura que contiene los componentes de la diferencia entre las fechas ingresadas. Si la fecha final es menor a la fecha inicial, entonces devolvera una diferencia negativa en sus componentes.
 */
+ (OSPDiferenciaFechas *)calcularDiferenciaDeFechasEntre:(NSDate *)aFechaInicial conFechaFinal:(NSDate *)aFechaFinal{
    
    NSDate *fromDate = [aFechaInicial compare:aFechaFinal] == NSOrderedAscending ? aFechaInicial : aFechaFinal;
    NSDate *toDate = [aFechaInicial compare:aFechaFinal] == NSOrderedAscending ? aFechaFinal : aFechaInicial;
    
    NSDateComponents *componenteDiferencia = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:fromDate toDate:toDate options:0];

    
    NSInteger factor = [aFechaInicial compare:aFechaFinal] == NSOrderedAscending ? 1 : -1;
    
    OSPDiferenciaFechas *diferenciaEntreFechas = [[OSPDiferenciaFechas alloc] init];
    
    diferenciaEntreFechas.anios    = [componenteDiferencia year]   * factor;
    diferenciaEntreFechas.meses    = [componenteDiferencia month]  * factor;
    diferenciaEntreFechas.dias     = [componenteDiferencia day]    * factor;
    diferenciaEntreFechas.horas    = [componenteDiferencia hour]   * factor;
    diferenciaEntreFechas.minutos  = [componenteDiferencia minute] * factor;
    diferenciaEntreFechas.segundos = [componenteDiferencia second] * factor;
    
    return diferenciaEntreFechas;
}







/**
 @brief Función encargada de obtener el número de la semana a la cual pertenece una fecha.
 @param aFecha fecha para cualcular a que número de semana del año pertenece.
 @return número de semana de la fecha ingresada.
 */
+ (NSUInteger)obtenerNumeroSemanaEnAnioDeFecha:(NSDate *)aFecha{
    
    NSDateComponents *componentes = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:aFecha];
    return [componentes weekOfYear];
}



+ (NSTimeInterval)calcularDiferenciaDeMesesEntreComponentes:(NSDate *)aFechaInicial conFechaFinal:(NSDate *)aFechaFinal{
    
    
    NSDate *fromDate = [aFechaInicial compare:aFechaFinal] == NSOrderedAscending ? aFechaInicial : aFechaFinal;
    NSDate *toDate = [aFechaInicial compare:aFechaFinal] == NSOrderedAscending ? aFechaFinal : aFechaInicial;
    
    NSDateComponents *componenteDiferenciaFrom = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:fromDate];
    NSTimeInterval diferenciaFrom = [componenteDiferenciaFrom month];
    
    NSDateComponents *componenteDiferenciaTo = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:toDate];
    NSTimeInterval diferenciaTo = [componenteDiferenciaTo month];
    
    NSInteger factor = [aFechaInicial compare:aFechaFinal] == NSOrderedAscending ? 1 : -1;
    NSTimeInterval diferencia = (diferenciaTo - diferenciaFrom) * factor;
    
    
    return diferencia + 12*[self calcularDiferenciaDeAniosEntreComponentes:aFechaInicial conFechaFinal:aFechaFinal];
}


+ (NSTimeInterval)calcularDiferenciaDeAniosEntreComponentes:(NSDate *)aFechaInicial conFechaFinal:(NSDate *)aFechaFinal{
    
    
    NSDate *fromDate = [aFechaInicial compare:aFechaFinal] == NSOrderedAscending ? aFechaInicial : aFechaFinal;
    NSDate *toDate = [aFechaInicial compare:aFechaFinal] == NSOrderedAscending ? aFechaFinal : aFechaInicial;
    
    NSDateComponents *componenteDiferenciaFrom = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:fromDate];
    NSTimeInterval diferenciaFrom = [componenteDiferenciaFrom year];
    
    NSDateComponents *componenteDiferenciaTo = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:toDate];
    NSTimeInterval diferenciaTo = [componenteDiferenciaTo year];
    
    NSInteger factor = [aFechaInicial compare:aFechaFinal] == NSOrderedAscending ? 1 : -1;
    NSTimeInterval diferencia = (diferenciaTo - diferenciaFrom) * factor;
    
    return diferencia;
}


+ (NSInteger)obtenerNumeroDiaSemana{
    
    NSDate *fechaActual = [NSDate date];
    NSDateFormatter *formatoFecha = [[NSDateFormatter alloc] init];
    [formatoFecha setDateFormat:@"e"];
    NSInteger numeroDiaSemana = (NSInteger)[[formatoFecha stringFromDate:fechaActual] integerValue];
    
    return numeroDiaSemana == 1 ? 7 : numeroDiaSemana - 1;
}


+ (NSDate *)sumarAFecha:(NSDate *)fecha dias:(NSInteger)dias{
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = dias;
    
    NSCalendar *calendario = [NSCalendar currentCalendar];
    NSDate *nuevaFecha = [calendario dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    
    return nuevaFecha;
}


@end
