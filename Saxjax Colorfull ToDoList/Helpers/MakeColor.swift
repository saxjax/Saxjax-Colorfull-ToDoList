//
//  MakeColor.swift
//  Todoey
//
//  Created by Jakob Skov Søndergård on 29/08/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import UIKit



struct MakeColor {

  static func randRGBA()->(r:Int,g:Int,b:Int,a:Int){
    let randR = Int.random(in: 0...255)
    let randG = Int.random(in: 0...255)
    let randB = Int.random(in: 0...255)
    let randA = Int.random(in: 0...255)
    return (r:randR,g:randG,b:randB, a:randA)
  }

  static func randomHex()->String{
    let RGBA = randRGBA()
    let hexString = RGBAToHex(from: RGBA)
    return hexString!
  }

  /// This function dont set the alpha at random
  static func randColor()->UIColor{
    let RGBA = randRGBA()
    return UIColor(red: CGFloat(RGBA.r/255), green: CGFloat(RGBA.g/255), blue: CGFloat(RGBA.b/255), alpha: 1)
  }

  static func UIColorToRGBA(from color:UIColor)->(r:Int,g:Int,b:Int,a:Int)?{
    var r:CGFloat = 0
    var g:CGFloat = 0
    var b:CGFloat = 0
    var a:CGFloat = 0

    let success = color.getRed(&r, green: &g, blue: &b, alpha: &a)
    switch success {
      case true:
        return (r:Int(r*255),g:Int(g*255),b:Int(b*255),a:Int(a*255))
      default:
        return nil
    }
  }

  static func UIColorToHexString(from color:UIColor)->String?{
    var hexString:String?

    if let RGBA = UIColorToRGBA(from: color){

      hexString = RGBAToHex(from: RGBA)
    }

    return hexString
  }

  static func RGBAToHex(from RGBA:(r:Int,g:Int,b:Int,a:Int))->String?{
//    var hexString:String?

    let rgb:Int = (Int)(RGBA.r)<<24 | (Int)(RGBA.g)<<16 | (Int)(RGBA.b)<<8 | (Int)(RGBA.a)<<0
    let hexString = String(format:"#%08x", rgb)

    return hexString
  }

  static func Hex8StringToRGBA(from hexstring:String)->(r:Int,g:Int,b:Int,a:Int)?{

    if //let r_prefix = Range(NSRange(location: 0, length: 1), in: hexString),
       let r_range = Range(NSRange(location: 1, length: 2), in:  hexstring),
       let g_range = Range(NSRange(location: 3, length: 2), in:  hexstring),
       let b_range = Range(NSRange(location: 5, length: 2), in:  hexstring),
       let a_range = Range(NSRange(location: 7, length: 2), in:  hexstring) {

      let r_string = String( hexstring[r_range])
      let g_string = String( hexstring[g_range])
      let b_string = String( hexstring[b_range])
      let a_string = String( hexstring[a_range])


      if let r = Int(r_string, radix:16),
         let g = Int(g_string, radix:16),
         let b = Int(b_string, radix:16),
         let a = Int(a_string, radix:16) {

        return (r:r,g:g,b:b,a:a)

      }
    }

    return nil
  }

  static func color(from hexString:String?)->UIColor?{
    var color:UIColor?

    if let _hexString = hexString ,let RGBA = Hex8StringToRGBA(from: _hexString){

      color = UIColor(red: CGFloat(RGBA.r)/255, green: CGFloat(RGBA.g)/255, blue: CGFloat(RGBA.b)/255, alpha:1.0/*CGFloat(RGBA.a/255*/)
      }
    return color
  }

  ///https://24ways.org/2010/calculating-color-contrast/ info on yiq contrasting color
  static func contrastingColor(from hexString: String?)->UIColor?{
    var color:UIColor?

    if let _hexString = hexString ,let RGBA = Hex8StringToRGBA(from: _hexString){
      let yiq = ((RGBA.r*299)+(RGBA.g*587)+(RGBA.b*114))/1000

      color = yiq >= 128 ? UIColor.black : UIColor.white
    }
    return color
  }

  ///breaking function, it must succeed
  static func contrastingColor(from uicolor: UIColor)->UIColor{
    let hexString = UIColorToHexString(from: uicolor)!
    return contrastingColor(from: hexString)!
  }


  static func closeColor(from uicolor: UIColor, steps: Int)->UIColor{

    var h:CGFloat = 0
    var s:CGFloat = 0
    var b:CGFloat = 0
    var a:CGFloat = 0

    var change:CGFloat {return CGFloat(steps)/255}

    var nextHueValue:CGFloat{
      h-change > 0 ? h-change : -h+(change + 0.02)
    }

//    var nextSaturationValue:CGFloat{
//      s-change > 0 ? s-change : -s+change
//    }
//
//    var nextBrightnessValue:CGFloat{
//      b-change > 0 ? (b-change)/2 : (-b+change)
//    }

    guard uicolor.getHue(&h, saturation: &s, brightness: &b, alpha: &a) else {return uicolor}

    return UIColor(hue: nextHueValue , saturation: s, brightness: b, alpha: a)

  }


}
