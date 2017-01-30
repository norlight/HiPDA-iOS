//
//  XEJThread.m
//  HiPDA
//
//  Created by Blink on 17/1/23.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJThread.h"
#import "XEJUser.h"
#import "XEJDateFormatter.h"
//#import "XEJUtility.h"
#import <RegexKitLite-NoWarning/RegexKitLite.h>
#import <YYKit/UIColor+YYAdd.h>

@interface XEJThread ()

@property (nonatomic, strong) ONOXMLElement *element;

@end

@implementation XEJThread

- (instancetype)initWithElement:(ONOXMLElement *)element
{
    _element = element;
    return [super initWithElement:element];
}

- (void)xej_initialize
{
    //是否为置顶贴
    self.stick = [self.element[@"id"] isMatchedByRegex:@"stickthread"];
    
    //tid、标题、标题颜色、附件
    static NSString *const kSubjectXPath = @".//th[contains(@class, 'subject ')]";
    ONOXMLElement *subjectElement = [self.element firstChildWithXPath:kSubjectXPath];
    
    static NSString *const kTitleXPath = @".//span[contains(@id,'thread_')]/a";
    ONOXMLElement *titleElement = [subjectElement firstChildWithXPath:kTitleXPath];
    static NSString *const kTitleColorRegex = @"(?<=color: #).{6}";
    static NSString *const kTidRegex = @"(?<=tid=)\\d+";
    self.tid = [titleElement[@"href"] stringByMatching:kTidRegex];
    self.title = [titleElement stringValue];
    NSString *colorHex = [titleElement[@"style"] stringByMatching:kTitleColorRegex];
    self.titleColor = colorHex ? [UIColor colorWithHexString:colorHex] : nil;
    
    static NSString *const kAttachXPath = @"img[@class='attach']";
    [subjectElement enumerateElementsWithXPath:kAttachXPath usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        NSString *alt = element[@"alt"];
        if ([alt isEqualToString:@"图片附件"]) {
            self.hasImageAttach = YES;
        } else if ([alt isEqualToString:@"附件"]) {
            self.hasCommonAttach = YES;
        } else if ([alt isEqualToString:@"帖子被加分"]) {
            self.agreed = YES;
        } else if ([alt isMatchedByRegex:@"精华"]) {
            self.digested = YES;
        }
    }];
    
    
    //日期、作者
    static NSString *const kAuthorXPath = @".//td[@class='author'][cite]";
    ONOXMLElement *authorElement = [self.element firstChildWithXPath:kAuthorXPath];
    
    self.createdAt = [XEJDateFormatter dateFromString:[authorElement firstChildWithTag:@"em"].stringValue];
    
    XEJUser *author = [XEJUser new];
    ONOXMLElement *authorElement_cite_a = [authorElement firstChildWithXPath:@".//cite/a"];
    static NSString *const kUidRegex = @"(?<=uid=)\\d+";
    NSString *uid = [authorElement_cite_a[@"href"] stringByMatching:kUidRegex];
    author.uid = uid;
    author.username = authorElement_cite_a.stringValue;
    //author.avatarUrlString = [[XEJUtility sharedUtility] avatarUrlStringWithUid:uid];
    self.author = author;

    //查看数、回复数、页数
    static NSString *const kNumsXPath = @".//td[@class='nums']";
    ONOXMLElement *numsElement = [self.element firstChildWithXPath:kNumsXPath];
    
    self.replyCount = [[[numsElement firstChildWithTag:@"strong"] stringValue]integerValue];
    self.viewCount = [[[numsElement firstChildWithTag:@"em"] stringValue] integerValue];
    self.pageCount = (self.replyCount % 50) ? (self.replyCount / 50 + 1) : (self.replyCount / 50);
    
    
    
    
    
 
    

}















@end
