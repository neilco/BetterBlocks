//
//  NSURLConnection+BetterBlocks.m
//
//  Created by Neil on 20/11/2012.
//  Copyright (c) 2012 Neil Cowburn. All rights reserved.
//

#import "NSURLConnection+BetterBlocks.h"

@implementation NSURLConnection (BetterBlocks)

+ (void)sendAsynchronousRequest:(NSURLRequest *)request
              completionHandler:(void (^)(NSURLResponse *, NSData *))completionHandler
                   errorHandler:(void (^)(NSURLResponse *, NSError *))errorHandler
{
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error) {
                                   errorHandler(response, error);
                                   return;
                               }
                               
                               completionHandler(response, data);
                           }];
}

+ (BOOL)useLocalDataForURL:(NSURL *)URL
{
    static NSMutableDictionary *etags;
    
    if (etags == nil) {
        etags = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    [request setHTTPMethod:@"HEAD"];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        return YES;
    }
    
    NSString *etag = [[response allHeaderFields] objectForKey:@"Etag"];
    NSString *lastETag = [etags objectForKey:URL];
    
    [etags removeObjectForKey:URL];
    [etags setObject:etag forKey:URL];
    
    if ([etag isEqualToString:lastETag]) {
        return YES;
    }
    
    return NO;
}

@end

// --------------------------------------------------------------------------------

NSString * NSStringFromNSURLResponse(NSURLResponse *response)
{
    NSString *description = nil;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *instance = (NSHTTPURLResponse *)response;
        description = [NSString stringWithFormat:@"<%@: %p> {\n\tstatus: %i,\n\tHeaders: %@}", [instance class], &instance, (int)[instance statusCode], [instance allHeaderFields]];
    } else {
        description = [response description];
    }
    return description;
}
