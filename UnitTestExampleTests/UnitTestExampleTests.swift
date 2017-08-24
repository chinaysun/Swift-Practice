//
//  UnitTestExampleTests.swift
//  UnitTestExampleTests
//
//  Created by SUN YU on 24/8/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import XCTest
@testable import UnitTestExample // This allows to import the method in the project

class UnitTestExampleTests: XCTestCase {
    
    func testHelloWorld()
    {
        var helloWorld:String?
        
        XCTAssertNil(helloWorld)
        
        helloWorld = "HELLO WORLD"
        
        XCTAssertEqual(helloWorld, "HELLO WORLD")
        
    }
    
    func testSqureInt()
    {
        
        let value = 3
        
        let suqaredValue = value.square()
        
        
        //Check if the function goes well,the value is equaled
        XCTAssertEqual(suqaredValue, 9)
        
        
    }
}
