//
//  main.m
//  XPCService
//
//  Created by Matt on 8/7/16.
//  Copyright © 2016 Matt Rajca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <xpc/xpc.h>

static void newConnectionHandler(xpc_connection_t peer) {
	NSLog(@"New connection!");

	xpc_connection_set_event_handler(peer, ^(xpc_object_t event) {
		xpc_object_t reply = xpc_dictionary_create_reply(event);
		xpc_dictionary_set_uint64(reply, "hi", 1);
		xpc_connection_send_message(peer, reply);
	});
	xpc_connection_resume(peer);
}

int main(void) {
	xpc_main(newConnectionHandler);
}
