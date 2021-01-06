package com.example.kmm_interop.sample.shared


class Greeting {
    fun greeting(): String {
        return "Hello, ${Platform().platform}!"
    }
}
