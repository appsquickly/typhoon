////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#define CStringEquals(stringA, stringB) (stringA == stringB || strcmp(stringA, stringB) == 0)

#define TyphoonHashByAppendingInteger(hash, integer) ((hash << 5) - hash + integer)
