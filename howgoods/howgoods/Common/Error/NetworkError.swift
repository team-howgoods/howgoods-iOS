//
//  NetworkError.swift
//  howgoods
//
//  Created by 양원식 on 8/6/25.
//

enum NetworkError: Error {
    case server(message: String)
    case decoding
    case unauthorized
    case timeout
    case unknown
}
