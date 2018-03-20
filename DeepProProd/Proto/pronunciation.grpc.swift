//
// DO NOT EDIT.
//
// Generated by the protocol buffer compiler.
// Source: pronunciation.proto
//

//
// Copyright 2018, gRPC Authors All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import Foundation
import Dispatch
import gRPC
import SwiftProtobuf

internal protocol Pronounce_PronouncepredictCall: ClientCallUnary {}

fileprivate final class Pronounce_PronouncepredictCallBase: ClientCallUnaryBase<Pronounce_PronounceRequest, Pronounce_PronounceResponse>, Pronounce_PronouncepredictCall {
  override class var method: String { return "/pronounce.Pronounce/predict" }
}


/// Instantiate Pronounce_PronounceServiceClient, then call methods of this protocol to make API calls.
internal protocol Pronounce_PronounceService: ServiceClient {
  /// Synchronous. Unary.
  func predict(_ request: Pronounce_PronounceRequest) throws -> Pronounce_PronounceResponse
  /// Asynchronous. Unary.
  func predict(_ request: Pronounce_PronounceRequest, completion: @escaping (Pronounce_PronounceResponse?, CallResult) -> Void) throws -> Pronounce_PronouncepredictCall

}

internal final class Pronounce_PronounceServiceClient: ServiceClientBase, Pronounce_PronounceService {
  /// Synchronous. Unary.
  internal func predict(_ request: Pronounce_PronounceRequest) throws -> Pronounce_PronounceResponse {
    return try Pronounce_PronouncepredictCallBase(channel)
      .run(request: request, metadata: metadata)
  }
  /// Asynchronous. Unary.
  internal func predict(_ request: Pronounce_PronounceRequest, completion: @escaping (Pronounce_PronounceResponse?, CallResult) -> Void) throws -> Pronounce_PronouncepredictCall {
    return try Pronounce_PronouncepredictCallBase(channel)
      .start(request: request, metadata: metadata, completion: completion)
  }

}

/// To build a server, implement a class that conforms to this protocol.
internal protocol Pronounce_PronounceProvider {
  func predict(request: Pronounce_PronounceRequest, session: Pronounce_PronouncepredictSession) throws -> Pronounce_PronounceResponse
}

internal protocol Pronounce_PronouncepredictSession: ServerSessionUnary {}

fileprivate final class Pronounce_PronouncepredictSessionBase: ServerSessionUnaryBase<Pronounce_PronounceRequest, Pronounce_PronounceResponse>, Pronounce_PronouncepredictSession {}


/// Main server for generated service
internal final class Pronounce_PronounceServer: ServiceServer {
  private let provider: Pronounce_PronounceProvider

  internal init(address: String, provider: Pronounce_PronounceProvider) {
    self.provider = provider
    super.init(address: address)
  }

  internal init?(address: String, certificateURL: URL, keyURL: URL, provider: Pronounce_PronounceProvider) {
    self.provider = provider
    super.init(address: address, certificateURL: certificateURL, keyURL: keyURL)
  }

  /// Start the server.
  internal override func handleMethod(_ method: String, handler: Handler, queue: DispatchQueue) throws -> Bool {
    let provider = self.provider
    switch method {
    case "/pronounce.Pronounce/predict":
      try Pronounce_PronouncepredictSessionBase(
        handler: handler,
        providerBlock: { try provider.predict(request: $0, session: $1 as! Pronounce_PronouncepredictSessionBase) })
          .run(queue: queue)
      return true
    default:
      return false
    }
  }
}
