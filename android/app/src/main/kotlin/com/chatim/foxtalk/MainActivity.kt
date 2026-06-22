package com.chatim.foxtalk

import android.content.ComponentName
import android.content.ContentValues
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Matrix
import android.os.Build
import android.provider.MediaStore
import com.google.zxing.BarcodeFormat
import com.google.zxing.BinaryBitmap
import com.google.zxing.DecodeHintType
import com.google.zxing.LuminanceSource
import com.google.zxing.MultiFormatReader
import com.google.zxing.ReaderException
import com.google.zxing.RGBLuminanceSource
import com.google.zxing.common.GlobalHistogramBinarizer
import com.google.zxing.common.HybridBinarizer
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        registerModuleNativeFeatures(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "foxtalk/scan",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "decodeQrImage" -> {
                    val path = call.argument<String>("path")?.trim().orEmpty()
                    if (path.isEmpty()) {
                        result.error("INVALID_ARGUMENT", "图片路径为空", null)
                        return@setMethodCallHandler
                    }
                    result.success(decodeQrImage(path))
                }
                else -> result.notImplemented()
            }
        }
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "foxtalk/app_icon",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getPackageName" -> result.success(packageName)
                "supportsAlternateIcons" -> {
                    try {
                        result.success(launcherAliases().size > 1)
                    } catch (error: Exception) {
                        result.error("APP_ICON_SUPPORTS_FAILED", error.message, null)
                    }
                }
                "getCurrentIcon" -> {
                    try {
                        result.success(currentLauncherAliasName())
                    } catch (error: Exception) {
                        result.error("APP_ICON_CURRENT_FAILED", error.message, null)
                    }
                }
                "setIcon" -> {
                    val aliasName = call.argument<String>("aliasName")?.trim().orEmpty()
                    if (aliasName.isEmpty()) {
                        result.error("INVALID_ARGUMENT", "aliasName is empty", null)
                        return@setMethodCallHandler
                    }
                    try {
                        setLauncherAlias(aliasName)
                        result.success(null)
                    } catch (error: Exception) {
                        result.error("APP_ICON_SET_FAILED", error.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "foxtalk/media",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "saveImageToAlbum" -> {
                    val path = call.argument<String>("path")?.trim().orEmpty()
                    if (path.isEmpty()) {
                        result.error("INVALID_ARGUMENT", "图片路径为空", null)
                        return@setMethodCallHandler
                    }
                    if (saveImageToAlbum(path)) {
                        result.success(null)
                    } else {
                        result.error("SAVE_FAILED", "保存图片失败", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun registerModuleNativeFeatures(flutterEngine: FlutterEngine) {
        try {
            val klass = Class.forName("com.chatim.foxtalk.ModuleNativeFeatureRegistrar")
            val method = klass.getMethod(
                "register",
                FlutterActivity::class.java,
                FlutterEngine::class.java,
            )
            method.invoke(null, this, flutterEngine)
        } catch (_: ClassNotFoundException) {
            // free flavor: module native registrar is intentionally absent.
        }
    }

    private fun launcherAliases(): List<String> {
        val flags = PackageManager.GET_ACTIVITIES or PackageManager.GET_DISABLED_COMPONENTS
        @Suppress("DEPRECATION")
        val info = packageManager.getPackageInfo(packageName, flags)
        return info.activities
            ?.filter { it.targetActivity != null }
            ?.map { it.name }
            .orEmpty()
    }

    private fun currentLauncherAliasName(): String? {
        return launcherAliases().firstOrNull { alias ->
            val component = ComponentName(packageName, alias)
            when (packageManager.getComponentEnabledSetting(component)) {
                PackageManager.COMPONENT_ENABLED_STATE_ENABLED -> true
                PackageManager.COMPONENT_ENABLED_STATE_DISABLED -> false
                else -> {
                    @Suppress("DEPRECATION")
                    val info = packageManager.getActivityInfo(
                        component,
                        PackageManager.GET_DISABLED_COMPONENTS,
                    )
                    info.enabled
                }
            }
        }
    }

    private fun setLauncherAlias(aliasName: String) {
        val aliases = launcherAliases()
        val target = aliases.firstOrNull { alias ->
            alias == aliasName || alias.endsWith(".$aliasName")
        } ?: error("launcher alias not found: $aliasName")

        for (alias in aliases) {
            val component = ComponentName(packageName, alias)
            val state = if (alias == target) {
                PackageManager.COMPONENT_ENABLED_STATE_ENABLED
            } else {
                PackageManager.COMPONENT_ENABLED_STATE_DISABLED
            }
            packageManager.setComponentEnabledSetting(
                component,
                state,
                PackageManager.DONT_KILL_APP,
            )
        }
    }

    private fun decodeQrImage(path: String): String? {
        val bitmap = BitmapFactory.decodeFile(path) ?: return null
        decodeBitmap(bitmap)?.let { return it }

        val maxSide = maxOf(bitmap.width, bitmap.height)
        if (maxSide > 1800) {
            val scale = 1800f / maxSide.toFloat()
            val scaled = Bitmap.createScaledBitmap(
                bitmap,
                (bitmap.width * scale).toInt().coerceAtLeast(1),
                (bitmap.height * scale).toInt().coerceAtLeast(1),
                true,
            )
            decodeBitmap(scaled)?.let { return it }
        }

        if (bitmap.width != bitmap.height) {
            val size = minOf(bitmap.width, bitmap.height)
            val left = (bitmap.width - size) / 2
            val top = (bitmap.height - size) / 2
            val center = Bitmap.createBitmap(bitmap, left, top, size, size)
            decodeBitmap(center)?.let { return it }
        }

        val matrix = Matrix()
        for (degrees in listOf(90f, 180f, 270f)) {
            matrix.reset()
            matrix.postRotate(degrees)
            val rotated = Bitmap.createBitmap(bitmap, 0, 0, bitmap.width, bitmap.height, matrix, true)
            decodeBitmap(rotated)?.let { return it }
        }
        return null
    }

    private fun decodeBitmap(bitmap: Bitmap): String? {
        val width = bitmap.width
        val height = bitmap.height
        val pixels = IntArray(width * height)
        bitmap.getPixels(pixels, 0, width, 0, 0, width, height)
        val source = RGBLuminanceSource(width, height, pixels)
        val hints = mapOf(
            DecodeHintType.POSSIBLE_FORMATS to listOf(BarcodeFormat.QR_CODE),
            DecodeHintType.TRY_HARDER to true,
            DecodeHintType.CHARACTER_SET to "UTF-8",
        )
        for (candidate in listOf(source, source.invert())) {
            decodeSource(candidate, hints, pureBarcode = false)?.let { return it }
            decodeSource(candidate, hints, pureBarcode = true)?.let { return it }
        }
        return null
    }

    private fun decodeSource(
        source: LuminanceSource,
        hints: Map<DecodeHintType, Any>,
        pureBarcode: Boolean,
    ): String? {
        val actualHints = if (pureBarcode) {
            hints + (DecodeHintType.PURE_BARCODE to true)
        } else {
            hints
        }
        decodeBinaryBitmap(BinaryBitmap(HybridBinarizer(source)), actualHints)?.let { return it }
        return decodeBinaryBitmap(BinaryBitmap(GlobalHistogramBinarizer(source)), actualHints)
    }

    private fun decodeBinaryBitmap(
        bitmap: BinaryBitmap,
        hints: Map<DecodeHintType, Any>,
    ): String? {
        val reader = MultiFormatReader()
        return try {
            reader.decode(bitmap, hints).text
        } catch (_: ReaderException) {
            null
        } finally {
            reader.reset()
        }
    }

    private fun saveImageToAlbum(path: String): Boolean {
        val bitmap = BitmapFactory.decodeFile(path) ?: return false
        val resolver = contentResolver
        val fileName = File(path).name.ifEmpty { "foxtalk_${System.currentTimeMillis()}.jpg" }
        val values = ContentValues().apply {
            put(MediaStore.Images.Media.DISPLAY_NAME, fileName)
            put(MediaStore.Images.Media.MIME_TYPE, "image/jpeg")
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                put(MediaStore.Images.Media.RELATIVE_PATH, "Pictures/${getString(R.string.app_name)}")
                put(MediaStore.Images.Media.IS_PENDING, 1)
            }
        }
        val uri = resolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values)
            ?: return false
        val written = resolver.openOutputStream(uri)?.use { output ->
            bitmap.compress(Bitmap.CompressFormat.JPEG, 95, output)
        } ?: false
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            values.clear()
            values.put(MediaStore.Images.Media.IS_PENDING, 0)
            resolver.update(uri, values, null, null)
        }
        return written
    }
}
