import Foundation
import Combine

/// Describes whether user-created state is backed by the durable SwiftData
/// store. The app can remain usable if the store cannot open, but it must not
/// imply that completions or saved prayers will survive a relaunch.
@MainActor
final class PersistenceHealth: ObservableObject {
    let isPersistent: Bool
    @Published private(set) var lastErrorMessage: String?

    init(isPersistent: Bool) {
        self.isPersistent = isPersistent
    }

    func report(_ message: String) {
        lastErrorMessage = message
    }

    func clearError() {
        lastErrorMessage = nil
    }
}
