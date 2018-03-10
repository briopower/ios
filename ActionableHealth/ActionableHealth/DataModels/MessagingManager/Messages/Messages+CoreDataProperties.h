//
//  Messages+CoreDataProperties.h
//  
//
//  Created by Vidhan Nandi on 02/01/17.
//
//

#import "Messages+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Messages (CoreDataProperties)

+ (NSFetchRequest<Messages *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *messageId;
@property (nullable, nonatomic, copy) NSString *key;
@property (nullable, nonatomic, copy) NSString *message;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, retain) NSManagedObject *person;

@end

NS_ASSUME_NONNULL_END
