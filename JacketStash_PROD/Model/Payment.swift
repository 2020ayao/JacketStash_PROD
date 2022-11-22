//
//  Payment.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 11/22/22.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let temperatures = try? newJSONDecoder().decode(Temperatures.self, from: jsonData)

import Foundation

// MARK: - Temperatures
struct Temperatures: Codable {
    let name: String
    let fields: Fields
    let createTime, updateTime: String
}

// MARK: - Fields
struct Fields: Codable {
    let client, customer, ephemeralKeySecret, paymentIntentClientSecret: Amount?
    let setupIntentClientSecret: SetupIntentClientSecret?
    let amount, currency, mode: Amount?
    let created: Created
}

// MARK: - Amount
struct Amount: Codable {
    let stringValue: String?
}

// MARK: - Created
struct Created: Codable {
    let timestampValue: String?
}

// MARK: - SetupIntentClientSecret
struct SetupIntentClientSecret: Codable {
    let nullValue: JSONNull?
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

