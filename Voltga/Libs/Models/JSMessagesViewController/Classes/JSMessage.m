//
//  Created by Jesse Squires
//  http://www.hexedbits.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSMessagesViewController
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//  http://opensource.org/licenses/MIT
//

#import "JSMessage.h"

@implementation JSMessage

#pragma mark - Initialization

- (instancetype)initWithMessage:(NSString *)text
                          photo:(NSString *)photo
                           type:(NSInteger)type
                           date:(NSString *)date
                          width:(NSNumber *)width
                         height:(NSNumber *)height
{
    self = [super init];
    if (self) {
        _text = text;
        _photo = photo;
        _date = date;
        _msgType = type;
        _nImgWidth = width;
        _nImgHeight = height;
    }
    return self;
}

- (void)dealloc
{
    _text = nil;
    _date = nil;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _text = [aDecoder decodeObjectForKey:@"text"];
        _date = [aDecoder decodeObjectForKey:@"date"];
        _photo = [aDecoder decodeObjectForKey:@"photo"];
        _nImgWidth = [aDecoder decodeObjectForKey:@"imgWidth"];
        _nImgHeight = [aDecoder decodeObjectForKey:@"imgHeight"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.text forKey:@"text"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.photo forKey:@"photo"];
    [aCoder encodeObject:self.nImgWidth forKey:@"imgWidth"];
    [aCoder encodeObject:self.nImgHeight forKey:@"imgHeight"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithMessage:[self.text copy]
                                                        photo:[self.photo copy]
                                                         type:self.msgType
                                                         date:[self.date copy]
                                                      width:[self.nImgWidth copy]
                                                       height:[self.nImgHeight copy]];
}

@end
