//
//  MarkdownTypealias.swift
//  SourceDocsLib
//
//  Created by Eneko Alonso on 11/13/17.
//

import Foundation
import SourceKittenFramework
import MarkdownGenerator

struct MarkdownTypealias: SwiftDocDictionaryInitializable, MarkdownConvertible {
    let dictionary: SwiftDocDictionary
    let options: MarkdownOptions
    let moduleName: String

    init?(dictionary: SwiftDocDictionary) {
        fatalError("Not supported")
    }

    init?(dictionary: SwiftDocDictionary, options: MarkdownOptions, moduleName: String) {
        guard dictionary.accessLevel >= options.minimumAccessLevel && dictionary.isKind([.typealias]) else {
            return nil
        }
        self.dictionary = dictionary
        self.options = options
        self.moduleName = moduleName
    }
    
    var markdown: String {
        return """
        
        # \(name)

        \(declaration)
        """
    }
}
