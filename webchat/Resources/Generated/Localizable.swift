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
      /// Close
      internal static let close = L10n.tr("Localizable", "alert.action.close")
      /// OK
      internal static let ok = L10n.tr("Localizable", "alert.action.ok")
    }
  }

  internal enum Error {
    internal enum OpenWebPage {
      /// Open Web Page Failed
      internal static let title = L10n.tr("Localizable", "error.open_web_page.title")
      internal enum Message {
        /// Empty handler name
        internal static let emptyHandlerName = L10n.tr("Localizable", "error.open_web_page.message.empty_handler_name")
        /// https in URL is missing
        internal static let httpsMissing = L10n.tr("Localizable", "error.open_web_page.message.https_missing")
        /// Wrong URL
        internal static let wrongUrl = L10n.tr("Localizable", "error.open_web_page.message.wrong_url")
      }
    }
  }

  internal enum Home {
    internal enum Alert {
      internal enum EnterWebPageData {
        /// Enter web page config
        internal static let title = L10n.tr("Localizable", "home.alert.enter_web_page_data.title")
        internal enum Action {
          /// Open web page
          internal static let openWebPage = L10n.tr("Localizable", "home.alert.enter_web_page_data.action.open_web_page")
        }
        internal enum Placeholder {
          /// Enter JS handler name
          internal static let handlerName = L10n.tr("Localizable", "home.alert.enter_web_page_data.placeholder.handler_name")
          /// https://google.com
          internal static let url = L10n.tr("Localizable", "home.alert.enter_web_page_data.placeholder.url")
        }
      }
    }
    internal enum Button {
      /// Open Web Page
      internal static let openWebPage = L10n.tr("Localizable", "home.button.open_web_page")
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
