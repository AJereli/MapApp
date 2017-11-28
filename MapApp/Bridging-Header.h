//
//  Bridging-Header.h
//  MapApp
//
//  Created by Valeev Anatoliy on 27/11/2017.
//  Copyright © 2017 User. All rights reserved.
//

#ifndef Bridging_Header_h
#define Bridging_Header_h

#import <BaiduMapAPI_Base/BMKBaseComponent.h> // Introduce all the header files related to base
#import <BaiduMapAPI_Map/BMKMapComponent.h> // Include all header files for map functions
#import <BaiduMapAPI_Search/BMKSearchComponent.h> // Include all header files for the search function
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h> // Introduce all the header files of the cloud search function
#import <BaiduMapAPI_Location/BMKLocationComponent.h> // Include all header files for positioning
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h> // Include header files for all calculation tools
#import <BaiduMapAPI_Radar/BMKRadarComponent.h> // Include all header files for surrounding radar functions
#import <BaiduMapAPI_Map/BMKMapView.h> // Only introduce the required single header file
#endif /* Bridging_Header_h */
