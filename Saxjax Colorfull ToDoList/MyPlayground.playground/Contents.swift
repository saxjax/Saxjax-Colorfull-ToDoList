import UIKit

//let hexString = "#fff468ff"
//let color = MakeColor.color(from:hexString )
//let color2 = MakeColor.color(from:"#7555fbff" )
//let contrastColor = MakeColor.contrastingColor(from: hexString)
//
//var colors:[UIColor] = []
//for i in 0...512{
//  colors.append( (MakeColor.closeColor(from: color!, steps: i)) )
//}
//
//colors

let hexstring_darkblue = "#ffd868ff"
let darkblue = MakeColor.color(from: hexstring_darkblue)
let string = MakeColor.UIColorToHexString(from: darkblue!)
let closecolor = MakeColor.closeColor(from: darkblue!, steps: 1)
let contrastcolor = MakeColor.contrastingColor(from: hexstring_darkblue)
let contrastcolor2 = MakeColor.contrastingColor(from: darkblue!)
