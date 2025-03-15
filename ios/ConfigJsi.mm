#import "ConfigJsi.h"

#import <React/RCTBridge+Private.h>
#import <React/RCTBridge.h>
#import <React/RCTUtils.h>
#import <ReactCommon/RCTTurboModule.h>
#import <jsi/jsi.h>
#include <filesystem>
#include <iostream>

@implementation ReactNativeConfigJsi
RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup {
  return YES;
}

using namespace facebook;
using namespace std;


RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(install) {
  NSLog(@"Installing JSI bindings for react-native-config-jsi...");
  RCTBridge* bridge = [RCTBridge currentBridge];
  RCTCxxBridge* cxxBridge = (RCTCxxBridge*)bridge;

  if (cxxBridge == nil) {
    return @false;
  }

  auto jsiRuntime = (jsi::Runtime*)cxxBridge.runtime;
  if (jsiRuntime == nil) {
    return @false;
  }

  auto jsCallInvoker = bridge.jsCallInvoker;

  initialize(*jsiRuntime);

  return @true;
}

void initialize(jsi::Runtime& rt) {
  jsi::Function handler = jsi::Function::createFromHostFunction(
      rt, jsi::PropNameID::forAscii(rt, "getValue"), 1,
      [](jsi::Runtime& runtime, const jsi::Value& thisVal,
         const jsi::Value* args, size_t count) -> jsi::Value {
        if (!args[0].isString()) {
          throw jsi::JSError(runtime, "argument must be a string");
        }

        std::string key = args[0].asString(runtime).utf8(runtime);

        NSString* value = [[NSBundle mainBundle]
            objectForInfoDictionaryKey:
                [NSString stringWithCString:key.c_str()
                                   encoding:NSUTF8StringEncoding]];

        if (value == nil) {
          return jsi::Value::undefined();
        }

        return jsi::String::createFromUtf8(runtime, [value UTF8String]);
      });

  rt.global().setProperty(rt, "getValue", std::move(handler));
}

@end
