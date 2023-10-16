//
//  InteractorsAssembly.swift
//  webchat
//
//  Created by Artsiom S. on 10/16/23.
//

import Foundation
import Model

enum InteractorsAssembly { }

extension InteractorsAssembly {
    static func webPageInteractor(resolver: Resolver) -> WebPageInteractor {
        WebPageInteractor(webPageCache: resolver.resolve(WebPageCache.self))
    }
}
