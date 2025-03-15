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

//        jsi::Runtime *runtime_ptr = reinterpret_cast<jsi::Runtime *>(jsiRuntimePointer);


//        auto handler = jsi::Function::createFromHostFunction(
//                *runtime_ptr, jsi::PropNameID::forAscii(*runtime_ptr, "getValue"), 1,
//                [](jsi::Runtime &runtime, const jsi::Value &thisValue,
//                   const jsi::Value *arguments, size_t count) -> jsi::Value {
//
//                    if (count < 1 || !arguments[0].isString()) {
//                        throw jsi::JSError(runtime, "[RNConfig-JSI] argument must be a string");
//                    }
//
//                    jsi::String key = arguments[0].asString(runtime);
//
//                    auto jString = jni::make_jstring(key.utf8(runtime));
//
//                    return true;
//                });

//        runtime_ptr->global().setProperty(*runtime_ptr,"getValue",std::move(handler));

    }
};

JNIEXPORT jint JNI_OnLoad(JavaVM *vm, void *) {
    return jni::initialize(vm, [] { ConfigJsiBridge::registerNatives(); });
}
