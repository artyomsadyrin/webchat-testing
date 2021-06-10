// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum Alert {
    internal enum Action {
      /// Cancel
      internal static let cancel = L10n.tr("Localizable", "alert.action.cancel")
      /// Close
      internal static let close = L10n.tr("Localizable", "alert.action.close")
      /// Done
      internal static let done = L10n.tr("Localizable", "alert.action.done")
      /// OK
      internal static let ok = L10n.tr("Localizable", "alert.action.ok")
    }
  }

  internal enum Common {
    /// WebChat
    internal static let appName = L10n.tr("Localizable", "common.app_name")
  }

  internal enum Error {
    internal enum Message {
      /// Something went wrong. Please contact the developer.
      internal static let unknown = L10n.tr("Localizable", "error.message.unknown")
    }
    internal enum OpenWebPage {
      /// Open Web Page Failed
      internal static let title = L10n.tr("Localizable", "error.open_web_page.title")
      internal enum Message {
        /// Empty handler name
        internal static let emptyHandlerName = L10n.tr("Localizable", "error.open_web_page.message.empty_handler_name")
        /// https in URL is missing
        internal static let httpsMissing = L10n.tr("Localizable", "error.open_web_page.message.https_missing")
        /// Local page not found
        internal static let localPageNotFound = L10n.tr("Localizable", "error.open_web_page.message.local_page_not_found")
        /// Wrong URL
        internal static let wrongUrl = L10n.tr("Localizable", "error.open_web_page.message.wrong_url")
      }
    }
  }

  internal enum Home {
    internal enum Alert {
      internal enum RemotePageData {
        /// Enter remote page config
        internal static let title = L10n.tr("Localizable", "home.alert.remote_page_data.title")
        internal enum Action {
          /// Open
          internal static let `open` = L10n.tr("Localizable", "home.alert.remote_page_data.action.open")
        }
        internal enum Placeholder {
          /// JS handler name to listen
          internal static let handlerName = L10n.tr("Localizable", "home.alert.remote_page_data.placeholder.handler_name")
          /// (Optional) JS script to inject
          internal static let injectedScript = L10n.tr("Localizable", "home.alert.remote_page_data.placeholder.injected_script")
          /// https://google.com
          internal static let url = L10n.tr("Localizable", "home.alert.remote_page_data.placeholder.url")
        }
      }
    }
    internal enum Button {
      /// Open Local Page
      internal static let openLocalPage = L10n.tr("Localizable", "home.button.open_local_page")
      /// Open Remote Page
      internal static let openRemotePage = L10n.tr("Localizable", "home.button.open_remote_page")
    }
  }

  internal enum WebPage {
    internal enum Alert {
      internal enum MessageReceived {
        /// '%@' received
        internal static func title(_ p1: Any) -> String {
          return L10n.tr("Localizable", "web_page.alert.message_received.title", String(describing: p1))
        }
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
