//
//  WSColourScheme.swift
//  WSColourSchemeSwift
//
//  Created by Will Swan on 31/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

/*
 * Static Constants
*/
internal struct Constants {
    
    internal struct WSCSConstants {
        
        //WSColourSchemeSwift Version
        static let WSCS_VERSION = "1.0.0"
        
    }
    
    internal struct WSCSRGBValues {
        
        //RGB Values
        static let WSCSCustomDefaultRGB = [String](arrayLiteral: "0,0,0","0,0,0","0,0,0","0,0,0","0,0,0")
        static let WSCSDarkSeaRGB = [String](arrayLiteral: "196,273,218","135,187,162","102,201,186","85,130,139","47,112,108")
        static let WSCSEarthRGB = [String](arrayLiteral: "126,151,13","210,212,68","244,242,191","255,205,5","206,72,5")
        static let WSCSMalachiteRGB = [String](arrayLiteral: "20,206,105","186,255,210","88,216,144","255,255,255","28,125,137")
        static let WSCSAquamarineRGB = [String](arrayLiteral: "196,237,218","77,80,87","102,201,186","104,166,145","47,112,108")
        static let WSCSTangeloRGB = [String](arrayLiteral: "94,11,21","201,80,0","255,179,109","255,16,0","214,,138,17")
        static let WSCSAmaranthRGB = [String](arrayLiteral: "239,158,188",
        "242,186,206","237,220,228","226,204,214","214,182,196")
        static let WSCSParadiseRGB = [String](arrayLiteral: "188,56,83","239,62,97","252,133,165","243,117,43","247,157,92")
        static let WSCSSunglowRGB = [String](arrayLiteral: "178,34,34","255,140,0","255,165,0","253,184,51","255,215,0")
        static let WSCSCeruleanRGB = [String](arrayLiteral: "4,83,122","34,191,216","215,239,255","245,249,251","255,255,255")
        static let WSCSEucalyptusRGB = [String](arrayLiteral: "47,151,186","61,184,217","64,207,180","146,227,212","242,95,92")
        static let WSCSDesireRGB = [String](arrayLiteral: "0,48,99","249,200,14","255,119,0","248,102,36","234,53,70")
        static let WSCSSeaRGB = [String](arrayLiteral: "0,48,99","0,156,218","2,128,144","185,227,198","234,244,211")
        static let WSCSRegaliaRGB = [String](arrayLiteral: "57,16,93","129,82,157","89,47,122","255,255,255","192,180,207")
        static let WSCSVividSkyRGB = [String](arrayLiteral: "8,120,135","7,212,239","0,179,203","209,249,255","26,199,221")
        static let WSCSLagoonRGB = [String](arrayLiteral: "61,204,199","104,216,214","0,179,203","156,234,239","196,255,249")
        static let WSCSAzureishRGB = [String](arrayLiteral: "56,63,81","221,219,241","186,173,164","250,251,244","107,124,127")
        static let WSCSSurfRGB = [String](arrayLiteral: "3,37,108","37,65,178","0,179,203","23,104,172","255,255,255")
        static let WSCSWaterspoutRGB = [String](arrayLiteral: "149,249,227","105,235,208","73,212,157","97,221,180","0,255,157")
        static let WSCSChestnutRGB = [String](arrayLiteral: "130,96,46","132,71,53","173,136,91","203,208,129","145,136,104")
        static let WSCSPastelRGB = [String](arrayLiteral: "242,252,255","179,202,206","190,209,198","239,247,210","163,255,235")
        static let WSCSPictonRGB = [String](arrayLiteral: "5,74,145","239,248,226","75,179,253","62,102,128","173,168,182")
        static let WSCSSiennaRGB = [String](arrayLiteral: "19,80,91","0,130,142","0,162,176","170,65,23","140,53,19")
        static let WSCSLicoriceRGB = [String](arrayLiteral: "14,22,45","38,4,19","0,38,22","65,109,76","199,232,167")
        static let WSCSCardinalRGB = [String](arrayLiteral: "253,85,102","32,68,124","179,27,66","190,25,55","237,243,243")
        static let WSCSLazuliRGB = [String](arrayLiteral: "36,123,161","178,217,190","231,39,88","240,241,189","255,192,159")
        static let WSCSIsabellineRGB = [String](arrayLiteral: "218,115,153","226,171,186","44,119,131","0,0,0","245,234,233")
        static let WSCSRussetRGB = [String](arrayLiteral: "95,113,105","133,133,121","68,49,35","100,109,112","123,77,23")
        static let WSCSBistreRGB = [String](arrayLiteral: "56,38,22","189,109,72","249,178,167","216,192,119","242,227,174")
        static let WSCSTuscanyRGB = [String](arrayLiteral: "177,153,148","214,209,205","255,250,251","125,226,209","51,153,137")
        static let WSCSBlossomRGB = [String](arrayLiteral: "59,100,225","255,167,216","245,215,221","250,185,202","231,231,231")
        static let WSCSTeaRGB = [String](arrayLiteral: "79,52,90","243,249,210","203,234,166","192,214,132","0,0,0")
        static let WSCSJellyBeanRGB = [String](arrayLiteral: "273,237,237","43,89,195","255,186,73","32,163,158","232,98,82")
        static let WSCSWeldonRGB = [String](arrayLiteral: "94,101,114","125,152,161","255,250,251","226,194,198","140,26,206")
        static let WSCSPeriwinkleRGB = [String](arrayLiteral: "191,204,245","141,86,219","163,0,135","77,7,121","27,4,117")
        static let WSCSTulipRGB = [String](arrayLiteral: "239,223,117","127,126,255","242,41,41","246,130,140","244,144,78")
        static let WSCSBlueBellRGB = [String](arrayLiteral: "72,137,141","183,210,208","243,201,189","242,180,191","156,161,190")
        static let WSCSOchreRGB = [String](arrayLiteral: "216,120,17","249,59,8","188,57,1","229,192,5","255,192,72")
        static let WSCSMoonStoneRGB = [String](arrayLiteral: "0,0,0","0,0,0","0,108,132","110,181,192","226,232,228")
        static let WSCSWhitesRGB = [String](arrayLiteral: "238,242,241","247,244,249","243,244,246","239,239,239","229,235,234")
        static let WSCSMidnightRGB = [String](arrayLiteral: "0,30,56","3,43,67","3,56,96","30,69,127","35,76,115")
        
    }
    
}

/*
 * Colour Schemes
*/
public typealias WSCScheme = Int
var WSCSchemeCustom:WSCScheme = 0
var WSCSchemeDarkSea:WSCScheme = 1
var WSCSchemeEarth:WSCScheme = 2
var WSCSchemeMalachite:WSCScheme = 3
var WSCSchemeAquamarine:WSCScheme = 4
var WSCSchemeTangelo:WSCScheme = 5
var WSCSchemeAmaranth:WSCScheme = 6
var WSCSchemeParadise:WSCScheme = 7
var WSCSchemeSunglow:WSCScheme = 8
var WSCSchemeCerulean:WSCScheme = 9
var WSCSchemeEucalyptus:WSCScheme = 10
var WSCSchemeDesire:WSCScheme = 11
var WSCSchemeSea:WSCScheme = 12
var WSCSchemeRegalia:WSCScheme = 13
var WSCSchemeVividSky:WSCScheme = 14
var WSCSchemeLagoon:WSCScheme = 15
var WSCSchemeAzureish:WSCScheme = 16
var WSCSchemeSurf:WSCScheme = 17
var WSCSchemeWaterspout:WSCScheme = 18
var WSCSchemeChestnut:WSCScheme = 19
var WSCSchemePastel:WSCScheme = 20
var WSCSchemePicton:WSCScheme = 21
var WSCSchemeSienna:WSCScheme = 22
var WSCSchemeLicorice:WSCScheme = 23
var WSCSchemeCardinal:WSCScheme = 24
var WSCSchemeLazuli:WSCScheme = 25
var WSCSchemeIsabelline:WSCScheme = 26
var WSCSchemeRusset:WSCScheme = 27
var WSCSchemeBistre:WSCScheme = 28
var WSCSchemeTuscany:WSCScheme = 29
var WSCSchemeBlossom:WSCScheme = 30
var WSCSchemeTea:WSCScheme = 31
var WSCSchemeJellyBean:WSCScheme = 32
var WSCSchemeWeldon:WSCScheme = 33
var WSCSchemePeriwinkle:WSCScheme = 34
var WSCSchemeTulip:WSCScheme = 35
var WSCSchemeBlueBell:WSCScheme = 36
var WSCSchemeOchre:WSCScheme = 37
var WSCSchemeMoonStone:WSCScheme = 38
var WSCSchemeWhites:WSCScheme = 39
var WSCSchemeMidnight:WSCScheme = 40

/*
 * Colour Identifiers
*/
public typealias WSCSColour = Int
var WSCSColourOne:WSCSColour = 0
var WSCSColourTwo:WSCSColour = 1
var WSCSColourThree:WSCSColour = 2
var WSCSColourFour:WSCSColour = 3
var WSCSColourFive:WSCSColour = 4

/*
 * Adjustment Identifiers
*/
public typealias WSCSAdjust = Int
var WSCSAdjustSaturated:WSCSAdjust = 0
var WSCSAdjustDesaturated:WSCSAdjust = 1
var WSCSAdjustGreyscale:WSCSAdjust = 2
var WSCSAdjustComplement:WSCSAdjust = 3
var WSCSAdjustInvert:WSCSAdjust = 4

/*
 * Array containing colour schemes RGB values
*/
private var colours = Array<Array<Any>>()

final public class WSColourScheme {
    
    /*
     * Holds the set colour scheme
     */
    public var colourScheme: WSCScheme! {
        willSet {
            
            //Get a string for the colour scheme
            var newScheme = ""
            
            switch (newValue) {
            case WSCSchemeCustom:
                newScheme = "Custom"
                
                
            case WSCSchemeDarkSea:
                newScheme = "Dark Sea"
                
                
            case WSCSchemeEarth:
                newScheme = "Earth"
                
                
            case WSCSchemeMalachite:
                newScheme = "Malachite"
                
                
            case WSCSchemeAquamarine:
                newScheme = "Aquamarine"
                
                
            case WSCSchemeTangelo:
                newScheme = "Tangelo"
                
                
            case WSCSchemeAmaranth:
                newScheme = "Amaranth"
                
                
            case WSCSchemeParadise:
                newScheme = "Paradise"
                
                
            case WSCSchemeSunglow:
                newScheme = "Sunglow"
                
                
            case WSCSchemeCerulean:
                newScheme = "Cerulean"
                
                
            case WSCSchemeEucalyptus:
                newScheme = "Eucalyptus"
                
                
            case WSCSchemeDesire:
                newScheme = "Desire"
                
                
            case WSCSchemeSea:
                newScheme = "Sea"
                
                
            case WSCSchemeRegalia:
                newScheme = "Regalia"
                
                
            case WSCSchemeVividSky:
                newScheme = "Vivid Sky"
                
                
            case WSCSchemeLagoon:
                newScheme = "Lagoon"
                
                
            case WSCSchemeAzureish:
                newScheme = "Azureish"
                
                
            case WSCSchemeSurf:
                newScheme = "Surg"
                
                
            case WSCSchemeWaterspout:
                newScheme = "Waterspout"
                
                
            case WSCSchemeChestnut:
                newScheme = "Chestnut"
                
                
            case WSCSchemePastel:
                newScheme = "Pastel"
                
                
            case WSCSchemePicton:
                newScheme = "Picton"
                
                
            case WSCSchemeSienna:
                newScheme = "Sienna"
                
                
            case WSCSchemeMidnight:
                newScheme = "Midnight"
                
                
            case WSCSchemeWhites:
                newScheme = "Whites"
                
                
            case WSCSchemeMoonStone:
                newScheme = "Moon Stone"
                
                
            case WSCSchemeOchre:
                newScheme = "Ochre"
                
                
            case WSCSchemeBlueBell:
                newScheme = "Blue Bell"
                
                
            case WSCSchemeTulip:
                newScheme = "Tulip"
                
                
            case WSCSchemePeriwinkle:
                newScheme = "Periwinkle"
                
                
            case WSCSchemeWeldon:
                newScheme = "Weldon"
                
                
            case WSCSchemeJellyBean:
                newScheme = "Jelly Bean"
                
                
            case WSCSchemeTea:
                newScheme = "Tea"
                
                
            case WSCSchemeBlossom:
                newScheme = "Blossom"
                
                
            case WSCSchemeTuscany:
                newScheme = "Tuscany"
                
                
            case WSCSchemeBistre:
                newScheme = "Bistre"
                
                
            case WSCSchemeLazuli:
                newScheme = "Lazuli"
                
                
            case WSCSchemeRusset:
                newScheme = "Russet"
                
                
            case WSCSchemeCardinal:
                newScheme = "Cardinal"
                
                
            case WSCSchemeLicorice:
                newScheme = "Licorice"
                
                
            case WSCSchemeIsabelline:
                newScheme = "Isabelline"
                
                
            default:
                newScheme = "Error"
                
            }
            
            //Log that a new colour scheme has been set
            logMessage(content: String(format:"%@ set as new colour scheme.", newScheme))
            
        }
        didSet {}
    }
    
    /*
     * Holds the set custom colour RGB values
     */
    public var customColours: Array<Any>! {
        willSet {
            
            if (newValue.count == 5) {
                
                //Set the colour scheme to custom
                self.colourScheme = WSCSchemeCustom
                
                //Replace the rgb values in the colours array with the new rgb values
                colours[WSCSchemeCustom] = newValue
                
                //Log that new custom colours have been set
                logMessage(content: String(format:"New custom colours have been set: %@", newValue))
                
                
            } else {
                
                logMessage(content: String(format:"There must be 5 colours in a custom scheme. %i have been set", newValue.count))
                
            }
            
        }
        didSet {
        }
    }
    
    /*
     * Singleton instanciation
    */
    public static let sharedInstance = WSColourScheme()
    
    /*
     * Initialise
    */
    public init() {
        
        self.colourScheme = WSCSchemeDarkSea
        self.customColours = [""]
        logMessage(content: String(format:"Version %@", Constants.WSCSConstants.WSCS_VERSION))
        initColoursArray(custom: self.customColours)
        
    }
    
    /*
     * Get a colour with an alpha of 1
     */
    public func getColour(colour: WSCSColour) -> UIColor {
     
        //Get the rgbArray
        var rgbArray = Array(rgbArrayFromColour(colour: colour, scheme: self.colourScheme))
        
        //Return the color as a UIColor
        let red = (rgbArray[0] as! NSString).floatValue
        let green = (rgbArray[1] as! NSString).floatValue
        let blue = (rgbArray[2] as! NSString).floatValue
        
        return UIColor(red:CGFloat(red)/255, green:CGFloat(green)/255, blue:CGFloat(blue)/255, alpha:1.0)
        
    }
    
    /*
     * Get a colour with a specified alpha
     */
    public func getColour(colour: WSCSColour, alpha: CGFloat) -> UIColor {
     
        //Get the rgbArray
        var rgbArray = Array(rgbArrayFromColour(colour: colour, scheme: self.colourScheme))
        
        //Return the color as a UIColor
        let red = (rgbArray[0] as! NSString).floatValue
        let green = (rgbArray[1] as! NSString).floatValue
        let blue = (rgbArray[2] as! NSString).floatValue
        
        return UIColor(red:CGFloat(red)/255, green:CGFloat(green)/255, blue:CGFloat(blue)/255, alpha:alpha)
        
    }
    
    /*
     * Make a UIColor darker or lighter by a specified percentage (between -1.0 & 1.0)
     */
    public func adjustBrightness(colour: UIColor, percentage: CGFloat) -> UIColor {
        
        //Check if the percentage is valid
        if (percentage >= -1 && percentage <= 1.0) {
            
            //Set up variables
            var red = colour.components.red
            var green = colour.components.green
            var blue = colour.components.blue
            var total = CGFloat()
            var percent =  CGFloat()
            
            if (percentage < 0) {
                total = 0
            } else {
                total = 1
            }
            
            if (percentage < 0) {
                percent = -percentage
            } else {
                percent = percentage
            }
            
            //Calculate new values
            red = (total - red) * percent + red
            green = (total - green) * percent + green
            blue = (total - blue) * percent + blue
            
            return UIColor(red:red, green:green, blue:blue, alpha:colour.components.alpha)
            
            
        } else {
            
            //Log an error
            logMessage(content: String(format:"Percentage must be between -1.0 & 1.0. Percentage passed is: %f", percentage))
            
            //Return original colour
            return colour
            
        }
        
    }
    
    /*
     * Adjust a UIColor
     */
    public func adjustColour(colour: UIColor, adjustment: WSCSAdjust) -> UIColor {
        
        var adjustedColour = UIColor()

        var red = CGFloat(0.0)
        var green = CGFloat(0.0)
        var blue = CGFloat(0.0)
        var hsv = Array<Any>()
        var rgb = Array<Any>()
        
        switch adjustment {
            
        case WSCSAdjustInvert:
            
            //Invert the colour
            red = colour.components.alpha - colour.components.red
            green = colour.components.alpha - colour.components.green
            blue = colour.components.alpha - colour.components.green
            
            //Turn into UIColor
            adjustedColour = UIColor(red: red, green: green, blue: blue, alpha: colour.components.alpha)
            
        case WSCSAdjustGreyscale:
            
            //Turn to grey
            red = (colour.components.red + colour.components.green + colour.components.blue) / 3
            green = (colour.components.red + colour.components.green + colour.components.blue) / 3
            blue = (colour.components.red + colour.components.green + colour.components.blue) / 3
            
            //Turn into UIColor
            adjustedColour = UIColor(red: red, green: green, blue: blue, alpha: colour.components.alpha)
            
        case WSCSAdjustSaturated:
            
            //Convert to HSV
            hsv = hsvFromColour(colour: colour)
            
            //Change saturation
            let saturation = (hsv[1] as! NSString).floatValue
            hsv[1] = String(format:"%f",(saturation * 1.5))
            
            //Convert back to RGB
            rgb = rgbFromHSV(hsv: hsv)
            
            //Turn into UIColor
            let red = (rgb[0] as! NSString).floatValue
            let green = (rgb[1] as! NSString).floatValue
            let blue = (rgb[2] as! NSString).floatValue
            adjustedColour = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: colour.components.alpha)
            
        case WSCSAdjustComplement:
            
            //Convert to HSV
            hsv = hsvFromColour(colour: colour)
            
            //Make complement
            var hue = (hsv[0] as! NSString).floatValue
            hsv[0] = String(format:"%f",(hue + 180.0))
            
            hue = (hsv[0] as! NSString).floatValue
            if (hue > 360.0) {
                hsv[0] = String(format:"%f",((hsv[0] as! CGFloat) - 360.0))
            }
            
            //Convert back to RGB
            rgb = rgbFromHSV(hsv: hsv)
            
            //Turn into UIColor
            let red = (rgb[0] as! NSString).floatValue
            let green = (rgb[1] as! NSString).floatValue
            let blue = (rgb[2] as! NSString).floatValue
            adjustedColour = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: colour.components.alpha)
            
        case WSCSAdjustDesaturated:
            
            //Convert to HSV
            hsv = hsvFromColour(colour: colour)
            
            //Change saturation
            let saturation = (hsv[1] as! NSString).floatValue
            hsv[1] = String(format:"%f",(saturation * 0.5))
            
            //Convert back to RGB
            rgb = rgbFromHSV(hsv: hsv)
            
            //Turn into UIColor
            let red = (rgb[0] as! NSString).floatValue
            let green = (rgb[1] as! NSString).floatValue
            let blue = (rgb[2] as! NSString).floatValue
            adjustedColour = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: colour.components.alpha)
            
        default:
            
            logMessage(content: "Specified adjustment didn't match any adjustments.")
            adjustedColour = colour
            
        }

        return adjustedColour
        
    }
    
}

/*
 * Method for setting the contents of the colours array
 */
private func initColoursArray(custom: Array<Any>) {
    
    if (custom.count != 5) {
        colours.insert(Constants.WSCSRGBValues.WSCSCustomDefaultRGB, at:WSCSchemeCustom)
    } else {
        colours.insert(custom, at: WSCSchemeCustom)
    }
    
    //Dark Sea
    colours.insert(Constants.WSCSRGBValues.WSCSDarkSeaRGB, at:WSCSchemeDarkSea)
    
    //Earth
    colours.insert(Constants.WSCSRGBValues.WSCSEarthRGB, at:WSCSchemeEarth)
    
    //Malachite
    colours.insert(Constants.WSCSRGBValues.WSCSMalachiteRGB, at:WSCSchemeMalachite)
    
    //Aquamarine
    colours.insert(Constants.WSCSRGBValues.WSCSAquamarineRGB, at:WSCSchemeAquamarine)
    
    //Tangelo
    colours.insert(Constants.WSCSRGBValues.WSCSTangeloRGB, at:WSCSchemeTangelo)
    
    //Amaranth
    colours.insert(Constants.WSCSRGBValues.WSCSAmaranthRGB, at:WSCSchemeAmaranth)
    
    //Paradise
    colours.insert(Constants.WSCSRGBValues.WSCSParadiseRGB, at:WSCSchemeParadise)
    
    //Sunglow
    colours.insert(Constants.WSCSRGBValues.WSCSSunglowRGB, at:WSCSchemeSunglow)
    
    //Cerulean
    colours.insert(Constants.WSCSRGBValues.WSCSCeruleanRGB, at:WSCSchemeCerulean)
    
    //Eucalyptus
    colours.insert(Constants.WSCSRGBValues.WSCSEucalyptusRGB, at:WSCSchemeEucalyptus)
    
    //Desire
    colours.insert(Constants.WSCSRGBValues.WSCSDesireRGB, at:WSCSchemeDesire)
    
    //Sea
    colours.insert(Constants.WSCSRGBValues.WSCSSeaRGB, at:WSCSchemeSea)
    
    //Regalia
    colours.insert(Constants.WSCSRGBValues.WSCSRegaliaRGB, at:WSCSchemeRegalia)
    
    //Vivid Sky
    colours.insert(Constants.WSCSRGBValues.WSCSVividSkyRGB, at:WSCSchemeVividSky)
    
    //Lagoon
    colours.insert(Constants.WSCSRGBValues.WSCSLagoonRGB, at:WSCSchemeLagoon)
    
    //Azureish
    colours.insert(Constants.WSCSRGBValues.WSCSAzureishRGB, at:WSCSchemeAzureish)
    
    //Surf
    colours.insert(Constants.WSCSRGBValues.WSCSSurfRGB, at:WSCSchemeSurf)
    
    //Waterspout
    colours.insert(Constants.WSCSRGBValues.WSCSWaterspoutRGB, at:WSCSchemeWaterspout)
    
    //Chestnut
    colours.insert(Constants.WSCSRGBValues.WSCSChestnutRGB, at:WSCSchemeChestnut)
    
    //Pastel
    colours.insert(Constants.WSCSRGBValues.WSCSPastelRGB, at:WSCSchemePastel)
    
    //Picton
    colours.insert(Constants.WSCSRGBValues.WSCSPictonRGB, at:WSCSchemePicton)
    
    //Sienna
    colours.insert(Constants.WSCSRGBValues.WSCSSiennaRGB, at:WSCSchemeSienna)
    
    //Licorice
    colours.insert(Constants.WSCSRGBValues.WSCSLicoriceRGB, at:WSCSchemeLicorice)
    
    //Cardinal
    colours.insert(Constants.WSCSRGBValues.WSCSCardinalRGB, at:WSCSchemeCardinal)
    
    //Lazuli
    colours.insert(Constants.WSCSRGBValues.WSCSLazuliRGB, at:WSCSchemeLazuli)
    
    //Isabelline
    colours.insert(Constants.WSCSRGBValues.WSCSIsabellineRGB, at:WSCSchemeIsabelline)
    
    //Russet
    colours.insert(Constants.WSCSRGBValues.WSCSRussetRGB, at:WSCSchemeRusset)
    
    //Bistre
    colours.insert(Constants.WSCSRGBValues.WSCSBistreRGB, at:WSCSchemeBistre)
    
    //Tuscany
    colours.insert(Constants.WSCSRGBValues.WSCSTuscanyRGB, at:WSCSchemeTuscany)
    
    //Blossom
    colours.insert(Constants.WSCSRGBValues.WSCSBlossomRGB, at:WSCSchemeBlossom)
    
    //Tea
    colours.insert(Constants.WSCSRGBValues.WSCSTeaRGB, at:WSCSchemeTea)
    
    //Jelly Bloom
    colours.insert(Constants.WSCSRGBValues.WSCSJellyBeanRGB, at:WSCSchemeJellyBean)
    
    //Weldon
    colours.insert(Constants.WSCSRGBValues.WSCSWeldonRGB, at:WSCSchemeWeldon)
    
    //Periwinkle
    colours.insert(Constants.WSCSRGBValues.WSCSPeriwinkleRGB, at:WSCSchemePeriwinkle)
    
    //Tulip
    colours.insert(Constants.WSCSRGBValues.WSCSTulipRGB, at:WSCSchemeTulip)
    
    //Blue Bell
    colours.insert(Constants.WSCSRGBValues.WSCSBlueBellRGB, at:WSCSchemeBlueBell)
    
    //Ochre
    colours.insert(Constants.WSCSRGBValues.WSCSOchreRGB, at:WSCSchemeOchre)
    
    //Moon Stone
    colours.insert(Constants.WSCSRGBValues.WSCSMoonStoneRGB, at:WSCSchemeMoonStone)
    
    //Whites
    colours.insert(Constants.WSCSRGBValues.WSCSWhitesRGB, at:WSCSchemeWhites)
    
    //Midnight
    colours.insert(Constants.WSCSRGBValues.WSCSMidnightRGB, at:WSCSchemeMidnight)
}

/*
 * Return an array of rgb values from an rgb string in the colours array
 */
private func rgbArrayFromColour(colour: WSCSColour, scheme: WSCScheme) -> Array<Any> {
    
    //Get the rgb values from the colours array
    var rgbString = String(describing: colours[scheme][colour])
    
    //Split the string into seperate red, green, and blue values and return the array
    return rgbString.characters.split(separator: ",").map(String.init)
    
}

/*
 * Get HSV from RGB
 */
private func hsvFromColour(colour: UIColor) -> Array<Any> {
    
    //Get the min and max values
    let minimum = min(colour.components.red, min(colour.components.green, colour.components.blue))
    let maximum = max(colour.components.red, min(colour.components.green, colour.components.blue))
    
    //Set up variables
    let value = CGFloat(maximum)
    var saturation = CGFloat()
    var hue = CGFloat()
    let delta = maximum - minimum
    
    //Work out the saturation
    if (maximum != 0.0) {
        saturation = delta / maximum
    } else {
        return ["-1","0","0"]
    }
    
    //Work out the hue
    if (colour.components.red == maximum) {
        hue = (colour.components.green - colour.components.blue) / delta
    } else if (colour.components.green == maximum) {
        hue = 2.0 + (colour.components.blue - colour.components.red) / delta
    } else {
        hue = 4.0 + (colour.components.red - colour.components.green) / delta
        hue = hue * 60.0
    }
    
    if (hue < 0.0) {
        hue = hue + 360.0
    }
    
    if (hue > 1.0) {
        hue = hue - 360.0
    }
    
    if (hue.isNaN) {
        hue = 0.0
    }
    
    return [String(format:"%f", hue),String(format:"%f", saturation),String(format:"%f", value)]
    
}

private func rgbFromHSV(hsv: Array<Any>) -> Array<Any> {
    
    //Set up variables
    var hue = CGFloat((hsv[0] as! NSString).floatValue)
    let saturation = CGFloat((hsv[1] as! NSString).floatValue)
    let value = CGFloat((hsv[2] as! NSString).floatValue)
    var red = CGFloat(0.0)
    var green = CGFloat(0.0)
    var blue = CGFloat(0.0)
    var integer = Int()
    var factorial = CGFloat()
    var p = CGFloat()
    var q = CGFloat()
    var t = CGFloat()
    
    //Check if the colour is grey
    if (saturation == 0.0) {
        return [String(format:"%f",value),String(format:"%f",value),String(format:"%f",value)]
    }
    
    //Work out RGB values
    hue = hue / 60.0
    integer = Int(floor(hue))
    factorial = hue - CGFloat(integer)
    p = value * (1 - saturation)
    q = value * (1 - saturation * factorial)
    t = value * (1 - saturation * (1 - factorial))
    
    switch integer {
    case 0:
        red = value
        green = t
        blue = p
        
    case 1:
        red = q
        green = value
        blue = p
        
    case 2:
        red = p
        green = value
        blue = t
        
    case 3:
        red = p
        green = q
        blue = value
        
    case 4:
        red = t
        green = p
        blue = value
        
    default:
        red = value
        green = p
        blue = q
        
    }
    
    return [String(format:"%f",red),String(format:"%f",green),String(format:"%f",blue)]
    
}

extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let color = coreImageColor
        return (color.red, color.green, color.blue, color.alpha)
    }
}

/*
 * Log message to console
*/
private func logMessage(content: String) {
    
    #if DEBUG
        NSLog("WSColourScheme: %@", content)
    #endif

}
