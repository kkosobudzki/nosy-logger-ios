// DO NOT EDIT.
// swift-format-ignore-file
// swiftlint:disable all
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: protos/logger.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

enum Nosytools_Logger_Level: SwiftProtobuf.Enum, Swift.CaseIterable {
  typealias RawValue = Int
  case debug // = 0
  case info // = 1
  case warn // = 2
  case error // = 3
  case UNRECOGNIZED(Int)

  init() {
    self = .debug
  }

  init?(rawValue: Int) {
    switch rawValue {
    case 0: self = .debug
    case 1: self = .info
    case 2: self = .warn
    case 3: self = .error
    default: self = .UNRECOGNIZED(rawValue)
    }
  }

  var rawValue: Int {
    switch self {
    case .debug: return 0
    case .info: return 1
    case .warn: return 2
    case .error: return 3
    case .UNRECOGNIZED(let i): return i
    }
  }

  // The compiler won't synthesize support with the UNRECOGNIZED case.
  static let allCases: [Nosytools_Logger_Level] = [
    .debug,
    .info,
    .warn,
    .error,
  ]

}

struct Nosytools_Logger_Log: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var date: String = String()

  var message: String = String()

  var publicKey: String = String()

  var level: Nosytools_Logger_Level = .debug

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Nosytools_Logger_Logs: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var logs: [Nosytools_Logger_Log] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Nosytools_Logger_PublicKey: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var key: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Nosytools_Logger_Empty: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "nosytools.logger"

extension Nosytools_Logger_Level: SwiftProtobuf._ProtoNameProviding {
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "LEVEL_DEBUG"),
    1: .same(proto: "LEVEL_INFO"),
    2: .same(proto: "LEVEL_WARN"),
    3: .same(proto: "LEVEL_ERROR"),
  ]
}

extension Nosytools_Logger_Log: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Log"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "date"),
    2: .same(proto: "message"),
    3: .standard(proto: "public_key"),
    4: .same(proto: "level"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.date) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.message) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.publicKey) }()
      case 4: try { try decoder.decodeSingularEnumField(value: &self.level) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.date.isEmpty {
      try visitor.visitSingularStringField(value: self.date, fieldNumber: 1)
    }
    if !self.message.isEmpty {
      try visitor.visitSingularStringField(value: self.message, fieldNumber: 2)
    }
    if !self.publicKey.isEmpty {
      try visitor.visitSingularStringField(value: self.publicKey, fieldNumber: 3)
    }
    if self.level != .debug {
      try visitor.visitSingularEnumField(value: self.level, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Nosytools_Logger_Log, rhs: Nosytools_Logger_Log) -> Bool {
    if lhs.date != rhs.date {return false}
    if lhs.message != rhs.message {return false}
    if lhs.publicKey != rhs.publicKey {return false}
    if lhs.level != rhs.level {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Nosytools_Logger_Logs: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Logs"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "logs"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.logs) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.logs.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.logs, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Nosytools_Logger_Logs, rhs: Nosytools_Logger_Logs) -> Bool {
    if lhs.logs != rhs.logs {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Nosytools_Logger_PublicKey: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".PublicKey"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "key"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.key) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.key.isEmpty {
      try visitor.visitSingularStringField(value: self.key, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Nosytools_Logger_PublicKey, rhs: Nosytools_Logger_PublicKey) -> Bool {
    if lhs.key != rhs.key {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Nosytools_Logger_Empty: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Empty"
  static let _protobuf_nameMap = SwiftProtobuf._NameMap()

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    // Load everything into unknown fields
    while try decoder.nextFieldNumber() != nil {}
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Nosytools_Logger_Empty, rhs: Nosytools_Logger_Empty) -> Bool {
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
