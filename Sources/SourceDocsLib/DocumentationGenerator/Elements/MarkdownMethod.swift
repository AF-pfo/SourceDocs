//
//  MarkdownMethod.swift
//  SourceDocsLib
//
//  Created by Eneko Alonso on 11/13/17.
//

import Foundation
import SourceKittenFramework
import MarkdownGenerator

struct MarkdownMethod: SwiftDocDictionaryInitializable, MarkdownConvertible {
    let dictionary: SwiftDocDictionary
    let options: MarkdownOptions

    let parameters: [MarkdownMethodParameter]
    
    init?(dictionary: SwiftDocDictionary) {
        fatalError("Not supported")
    }

    init?(dictionary: SwiftDocDictionary, options: MarkdownOptions) {
        let methods: [SwiftDeclarationKind] = [
            .functionMethodInstance, .functionMethodStatic, .functionMethodClass,
            .functionFree
        ]
        guard dictionary.accessLevel >= options.minimumAccessLevel && dictionary.isKind(methods) else {
            return nil
        }
        self.dictionary = dictionary
        self.options = options

        if let params: [SwiftDocDictionary] = dictionary.get(.docParameters) {
            parameters = params.compactMap { MarkdownMethodParameter(dictionary: $0) }
        } else {
            parameters = []
        }
    }

    var parametersTable: String {
        if parameters.isEmpty {
            return ""
        }
        let data: [[String]] = parameters.map { [$0.name, $0.description] }
        let table = MarkdownTable(headers: ["Name", "Description"], data: data)
        return """
        #### Parameters

        \(table.markdown)
        """
    }
    
    var returnValue: String {
        
        guard let discussion: [SwiftDocDictionary] = self.dictionary.get(.docResultDiscussion) else {
            return ""
        }
        let value = discussion.compactMap { $0["Para"] as? String }.first

        guard let unwrappedValue = value else {
            return ""
        }
        
        return """
        
        #### Return Value
        
        \(unwrappedValue)
        """
    }
    
    var markdown: String {
        
        return """
        
        ### \(name)
        
        \(comment)
        
        \(declaration)
        
        \(parametersTable)
        
        \(returnValue)
        """
    }
}

struct MarkdownMethodParameter: SwiftDocDictionaryInitializable {
    let dictionary: SwiftDocDictionary
    let name: String
    let description: String

    init?(dictionary: SwiftDocDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String ?? "[NO NAME]"
        if let discussion = dictionary["discussion"] as? [SwiftDocDictionary] {
            description = discussion.compactMap { $0["Para"] as? String }.joined(separator: " ")
        } else {
            description = ""
        }
    }
}
