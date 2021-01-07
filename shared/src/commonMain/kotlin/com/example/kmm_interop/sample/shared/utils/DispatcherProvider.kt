package com.example.kmm_interop.sample.shared.utils

import kotlinx.coroutines.CoroutineDispatcher

expect class DispatcherProvider {
    val main: CoroutineDispatcher
    val computation: CoroutineDispatcher
    val io: CoroutineDispatcher
}