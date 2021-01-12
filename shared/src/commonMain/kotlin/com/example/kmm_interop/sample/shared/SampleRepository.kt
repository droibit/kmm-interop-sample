package com.example.kmm_interop.sample.shared

import co.touchlab.stately.ensureNeverFrozen
import com.example.kmm_interop.sample.shared.utils.CFlow
import com.example.kmm_interop.sample.shared.utils.UUID
import com.example.kmm_interop.sample.shared.utils.printCurrentThreadName
import com.example.kmm_interop.sample.shared.utils.wrap
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn

interface SampleRepository {
    suspend fun getUUID(): String

    fun getUUIDAsFlow(): CFlow<String>

    @Throws(SampleException::class)
    fun forceException()

    @Throws(SampleApiException::class)
    fun forceSampleApiException()

    suspend fun getTask(): Task
}

class SampleRepositoryImpl(
    private val backgroundDispatcher: CoroutineDispatcher
) : SampleRepository {

    init {
        ensureNeverFrozen()
    }

    override suspend fun getUUID(): String {
        return withContext(backgroundDispatcher) {
            printCurrentThreadName("getUUID")
            delay(100)
            UUID.generate()
        }
    }

    override fun getUUIDAsFlow(): CFlow<String> {
        return flow {
            while (currentCoroutineContext().isActive) {
                printCurrentThreadName("getUUIDAsFlow")
                emit(UUID.generate())
                delay(500)
            }
        }
            .flowOn(backgroundDispatcher)
            .wrap()
    }

    @Throws(SampleException::class)
    override fun forceException() {
        throw SampleException(message = "Force Error!!")
    }

    @Throws(SampleApiException::class)
    override fun forceSampleApiException() {
        throw SampleApiException.Network()
    }

    override suspend fun getTask(): Task {
        return withContext(backgroundDispatcher) {
            Task(
                id = UUID.generate(),
                title = "KMM-Interop-Sample"
            )
        }
    }
}