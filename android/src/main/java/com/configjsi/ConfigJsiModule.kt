package com.configjsi

import android.util.Log
import com.facebook.react.BuildConfig
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.common.annotations.FrameworkAPI
import com.facebook.react.turbomodule.core.CallInvokerHolderImpl


@OptIn(FrameworkAPI::class)
class ConfigJsiModule internal constructor(val context: ReactApplicationContext) :
    ReactContextBaseJavaModule(context) {

    companion object {

        const val NAME = "ReactNativeConfigJsi"

        init {
//            System.loadLibrary("configjsi")
        }

        @OptIn(FrameworkAPI::class)
        @JvmStatic
        fun getValue(key: String):String {
          return try {
            val filed = BuildConfig::class.java.getField(key)
            filed.get(null).toString()
          } catch (e: NoSuchFieldException) {
            "" // Если ключа нет, возвращаем пустую строку
          } catch (e: IllegalAccessException) {
            "" // Если нет доступа
          }
        }

        @OptIn(FrameworkAPI::class)
        @JvmStatic
        external fun nativeInstall(jsiRuntimePointer: Long)

    }

    private val reactContext = context


    override fun getName(): String {
        return NAME
    }

    @OptIn(FrameworkAPI::class)
    @ReactMethod(isBlockingSynchronousMethod = true)
    fun install(): Boolean {
        if (BuildConfig.DEBUG) {
            Log.d(NAME, "install() called")
        }

        nativeInstall(
          context.javaScriptContextHolder!!.get()
        )

        return true
    }
}
