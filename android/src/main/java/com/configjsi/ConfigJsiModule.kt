package com.configjsi

import android.util.Log

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.common.annotations.FrameworkAPI


@OptIn(FrameworkAPI::class)
class ConfigJsiModule internal constructor(val context: ReactApplicationContext) :
    ReactContextBaseJavaModule(context) {

    companion object {

        const val NAME = "ReactNativeConfigJsi"

        init {
            System.loadLibrary("configjsi")
        }

        lateinit var  instance: ConfigJsiModule

        @OptIn(FrameworkAPI::class)
        @JvmStatic
        fun getValue(key: String):String {
          return try {
            val field = BuildConfig::class.java.getDeclaredField(key)
            field.get(null).toString()
          } catch (e: NoSuchFieldException) {
            ""
          } catch (e: IllegalAccessException) {
            ""
          }
        }

        @OptIn(FrameworkAPI::class)
        @JvmStatic
        external fun nativeInstall(jsiRuntimePointer: Long)

    }

    private val reactContext = context

    init {
        instance = this
    }


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
