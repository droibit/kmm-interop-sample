package com.example.kmm_interop.sample.shared

import kotlinx.datetime.Clock

data class Task(
    val id: String,
    val title: String,
    val createdAtMillis: Long,
    val status: Status
) {
    enum class Status(val id: Int) {
        ACTIVE(id = 0),
        COMPLETED(id = 1)
    }

    constructor(id: String, title: String) : this(
        id,
        title,
        Clock.System.now().toEpochMilliseconds(),
        Status.ACTIVE
    )
}