//
//  Global.h
//  Voltga
//
//  Created by JackQuan on 8/6/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#ifndef Voltga_Global_h
#define Voltga_Global_h

// UIColor from RGBA

#define RGB(r, g, b, a)     [UIColor colorWithRed:(float)r / 255.f green:(float)g / 255.f blue:(float)b / 255.f alpha:(float)a / 255.f]

// dictionary to number
#define DICTIONARY_STRING_TO_INT_NUMBER(x, y) [NSNumber numberWithInt:[[x valueForKey:y] intValue]]
#define DICTIONARY_STRING_TO_FLOAT_NUMBER(x, y) [NSNumber numberWithDouble:[[x valueForKey:y] floatValue]]
#define DICTIONARY_STRING_TO_DOUBLE_NUMBER(x, y) [NSNumber numberWithDouble:[[x valueForKey:y] doubleValue]]
#define DICTIONARY_STRING_TO_NSDATE(x, y, z) [[GlobalData sharedData] dateFromString:[x valueForKey:y] DateFormat:z]

// NSNumber Constants
#define NSNUMBER_INT_ZERO [NSNumber numberWithInt:0]
#define NSNUMBER_FLOAT_ZERO [NSNumber numberWithFloat:0.0]
#define NSNUMBER_DOUBLE_ZERO [NSNumber numberWithDouble:0.0f]

//TCOTS : When the backend is ready, make the following definition active.
//#define BACKEND_READY

// Signup
#define SIGNUP_PHONENUMBER  @"SIGNUP_PHONENUMBER"
#define SELF_USERID         @"SELF_USERID"
#define SELF_USERPLACEID    @"SELF_USERPLACEID"
#define SIGNUP_SUCCESS      @"SIGNUP_SUCCESS"

// WebAPI return objects.
#define WEBAPI_RETURN_RESULT        @"result"
#define WEBAPI_RETURN_MESSAGE       @"message"
#define WEBAPI_RETURN_VALUES        @"values"

#define WEBAPI_RETURN_SUCCESS       @"SUCCEED"
#define WEBAPI_RETURN_FAILED        @"FAILED"

#define NEW_NOTIFICATION            @"NEW_NOTIFICATION"
#define SET_TOTAL_NOTIFICATION      @"SET_TOTAL_NOTIFICATION"
#define REMOVE_NOTIFICATION         @"REMOVE_NOTIFICATION"

#define IS_IPHONE   UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone

#define IPHONE60    1
#define RETINA35    2
#define RETINA40    3

#endif
