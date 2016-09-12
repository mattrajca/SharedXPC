//
//  main.m
//  process
//
//  Created by Matt on 8/7/16.
//  Copyright © 2016 Matt Rajca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Client.h"

int main(int argc, const char * argv[]) {
	@autoreleasepool {
		Client *client = [[Client alloc] init];
		[client run];
	}
    return 0;
}
