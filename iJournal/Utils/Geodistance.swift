////////////////////////////////////////////////////////////////////////////////
///                                                                          ///
///  This routine calculates the distance between two points (given the      ///
///  latitude/longitude of those points). It is being used to calculate      ///
///  the distance between two location using GeoDataSource(TM)               ///
///  products.                                                               ///
///                                                                          ///
///  Definitions:                                                            ///
///    South latitudes are negative, east longitudes are positive            ///
///                                                                          ///
///  Passed to function:                                                     ///
///    lat1, lon1 = Latitude and Longitude of point 1 (in decimal degrees)   ///
///    lat2, lon2 = Latitude and Longitude of point 2 (in decimal degrees)   ///
///    unit = the unit you desire for results                                ///
///           where: 'M' is statute miles (default)                          ///
///                  'K' is kilometers                                       ///
///                  'N' is nautical miles                                   ///
///                                                                          ///
///  Worldwide cities and other features databases with latitude longitude   ///
///  are available at https://www.geodatasource.com                           ///
///                                                                          ///
///  For enquiries, please contact sales@geodatasource.com                   ///
///                                                                          ///
///  Official Web site: https://www.geodatasource.com                         ///
///                                                                          ///
///  GeoDataSource.com (C) All Rights Reserved 2016                          ///
///                                                                          ///
////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////
///  This function converts decimal degrees to radians              ///
///////////////////////////////////////////////////////////////////////
import UIKit

struct Geodistance{
    
    func deg2rad(deg:Double) -> Double {
        return deg * Double.pi / 180
    }

    func rad2deg(rad:Double) -> Double {
        return rad * 180.0 / Double.pi
    }

    func distance(lat1:Double, lon1:Double, lat2:Double, lon2:Double, unit:String) -> String {
        let theta = lon1 - lon2
        var dist = sin(deg2rad(deg: lat1)) * sin(deg2rad(deg: lat2)) + cos(deg2rad(deg: lat1)) * cos(deg2rad(deg: lat2)) * cos(deg2rad(deg: theta))
        dist = acos(dist)
        dist = rad2deg(rad: dist)
        dist = dist * 60 * 1.1515
        if (unit == "K") {
            dist = dist * 1.609344
        }
        else if (unit == "N") {
            dist = dist * 0.8684
        }
       
       let roundedString = String(format: "%.2f", dist)
       return "\(roundedString) \(unit)"
    }
}

