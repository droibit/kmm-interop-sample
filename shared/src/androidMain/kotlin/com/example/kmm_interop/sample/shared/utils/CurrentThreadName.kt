package com.example.kmm_interop.sample.shared.utils

import android.util.Log

actual fun printCurrentThreadName(prefix: String) {
    Log.d("DEBUG", "${prefix}@${currentThreadName()}")
}

actual fun currentThreadName(): String = Thread.currentThread().name