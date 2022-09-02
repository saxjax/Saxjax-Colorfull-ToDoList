//
//  TodoeyUnitTests.swift
//  TodoeyUnitTests
//
//  Created by Jakob Skov Søndergård on 30/08/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import XCTest

class MakeColorUnitTest: XCTestCase {
  //  https://rgbacolorpicker.com/hex-to-rgba : get hex and RGBA values from here
  
  struct P:Equatable {
    let r:Int
    let g:Int
    let b:Int
    let a:Int
  }
  func parameterised() throws {
    [
      P(r: 1, g: 2, b: 3, a: 255)
    ]
  }
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testExample() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    // Any test you write for XCTest can be annotated as throws and async.
    // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
    // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
  }
  
  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    measure {
      // Put the code you want to measure the time of here.
    }
  }
  
  func test_UIColorToRGBA_returns_correct_rgba()throws{
    //    arr
    let RGBA: P = P(r: 1, g: 2, b: 3, a: 255)
    let color = UIColor(red: CGFloat(RGBA.r)/255, green: CGFloat(RGBA.g)/255, blue: CGFloat(RGBA.b)/255, alpha: CGFloat(RGBA.a/255))
    let expected = (r: RGBA.r, g: RGBA.g, b: RGBA.b, a: RGBA.a)
    //    act
    let colorData = MakeColor.UIColorToRGBA(from: color)
    //    assert
    XCTAssertNotNil(colorData,"did not convert color to RGBA data")
    if let actual = colorData{
      XCTAssertEqual(actual.r , expected.r ,"""
                                        colors dont return correct rgba values:
                                        actual    \(actual.r)
                                        expected  \(RGBA.r)
                                        """)
      XCTAssertEqual(actual.g , expected.g ,"""
                                        colors dont return correct rgba values:
                                        actual    \(actual.g)
                                        expected  \(RGBA.g)
                                        """)
      XCTAssertEqual(actual.b , expected.b ,"""
                                        colors dont return correct rgba values:
                                        actual    \(actual.b)
                                        expected  \(RGBA.b)
                                        """)
      XCTAssertEqual(actual.a , expected.a ,"""
                                        colors dont return correct rgba values:
                                        actual    \(actual.a)
                                        expected  \(RGBA.a)
                                        """)
    }
    
    
  }
  
  func test_UIColorToHexString()throws{
    //      arr
    let RGBA: P = P(r: 127, g: 17, b: 224, a: 255)
    let color = UIColor(red: CGFloat(RGBA.r)/255, green: CGFloat(RGBA.g)/255, blue: CGFloat(RGBA.b)/255, alpha: CGFloat(RGBA.a)/255)
    let expected = "#7f11e0ff"
    //      act
    let hexString = MakeColor.UIColorToHexString(from: color)
    //      assert
    
    XCTAssertNotNil(hexString)
    if let actual = hexString{
      XCTAssertEqual(actual,expected,"""
                                     hexString is not decoded correct
                                     actual:   \(actual)
                                     expected: \(expected)
                                     """)
    }
  }
  
  func test_RGBAToHexString()throws{
    //    arr
    let RGBA = (r: 127, g: 17, b: 224, a: 255)
    let expected = "#7f11e0ff"
    //    act
    let result = MakeColor.RGBAToHex(from: RGBA)
    //    assert
    XCTAssertNotNil(result, """
                                      Bad conversion from RGBA to HEX
                                      converting from RGBA \(RGBA) gave nil
                            """)
    if let actual = result {
      XCTAssertEqual(actual, expected, """
                                      Bad conversion from RGBA to HEX
                                      actual hex \(actual)
                                      expected hex \(expected)
                                      from RGBA \(RGBA)
                                      """)
    }
    
  }
  
  func test_Hex8StringToRGBA()throws{
    //    arr
    let hexstring = "#7f11e0ff"
    let expected = (r: 127, g: 17, b: 224, a: 255)
    //    act
    let RGBA = MakeColor.Hex8StringToRGBA(from: hexstring)
    //    assert
    if let actual = RGBA {
      XCTAssertEqual(actual.r , expected.r ,"""
                                        colors dont return correct rgba values:
                                        actual r    \(actual.r)
                                        expected r  \(expected.r)
                                        """)
      XCTAssertEqual(actual.g , expected.g ,"""
                                        colors dont return correct rgba values:
                                        actual g    \(actual.g)
                                        expected g  \(expected.g)
                                        """)
      XCTAssertEqual(actual.b , expected.b ,"""
                                        colors dont return correct rgba values:
                                        actual b   \(actual.b)
                                        expected b  \(expected.b)
                                        """)
      XCTAssertEqual(actual.a , expected.a ,"""
                                        colors dont return correct rgba values:
                                        actual a    \(actual.a)
                                        expected a  \(expected.a)
                                        """)
    }
    
  }
  
  //  func test_color_from_hexString()throws{
  ////    arr
  //    let hexstring = "#7f11e0ff"
  //    let RGBA: P = P(r: 127/255, g: 17/255, b: 224/255, a: 255/255)
  //    let expected = UIColor(red: CGFloat(RGBA.r)/255, green: CGFloat(RGBA.g)/255, blue: CGFloat(RGBA.b)/255, alpha: CGFloat(RGBA.a)/255)
  //
  ////    act
  //    let actual = MakeColor.color(fromHex: hexstring)
  ////    assert
  //    XCTAssertNotNil(actual, """
  //                                    hexString \(hexstring) did not result in expected color
  //                                    from RGBA \(RGBA)
  //                                    """)
  //
  //  }
  
}
