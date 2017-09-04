#ifdef __OBJC__
#import <Cocoa/Cocoa.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "ORSSerialPacketDescriptor.h"
#import "ORSSerialPort.h"
#import "ORSSerialPortManager.h"
#import "ORSSerialRequest.h"

FOUNDATION_EXPORT double ORSSerialVersionNumber;
FOUNDATION_EXPORT const unsigned char ORSSerialVersionString[];

