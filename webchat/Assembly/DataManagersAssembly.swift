//
//  DataManagersAssembly.swift
//  webchat
//
//  Created by Artsiom S. on 10/16/23.
//

import Foundation
import Model

enum DataManagersAssembly { }

extension DataManagersAssembly {
    static func webPageCache() -> WebPageCache {
        WebPageCache()
    }
}

extension WebPageCache: Resolvable { }
