//
//  NSObject+Extension.m
//  Academic_exchange
//
//  Created by 孙志雄 on 2023/3/15.
//

#import "NSObject+BRExtension.h"

@implementation NSObject(BRExtension)


-(id)performSelector:(SEL)aSelector params:(NSArray *)params{
    if(aSelector == nil) return nil;
    /// create a signature for selector,which has store all of message for selector
    NSLog(@"%@",[self class]);
    NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:aSelector];
    /// use signature to initialize invocation
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    invocation.target = self;
    invocation.selector = aSelector;
    
    /// add param to invocation
    if([params isKindOfClass:[NSArray class]]){
        NSInteger count = MIN(params.count,sig.numberOfArguments - 2);
        for(int i = 0 ;i < count;i++){
            const char *type = [sig getArgumentTypeAtIndex:i+2];
            
            /// judge type is object or sel,null
            if(strcmp(type,"@") == 0){
                id argument = params[i];
                [invocation setArgument:&argument atIndex:i+2];
            }
        }
    }
    
    [invocation invoke];
//
    id returnValue;
    /// judge type is object
    if(strcmp(sig.methodReturnType, "@")==0){
        [invocation getReturnValue:&returnValue];
    }
    return returnValue;
}
@end
