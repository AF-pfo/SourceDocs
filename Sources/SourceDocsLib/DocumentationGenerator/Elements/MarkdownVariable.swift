//
//  MarkdownVariable.swift
//  SourceDocsLib
//
//  Created by Eneko Alonso on 11/13/17.
//

import Foundation
import SourceKittenFramework
import MarkdownGenerator

struct MarkdownVariable: SwiftDocDictionaryInitializable, MarkdownConvertible {
    let dictionary: SwiftDocDictionary
    let options: MarkdownOptions

    init?(dictionary: SwiftDocDictionary) {
        fatalError("Not supported")
    }

    init?(dictionary: SwiftDocDictionary, options: MarkdownOptions) {
        
        let variables: [SwiftDeclarationKind] = [.varClass, .varInstance, .varStatic]
        guard dictionary.accessLevel >= options.minimumAccessLevel && dictionary.isKind(variables) else {
            return nil
        }
        self.dictionary = dictionary
        self.options = options
    }

    var markdown: String {
        return """
        
        ### \(name)
        
        \(comment)
        
        \(declaration)
        """
    }
}
