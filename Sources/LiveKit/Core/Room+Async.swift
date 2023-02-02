/*
 * Copyright 2022 LiveKit
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation
import Promises

public extension Room {

    @discardableResult
    func connect(_ url: String,
                 _ token: String,
                 connectOptions: ConnectOptions? = nil,
                 roomOptions: RoomOptions? = nil) async throws -> Room {

        try await withCheckedThrowingContinuation { continuation in

            connect(url,
                    token,
                    connectOptions: connectOptions,
                    roomOptions: roomOptions).then(on: queue) { room in
                        continuation.resume(returning: room)
                    }.catch(on: queue) { error in
                        continuation.resume(throwing: error)
                    }
        }
    }

    func disconnect() async {

        await withCheckedContinuation { continuation in
            disconnect().then(on: queue) {
                continuation.resume()
            }.catch(on: queue) { _ in
                // disconnect() shouldn't throw, but resume() in case.
                // continuation.resume(throwing: error)
                continuation.resume()
            }
        }
    }
}
