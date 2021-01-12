package com.example.kmm_interop.sample.shared

class SampleException(message: String): Exception(message)

sealed class SampleApiException(message: String) : Exception(message) {
    class Network : SampleApiException(message = "Network Error!!")
    class Unauthorized : SampleApiException(message = "Unauthorized Error!!")
}