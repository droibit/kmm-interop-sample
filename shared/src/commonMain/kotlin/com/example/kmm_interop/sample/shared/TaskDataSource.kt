package com.example.kmm_interop.sample.shared

import co.touchlab.stately.isolate.IsolateState
import com.example.kmm_interop.sample.shared.utils.UUID

class TaskDataSource {
    private val cache = IsolateState { mutableMapOf<String, Task>() }

    fun getById(id: String): Task? = cache.access { it[id] }

    fun getTasks(): List<Task> {
        return this.cache.access { cache ->
            cache.values.sortedByDescending { it.createdAt }
        }
    }

    fun createTask(title: String): Task {
        return this.cache.access { cache ->
            Task(id = UUID.generate(), title = title)
                .also { cache[it.id] = it }
        }
    }

    fun removeById(id: String): Task? = cache.access { it.remove(id) }
}