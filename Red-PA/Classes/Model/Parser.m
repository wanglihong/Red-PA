//
//  Parser.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-27.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "Parser.h"

#import "People.h"

#import "Image.h"

#import "Party.h"

#import "Comment.h"

@implementation Parser

static Parser *_instance = nil;

+ (Parser *)sharedParser {
    
    @synchronized(self){
		if (!_instance){
			_instance = [[Parser alloc] init];
		}
	}
	
	return _instance;
}

- (NSArray *)photoFromArray:(NSArray *)arr
{
    NSMutableArray *allPhoto = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0 ; i < arr.count; i++)
    {
        NSDictionary *d = [arr objectAtIndex:i];
        
        Image *m = [[Image alloc] init];
        
        m.imageId           = [d objectForKey:@"_id"];
        m.imageType         = [d objectForKey:@"mobile"];
        m.imageDate         = [d objectForKey:@"uploadDate"];
        m.metadata          = [d objectForKey:@"metadata"];
        m.hasSupported      = [[d objectForKey:@"good"] intValue];
        
        [allPhoto addObject:m];
        [m release];
    }
    
    return allPhoto;
}

- (NSArray *)commentFromDictionary:(NSDictionary *)dictionary
{
    NSMutableArray *allComments = [NSMutableArray arrayWithCapacity:0];
    
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        
        NSArray *data = [dictionary objectForKey:@"data"];
        
        for (NSDictionary *d in data) {
            
            People *p = [[People alloc] init];
            NSDictionary *u = [d objectForKey:@"user"];
            
            p.peopleId          = [u objectForKey:@"_id"];
            p.peopleMobilePhone = [u objectForKey:@"mobile"];
            p.peopleNickName    = [u objectForKey:@"name"];
            p.peopleHeaderURL   = [u objectForKey:@"icon"];
            p.peopleRealName    = [u objectForKey:@"truename"];
            p.peopleUniversity  = [u objectForKey:@"university"];
            p.peopleDepartment  = [u objectForKey:@"dept"];//dept//faculty
            p.peopleQQ          = [u objectForKey:@"qq"];
            p.peopleEmail       = [u objectForKey:@"email"];
            p.peopleInformation = [u objectForKey:@"description"];
            p.peopleEnterDate   = [u objectForKey:@""];
            
        
            Comment *c = [[Comment alloc] init];
            
            c.people        = p;
            c.date          = [d objectForKey:@"created"];
            c.content       = [d objectForKey:@"comment"];
            c.imageId       = [d objectForKey:@"photo"];
            c.soundId       = [d objectForKey:@"voice"];
            c.commentId     = [d objectForKey:@"_id"];
            
            [allComments addObject:c];
            [p release];
            [c release];
        }
    }
    
    return allComments;
}

- (NSInteger)arrayLength:(NSDictionary *)dictionary
{
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        
        return [[dictionary objectForKey:@"total"] intValue];
    }
    
    return 0;
}

- (NSArray *)peopleFromArray:(NSArray *)arr
{
    
    NSMutableArray *allPeople = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0 ; i < arr.count; i++)
    {
        NSDictionary *d = [arr objectAtIndex:i];
        
        People *p = [[People alloc] init];
        
        p.peopleId          = [d objectForKey:@"_id"];
        p.peopleMobilePhone = [d objectForKey:@"mobile"];
        p.peopleNickName    = [d objectForKey:@"name"];
        p.peopleHeaderURL   = [d objectForKey:@"icon"];
        p.peopleRealName    = [d objectForKey:@"truename"];
        p.peopleUniversity  = [d objectForKey:@"university"];
        p.peopleDepartment  = [d objectForKey:@"dept"];//faculty
        p.peopleQQ          = [d objectForKey:@"qq"];
        p.peopleEmail       = [d objectForKey:@"email"];
        p.peopleInformation = [d objectForKey:@"description"];
        p.peopleEnterDate   = [d objectForKey:@""];
        
        [allPeople addObject:p];
        [p release];
    }
    
    return allPeople;
}

- (NSMutableArray *)partyFromArray:(NSArray *)arr
{
    NSMutableArray *allParty = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0 ; i < arr.count; i++)
    {
        NSDictionary *d = [arr objectAtIndex:i];
        
        Party *p = [[Party alloc] init];
        
        p.partyId          = [d objectForKey:@"_id"];
        p.partyDate        = [d objectForKey:@"actived"];
        p.partyPlace       = [d objectForKey:@"address"];
        p.partyIntroduce   = [d objectForKey:@"description"];
        p.partyName        = [d objectForKey:@"name"];
        p.partyTitle       = [d objectForKey:@"title"];
        p.partyIconId      = [d objectForKey:@"icon"];
        p.entrepreneur     = [d objectForKey:@"entrepreneur"];
        p.partyJoined      = [[d objectForKey:@"join"] intValue];
        
        [allParty addObject:p];
        [p release];
    }
    
    return allParty;
}

- (People *)peopleFromDictionary:(NSDictionary *)dic
{
    People *people = [[[People alloc] init] autorelease];
    
    people.peopleId = [dic objectForKey:@"_id"];
    people.peopleNickName = [dic objectForKey:@"name"];
    people.peopleRealName = [dic objectForKey:@"truename"];
    people.peopleUniversity = [dic objectForKey:@"university"];
    people.peopleDepartment = [dic objectForKey:@"dept"]; //deptfaculty
    people.peopleQQ = [dic objectForKey:@"qq"];
    people.peopleEmail = [dic objectForKey:@"email"];
    people.peopleMobilePhone = [dic objectForKey:@"mobile"];
    people.peopleHeaderURL = [dic objectForKey:@"icon"];
    people.peopleInformation = [dic objectForKey:@"description"];
    people.peopleEnterDate = [dic objectForKey:@""];
    people.peopleGender = [dic objectForKey:@"gender"];
    
    return people;
}

@end
