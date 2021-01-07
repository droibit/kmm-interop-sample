package com.example.kmm_interop.sample.shared.utils

import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers.Default
import kotlinx.coroutines.Dispatchers.IO
import kotlinx.coroutines.Dispatchers.Main

actual class DispatcherProvider(
    actual val main: CoroutineDispatcher,
    actual val computation: CoroutineDispatcher,
    actual val io: CoroutineDispatcher
) {
    constructor() : this(Main, Default, IO)
}