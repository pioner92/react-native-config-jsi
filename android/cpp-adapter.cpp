#include <jni.h>
#include "jsi/jsi.h"
#include <android/log.h>
#include <ReactCommon/CallInvoker.h>
#include <ReactCommon/CallInvokerHolder.h>
#include <fbjni/fbjni.h>
#include <fbjni/detail/Registration.h>
#include <typeinfo>
#include <fstream>
#include <vector>
#include <sys/stat.h>
#include <iostream>


#define LOG_TAG "CPP_ADAPTER"
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)

using namespace facebook;

struct ConfigJsiBridge : jni::JavaClass<ConfigJsiBridge> {
public:
    static constexpr auto kJavaDescriptor = "Lcom/configjsi/ConfigJsiModule;";

    static void registerNatives() {
        javaClassStatic()->registerNatives({makeNativeMethod("nativeInstall",ConfigJsiBridge::nativeInstall)});
    }

private:
    static void nativeInstall(
            jni::alias_ref<jni::JObject> thiz,
            jlong jsiRuntimePointer
    ) {

        jsi::Runtime *runtime_ptr = reinterpret_cast<jsi::Runtime *>(jsiRuntimePointer);

        auto handler = jsi::Function::createFromHostFunction(
                *runtime_ptr, jsi::PropNameID::forAscii(*runtime_ptr, "getValue"), 1,
                [](jsi::Runtime &runtime, const jsi::Value &thisValue,
                   const jsi::Value *arguments, size_t count) -> jsi::Value {

                    if (count < 1 || !arguments[0].isString()) {
                        throw jsi::JSError(runtime, "[ReactNativeConfigJsi] argument must be a string");
                    }

                    jsi::String key = arguments[0].asString(runtime);

                    auto jString = jni::make_jstring(key.utf8(runtime));

                    auto javaClass = jni::findClassStatic(
                            "com/configjsi/ConfigJsiModule");
                    auto method = javaClass->getStaticMethod<jni::local_ref<jni::JString>(jni::alias_ref<jni::JString>)>("getValue");

                    jni::local_ref<jni::JString> result = method(javaClass, jString);

                    return jsi::String::createFromUtf8(runtime, result->toStdString());
                });

        runtime_ptr->global().setProperty(*runtime_ptr,"getValue",std::move(handler));

    }
};

JNIEXPORT jint JNI_OnLoad(JavaVM *vm, void *) {
    return jni::initialize(vm, [] { ConfigJsiBridge::registerNatives(); });
}
