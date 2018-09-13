//
//  Messages+CoreDataProperties.m
//  
//
//  Created by Vidhan Nandi on 02/01/17.
//
//

#import "Messages+CoreDataProperties.h"

@implementation Messages (CoreDataProperties)

+ (NSFetchRequest<Messages *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Messages"];
}

@dynamic messageId;
@dynamic key;
@dynamic message;
@dynamic type;
@dynamic person;

@end
