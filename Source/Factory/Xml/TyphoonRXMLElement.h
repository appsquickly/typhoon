// ================================================================================================
//  TyphoonRXMLElement+XmlComponentFactory.h
//  Fast processing of XML files
//
// ================================================================================================
//  Created by John Blanco on 9/23/11.
//  Version 1.4
//  
//  Copyright (c) 2011 John Blanco
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
// ================================================================================================
//

#import <Foundation/Foundation.h>
#import <libxml2/libxml/xmlreader.h>
#import <libxml2/libxml/xmlmemory.h>
#import <libxml/xpath.h>
#import <libxml/xpathInternals.h>
#import "TyphoonDefinition.h"

@interface TyphoonRXMLElement : NSObject
{
    xmlDocPtr doc_;
    xmlNodePtr node_;
}

- (id)initFromXMLString:(NSString *)xmlString encoding:(NSStringEncoding)encoding;

- (id)initFromXMLFile:(NSString *)filename;

- (id)initFromXMLFile:(NSString *)filename fileExtension:(NSString *)extension;

- (id)initFromURL:(NSURL *)url;

- (id)initFromXMLData:(NSData *)data;

- (id)initFromXMLNode:(xmlNodePtr)node;

+ (id)elementFromXMLString:(NSString *)xmlString encoding:(NSStringEncoding)encoding;

+ (id)elementFromXMLFile:(NSString *)filename;

+ (id)elementFromXMLFilename:(NSString *)filename fileExtension:(NSString *)extension;

+ (id)elementFromURL:(NSURL *)url;

+ (id)elementFromXMLData:(NSData *)data;

+ (id)elementFromXMLNode:(xmlNodePtr)node;

- (NSString *)attribute:(NSString *)attributeName;

- (NSString *)attribute:(NSString *)attributeName inNamespace:(NSString *)ns;

- (NSInteger)attributeAsInt:(NSString *)attributeName;

- (NSInteger)attributeAsInt:(NSString *)attributeName inNamespace:(NSString *)ns;

- (double)attributeAsDouble:(NSString *)attributeName;

- (double)attributeAsDouble:(NSString *)attributeName inNamespace:(NSString *)ns;

- (BOOL)attributeAsBool:(NSString *)attName;

- (BOOL)attributeAsBool:(NSString *)attName inNamespace:(NSString *)ns;

- (TyphoonRXMLElement *)child:(NSString *)tag;

- (TyphoonRXMLElement *)child:(NSString *)tag inNamespace:(NSString *)ns;

- (NSArray *)children:(NSString *)tag;

- (NSArray *)children:(NSString *)tag inNamespace:(NSString *)ns;

- (NSArray *)childrenWithRootXPath:(NSString *)xpath;

- (void)iterate:(NSString *)query usingBlock:(void (^)(TyphoonRXMLElement *))blk;

- (void)iterateWithRootXPath:(NSString *)xpath usingBlock:(void (^)(TyphoonRXMLElement *))blk;

- (void)iterateElements:(NSArray *)elements usingBlock:(void (^)(TyphoonRXMLElement *))blk;

@property(nonatomic, readonly) NSString *tag;
@property(nonatomic, readonly) NSString *text;
@property(nonatomic, readonly) NSInteger textAsInt;
@property(nonatomic, readonly) double textAsDouble;
@property(nonatomic, readonly) BOOL isValid;
@property(nonatomic, assign) TyphoonScope defaultScope;

@end

typedef void (^TyphoonRXMLBlock)(TyphoonRXMLElement *element);
