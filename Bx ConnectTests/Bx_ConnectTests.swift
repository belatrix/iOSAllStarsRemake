//
//  Bx_ConnectTests.swift
//  Bx ConnectTests
//
//  Created by Erik Fernando Flores Quispe on 23/05/17.
//  Copyright © 2017 Belatrix. All rights reserved.
//

import XCTest
@testable import Bx_Connect

class Bx_ConnectTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUserEmail() {
        XCTAssert("efflores@belatrixsf.com".isValidEmail)
        XCTAssert("efflores@be.com".isValidEmail)
        XCTAssert("ef@be.com".isValidEmail)
        XCTAssert("ef@be.co".isValidEmail)
        XCTAssert("ef@be.c".isValidEmail)
        XCTAssertFalse("e@be".isValidEmail)
        XCTAssertFalse("eRIK@be.".isValidEmail)
        XCTAssertFalse("eRIK@@be.".isValidEmail)
        XCTAssertFalse("e@@be.".isValidEmail)
        XCTAssertFalse("@be.com".isValidEmail)
    }
    
    func testUserEmailTextField() {
        let newPasswordVC = NewPasswordVC()
        let txtUser = UITextField()
        txtUser.text = "erikfloresq@gmail.com"
        do {
            let user = try? newPasswordVC.validateTextField(user: txtUser)
            XCTAssert("erikfloresq@gmail.com" == user)
        }
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
