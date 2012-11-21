//
//  NSURLConnection+BetterBlocks.h
//
//  Created by Neil on 20/11/2012.
//  Copyright (c) 2012 Neil Cowburn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLConnection (BetterBlocks)

+ (void)sendAsynchronousRequest:(NSURLRequest *)request
              completionHandler:(void (^)(NSURLResponse *, NSData *))completionHandler
                   errorHandler:(void (^)(NSURLResponse *, NSError *))errorHandler;

// Makes a HEAD call to the specified URL to determine if the data
// at the URL has changed since it was last called.
//
// Returns YES if an error occurs while calling the URL.
+ (BOOL)useLocalDataForURL:(NSURL *)URL;

@end

// --------------------------------------------------------------------------------

// Helper method that make it easier to NSLog response headers
NSString * NSStringFromNSURLResponse(NSURLResponse *response);
