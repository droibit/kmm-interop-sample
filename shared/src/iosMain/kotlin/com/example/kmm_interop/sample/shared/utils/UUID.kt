package com.example.kmm_interop.sample.shared.utils

import platform.Foundation.NSUUID

internal actual object UUID {
    actual fun generate(): String = NSUUID().UUIDString()
}