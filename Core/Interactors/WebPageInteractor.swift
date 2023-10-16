//
//  WebPageInteractor.swift
//  webchat
//
//  Created by Artsiom S. on 10/16/23.
//

import Foundation

final class WebPageInteractor: Interactor {
    private let webPageCache: WebPageCache
    
    init(webPageCache: WebPageCache) {
        self.webPageCache = webPageCache
    }
}

extension WebPageInteractor {
    var config: WebPageConfig? {
        get { webPageCache.config }
        set { webPageCache.config = newValue }
    }
}
