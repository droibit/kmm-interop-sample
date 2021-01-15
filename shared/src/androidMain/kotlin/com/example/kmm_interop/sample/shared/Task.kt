package com.example.kmm_interop.sample.shared

import java.util.*

val Task.createdAt: Date get() = Date(this.createdAtMillis)