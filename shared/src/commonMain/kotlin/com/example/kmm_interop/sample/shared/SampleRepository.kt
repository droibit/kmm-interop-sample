package com.example.kmm_interop.sample.shared

import com.example.kmm_interop.sample.shared.utils.CFlow
import com.example.kmm_interop.sample.shared.utils.UUID
import com.example.kmm_interop.sample.shared.utils.wrap
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn

interface SampleRepository {
    suspend fun getUUID(): String

    fun getUUIDAsFlow(): CFlow<String>
}

class SampleRepositoryImpl(
    private val backgroundDispatcher: CoroutineDispatcher
) : SampleRepository {

    override suspend fun getUUID(): String {
        return withContext(backgroundDispatcher) {
            delay(100)
            UUID.generate()
        }
    }

    override fun getUUIDAsFlow(): CFlow<String> {
        return flow {
            while (currentCoroutineContext().isActive) {
                emit(UUID.generate())
                delay(500)
            }
        }
            .flowOn(backgroundDispatcher)
            .wrap()
    }
}