//
//  Regex.swift
//  Bx Connect
//
//  Created by Erik Fernando Flores Quispe on 24/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

struct Regex {
    static let alphabet = "^[a-zA-ZáéíóúÁÉÍÓÚñÑäëïöüÿÄËÏÖÜ ]+$"
    static let alphNumeric = "^[a-zA-Z0-9áéíóúÁÉÍÓÚñÑäëïöüÿÄËÏÖÜ ]+$"
    static let email = "^[a-z0-9\\_\\-]+(\\.?[a-z0-9\\_\\-]+)+@\\w+([\\.-]\\w+)+$"
    static let video = "((?:https?:\\/{2})?(?:w{3}\\.)?youtu(?:be)?\\.(?:com|be)(?:\\/watch\\?v=|\\/)([^\\s&]+))|(?:https?:\\/{2})?(?:w{3}\\.)?vimeo.com\\/(.*)"
    static let address = "^[a-zA-Z0-9áéíóúÁÉÍÓÚñÑ&.,äëïöüÿÄËÏÖÜ \\-]+$"
    static let dni = "^[0-9]{8}$"
    static let password = "^[a-zA-Z0-9._%+-@]{3,32}$"
    static let housePhone = "^[0-9]{6,12}$"
    static let mobilePhone = "^[0-9]{9,12}$"
}
