package com.renuevo.palabradevidabiblia

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.pm.PackageManager

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.renuevo.palabradevidabiblia/appchecker"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            when (call.method) {
                "isAppInstalled" -> {
                    val packageName = call.argument<String>("packageName")
                    val isInstalled = isAppInstalled(packageName)
                    if (isInstalled) {
                        result.success(true)
                    } else {
                        result.success(false)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun isAppInstalled(packageName: String?): Boolean {
        return try {
            if (packageName == null) {
                false
            } else {
                // Intenta obtener información del paquete
                // Si no está instalado, lanzará NameNotFoundException
                packageManager.getPackageInfo(packageName, 0)
                true
            }
        } catch (e: PackageManager.NameNotFoundException) {
            false
        } catch (e: Exception) {
            false
        }
    }
}