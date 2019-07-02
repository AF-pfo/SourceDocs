//
//  MarkdownProtocol.swift
//  SourceDocsLib
//
//  Created by Eneko Alonso on 11/13/17.
//

import Foundation
import SourceKittenFramework
import MarkdownGenerator

struct MarkdownProtocol: SwiftDocDictionaryInitializable, MarkdownConvertible {
    let dictionary: SwiftDocDictionary
    let options: MarkdownOptions
    let moduleName: String

    let properties: [MarkdownVariable]
    let methods: [MarkdownMethod]

    init?(dictionary: SwiftDocDictionary) {
        fatalError("Not supported")
    }

    init?(dictionary: SwiftDocDictionary, options: MarkdownOptions, moduleName: String) {
        guard dictionary.accessLevel >= options.minimumAccessLevel && dictionary.isKind([.protocol]) else {
            return nil
        }
        self.dictionary = dictionary
        self.options = options
        self.moduleName = moduleName

        if let structure: [SwiftDocDictionary] = dictionary.get(.substructure) {
            properties = structure.compactMap { MarkdownVariable(dictionary: $0, options: options) }
            methods = structure.compactMap { MarkdownMethod(dictionary: $0, options: options) }
        } else {
            properties = []
            methods = []
        }
    }
    
    var moduleNameMD:String {
        if self.moduleName != "" {
            return """
            ---
            module: "\(self.moduleName)"
            ---
            
            """
            
        } else {
            return ""
        }
    }
    
    var markdown: String {
        let properties = collectionOutput(title: "## Properties", collection: self.properties)
        let methods = collectionOutput(title: "## Methods", collection: self.methods)
        return """
        \(self.moduleNameMD)
        
        # \(name)

        \(comment)

        \(declaration)

        \(properties)

        \(methods)
        """
    }
}
