package com.example.kmm_interop.sample.shared

import co.touchlab.stately.ensureNeverFrozen
import co.touchlab.stately.isFrozen
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

    suspend fun getTasks(): List<Task>

    suspend fun getTask(id: String): Task?

    suspend fun removeTask(id: String)
}

class SampleRepositoryImpl(
    private val backgroundDispatcher: CoroutineDispatcher,
    private val taskDataSource: TaskDataSource = TaskDataSource()
) : SampleRepository {

    init {
//        ensureNeverFrozen()
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
                printCurrentThreadName("getUUIDAsFlow(self.isFrozen${this@SampleRepositoryImpl.isFrozen})")
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

    override suspend fun getTasks(): List<Task> {
        return withContext(backgroundDispatcher) {
            taskDataSource.getTasks()
        }
    }

    override suspend fun getTask(id: String): Task? {
        return withContext(backgroundDispatcher) {
            taskDataSource.getById(id)
        }
    }

    override suspend fun removeTask(id: String) {
        return withContext(backgroundDispatcher) {
            taskDataSource.removeById(id)
        }
    }
}