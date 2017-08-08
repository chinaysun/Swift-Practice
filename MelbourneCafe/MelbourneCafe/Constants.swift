//
//  Constants.swift
//  MelbourneCafe
//
//  Created by SUN YU on 25/5/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import Foundation

//Mark:- Server URL
let SERVER_URL = "http://10.0.0.1:8888/MelbourneCafe/"

//Mark:-  API for USER

// Method POST - USERs
let USER_REGISTER_URL = SERVER_URL + "CustomerRegister.php"
let USER_LOGIN_URL = SERVER_URL + "CustomerLogin.php"
let USER_INFO_URL = SERVER_URL + "CustomerGetInfo.php"
let USER_UPDATE_INFO_URL = SERVER_URL + "CustomerUpdateProfile.php"
let USER_DOWNLOAD_FAVORITE_CAFE_INFO = SERVER_URL + "CustomerGetFavoriteCafe.php"
let USER_CHECK_FAVORITE_CAFE_INFO = SERVER_URL + "CustomerCheckFavoriteCafe.php"
let USER_UPDATE_FAVORITE_CAFE_INFO = SERVER_URL + "CustomerUpdateFavoriteCafe.php"
let USER_MAKE_ORDER = SERVER_URL + "CustomerOrder.php"
let USER_ORDER_LIST = SERVER_URL + "CustomerOrderHistory.php"


// Method POST WITH MultipartForm data
let USER_UPLOAD_PROFILE_IMAGE_URL = SERVER_URL + "CustomerUploadProfileImage.php"


// MARK:- API for CAFE

// Method GET - CAFE
let CAFE_GEO_LOCATION_LIST_URL = SERVER_URL + "CafeGeoLocationInfoGetting.php"


// Method POST - CAFE
let CAFE_INFO_URL = SERVER_URL + "CafeGetInfo.php"
let CAFE_PRODUCT_LIST_URL = SERVER_URL + "CafeGetProductList.php"
let CAFE_DISPLAY_PRODUCT_INFO = SERVER_URL + "CafeProductDisplay.php"




