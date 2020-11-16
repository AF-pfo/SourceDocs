//
//  MarkdownIndex.swift
//  SourceDocsLib
//
//  Created by Eneko Alonso on 10/4/17.
//

import Foundation
import MarkdownGenerator
import Rainbow

struct MarkdownOptions {
    var collapsibleBlocks: Bool
    var tableOfContents: Bool
    var minimumAccessLevel: AccessLevel
}

class MarkdownIndex {
    var structs: [MarkdownObject] = []
    var classes: [MarkdownObject] = []
    var extensions: [MarkdownExtension] = []
    var enums: [MarkdownEnum] = []
    var protocols: [MarkdownProtocol] = []
    var typealiases: [MarkdownTypealias] = []
    var methods: [MarkdownMethod] = []

    func reset() {
        structs = []
        classes = []
        extensions = []
        enums = []
        protocols = []
        typealiases = []
        methods = []
    }

    func write(
        to docsPath: String,
        linkBeginningText: String,
        linkEndingText: String,
        options: DocumentOptions
    ) throws {
        extensions = flattenedExtensions()

        fputs("Generating Markdown documentation...\n".green, stdout)

        try write(items: protocols, to: docsPath, collectionTitle: "Protocols")
        try write(items: structs, to: docsPath, collectionTitle: "Structs")
        try write(items: classes, to: docsPath, collectionTitle: "Classes")
        try write(items: enums, to: docsPath, collectionTitle: "Enums")
        try write(items: extensions, to: docsPath, collectionTitle: "Extensions")
        try write(items: typealiases, to: docsPath, collectionTitle: "Typealiases")
        try write(items: methods, to: docsPath, collectionTitle: "Methods")

        fputs("Done 🎉\n".green, stdout)
    }
    
    private func write(items: [MarkdownConvertible & SwiftDocDictionaryInitializable],
                                    to docsPath: String, collectionTitle: String) throws {
        if items.isEmpty {
            return
        }

        // Make and write files
        let files = makeFiles(with: items, basePath: "\(docsPath)/\(collectionTitle.lowercased())")
        try files.forEach { try writeFile(file: $0) }
    }
    
    func writeFile(file: MarkdownFile) throws {
        fputs("  Writing documentation file: \(file.filePath)", stdout)
        do {
            try file.write()
            fputs(" ✔\n".green, stdout)
        } catch let error {
            fputs(" ❌\n", stdout)
            throw error
        }
    }

    func makeFiles(with items: [MarkdownConvertible & SwiftDocDictionaryInitializable],
                   basePath: String) -> [MarkdownFile] {
        let illegal = CharacterSet(charactersIn: "/:\\?%*|\"<>")
        return items.map { item in
            let filename = item.name.components(separatedBy: illegal).joined(separator: "_")
            return MarkdownFile(filename: filename, basePath: basePath, content: [item])
        }
    }

    /// While other types can only have one declaration within a Swift module,
    /// there can be multiple extensions for the same type.
    func flattenedExtensions() -> [MarkdownExtension] {
        let extensionsByType = zip(extensions.map { $0.name }, extensions)
        let groupedByType = Dictionary(extensionsByType) { existing, new -> MarkdownExtension in
            var merged = existing
            merged.methods += new.methods
            merged.properties += new.properties
            return merged
        }
        return Array(groupedByType.values)
    }
}
