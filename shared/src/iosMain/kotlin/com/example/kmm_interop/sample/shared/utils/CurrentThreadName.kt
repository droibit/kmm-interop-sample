package com.example.kmm_interop.sample.shared.utils

import kotlinx.cinterop.toKString
import platform.darwin.dispatch_queue_get_label

actual fun printCurrentThreadName(prefix: String) {
    println("${prefix}@${currentThreadName()}")
}

actual fun currentThreadName(): String {
    return dispatch_queue_get_label(null)?.toKString() ?: "unknown"
}

