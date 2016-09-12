//
//  main.m
//  Service
//
//  Created by Matt on 9/11/16.
//  Copyright © 2016 Matt Rajca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Server.h"

int main(int argc, const char * argv[]) {
	@autoreleasepool {
		Server *server = [[Server alloc] init];
		[server run];
	}
    return 0;
}
