//
//  XEJPost.m
//  HiPDA
//
//  Created by Blink on 17/1/29.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJPost.h"
#import "XEJUser.h"
#import "XEJDateFormatter.h"
#import <Ono/Ono.h>
#import <RegexKitLite-NoWarning/RegexKitLite.h>

@interface XEJPost ()

@property (nonatomic, strong) ONOXMLElement *element;

@end

@implementation XEJPost

- (instancetype)initWithElement:(ONOXMLElement *)element
{
    _element = element;
    return [super initWithElement:element];
}

- (void)xej_initialize
{
    //pid
    static NSString *const kPidRegex = @"(?<=post_)\\d+";
    self.pid = [self.element[@"id"] stringByMatching:kPidRegex];
    
    //作者部分
    static NSString *const kAuthorXPath = @".//td[@class='postauthor'][div[@class='postinfo']]";
    ONOXMLElement *authorElement = [self.element firstChildWithXPath:kAuthorXPath];
    XEJUser *author = [XEJUser new];
    ONOXMLElement *authorElement_a = [authorElement firstChildWithXPath:@".//div[@class='postinfo']/a"];
    //NSString *avatarUrl = [authorElement firstChildWithXPath:@".//div[@class='avatar']/a/img"][@"src"];
    //author.avatarUrlString = [avatarUrl isMatchedByRegex:@"noavatar"] ? nil : avatarUrl;
    author.username = authorElement_a.stringValue;
    author.uid = [authorElement_a[@"href"] stringByMatching:@"(?<=uid=)\\d+"];
    self.author = author;
    
    //内容部分
    static NSString *const kContentXPath = @".//td[@class='postcontent'][div[@class='postinfo']]";
    ONOXMLElement *contentElement = [self.element firstChildWithXPath:kContentXPath];
    //日期、楼层
    static NSString *const kPostInfoXPath = @".//div[@class='postinfo']";
    ONOXMLElement *postInfoElement = [contentElement firstChildWithXPath:kPostInfoXPath];
    
    static NSString *const kCreatedAtXPath = @".//div[@class='authorinfo']/em";
    static NSString *const kCreatedRegex = @"(?<=发表于 ).*";
    NSString *createdAtString = [[postInfoElement firstChildWithXPath:kCreatedAtXPath].stringValue stringByMatching:kCreatedRegex];
    self.createdAt = [XEJDateFormatter timeFromString:createdAtString];
    
    static NSString *const kFloorXPath = @".//strong/a[contains(@id, 'postnum')]/em";
    self.floor = [postInfoElement firstChildWithXPath:kFloorXPath].stringValue.integerValue;
    
    //楼层内容
    static NSString *const kPostMessageXPath = @".//div[@class='defaultpost']//div[contains(@class, 'postmessage')]";
    ONOXMLElement *postMessageElement = [contentElement firstChildWithXPath:kPostMessageXPath];
    self.body = postMessageElement.description;
    
}





















@end
