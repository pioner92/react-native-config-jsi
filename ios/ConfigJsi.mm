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

class ConfigHostObject : public jsi::HostObject {
 public:
  explicit ConfigHostObject(std::unordered_map<std::string, std::string> data)
      : __data(std::move(data)) {}

 public:
  std::vector<jsi::PropNameID> getPropertyNames(jsi::Runtime& rt) override {
    auto keys = std::vector<jsi::PropNameID>();

    return jsi::PropNameID::names(rt, "get","keys");
  }

  jsi::Value get(jsi::Runtime& rt, const jsi::PropNameID& propNameId) override {
    std::string propName = propNameId.utf8(rt);

    if (propName == "get") {
      jsi::Function handler = jsi::Function::createFromHostFunction(
          rt, jsi::PropNameID::forAscii(rt, "getValue"), 1,
          [this](jsi::Runtime& runtime, const jsi::Value& thisVal,
                 const jsi::Value* args, size_t count) -> jsi::Value {
            if (!args[0].isString()) {
              throw jsi::JSError(runtime, "argument must be a string");
            }

            std::string key = args[0].asString(runtime).utf8(runtime);
//
            std::string value = __data[key];

            if (value.size()) {
              return jsi::String::createFromUtf8(runtime, value);
            }

            return jsi::Value::undefined();
          });

      return handler;
    }

    if (propName == "keys") {
      auto keys = jsi::Array(rt, __data.size());

      int index = 0;
      for (const auto& [key, value] : __data) {
        keys.setValueAtIndex(rt, index, jsi::String::createFromUtf8(rt, key));
        ++index;
      }

      return keys;
    }

    return jsi::Value::undefined();
  }

 private:
  std::unordered_map<std::string, std::string> __data;
};

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

  NSDictionary* dict = [[NSBundle mainBundle] infoDictionary];

  std::unordered_map<std::string, std::string> map{};
  map.reserve(dict.count);

  for (NSString* key in dict) {
    NSString* value = [dict objectForKey:key];

    if ([key isKindOfClass:[NSString class]]) {
      std::string cppKey = [key UTF8String];

      if ([value isKindOfClass:[NSString class]]) {
        std::string cppValue = [value UTF8String];
        map[cppKey] = cppValue;
      }
    }
  }

  auto obj_ptr = std::make_shared<ConfigHostObject>(std::move(map));

  auto ob = jsi::Object::createFromHostObject(rt, obj_ptr);

  rt.global().setProperty(rt, "ConfigJSI", std::move(ob));
}

@end
