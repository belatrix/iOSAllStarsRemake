//
//  Constants.h
//  AllStars
//
//  Created by Flavio Franco Tunqui on 6/16/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

// WebServices
#define WEB_SERVICES @"https://test2.alignetsac.com/WALLETWS/rest/mobile/"

#define WS_CONSULT @"consulte"
#define WS_AUTHORIZE @"authorize"

// TimeOut
#define TIMEOUT ((int) 30)

// PGP
#define KEY_PRIVATE @"key_private.asc"
#define KEY_PUBLIC @"key_public.asc"

// Height
#define iPhone4Height ((CGFloat) 480.0)
#define iPhone5Height ((CGFloat) 568.0)

// DataBase
#define TAG_NAME_DB @"PayMeDB.db"

// Parse
#define CODE_ANSWER_SUCCESS @"000"
#define CODE_ERROR @"999"
#define CODE_COMMERCE_REQUIRED @"001"
#define CODE_NO_COMMERCE_FOUND @"022"

#define CODE_TOKKEN_INVALID @"020"
#define CODE_TRANSACION_REFUSED @"025"

// Information Card
#define ID_VISA @"1"
#define ID_MASTERCARD @"2"
#define ID_AMERICANEXPRESS @"3"
#define ID_CMR @"4"
#define ID_DINERSCLUB @"7"

// MARK: - Parse TAGS
// GENERAL
#define TAG_DATE @"date"
#define TAG_HOUR @"hour"

// WS_CONSULT
#define TAG_ANS_CODE @"ansCode"
#define TAG_ANS_DESCRIPTION @"ansDescription"
#define TAG_BRAND_LIST @"brandList"
#define TAG_COD_ASO_CARD_HORDER_WALLET @"codAsoCardHolderWallet"
#define TAG_LASTNAME_CARD_HOLDER @"lastnameCardholder"
#define TAG_NAME_CARD_HOLDER @"nameCardholder"
#define TAG_NEED_AUTHORIZATION @"needAutorization"
#define TAG_TOKKEN @"tokken"
#define TAG_LIST_CARDS @"listCards"

// WS_AUTHORIZE
#define TAG_ERROR_CODE @"errorCode"
#define TAG_ERROR_DESCRIPTION @"errorMessage"
#define TAG_AUTHORIZED_AMOUNT @"authorizedAmount"
#define TAG_CVV2_MASK @"CVV2mask"
#define TAG_OPERATION_NUMBER @"operationNumber"
#define TAG_ID_TRANSACTION @"idTransaction"

// CARD
#define TAG_ID_CARD @"idCard"
#define TAG_BRAND @"brand"
#define TAG_ID_ADDRESS @"idAddress"
#define TAG_CARD_DESCRIPTION @"cardDescription"
#define TAG_CARD_NUMBER @"cardNumber"
#define TAG_CARD_EXPIRED @"cardExpired"
#define TAG_PRIMARY_CARD @"primaryCard"
#define TAG_BANK @"bank"
#define TAG_CARD_TYPE @"cardType"

#endif /* Constants_h */