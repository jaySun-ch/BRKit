//
//  NSObject+Extension.h
//  Academic_exchange
//
//  Created by 孙志雄 on 2023/3/15.
//


@interface NSObject(BRExtension)

/** The perform selector method extension,make selector can use more than two params
 *@param aSelector the selector you want to use
 *@param params the param for selector
 */
-(id)performSelector:(SEL)aSelector params:(NSArray *)params;



@end
