package com.example.kmm_interop.sample.shared.utils

internal actual object UUID {
    actual fun generate(): String = java.util.UUID.randomUUID().toString()
}