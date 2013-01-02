////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 - 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#ifndef LOGGING_ENABLED
#	define LOGGING_ENABLED		1
#endif

#define LOG_FORMAT_WITH_LOCATION(fmt, lvl, ...) NSLog((@"%s[Line %d] [%@] " fmt), __PRETTY_FUNCTION__, __LINE__, lvl, ##__VA_ARGS__)
#define SPRING_LOG_FORMAT(fmt, lvl, ...) LOG_FORMAT_WITH_LOCATION(fmt, lvl, ##__VA_ARGS__)
#define SpringDebug(fmt, ...) SPRING_LOG_FORMAT(fmt, @"DEBUG", ##__VA_ARGS__)
