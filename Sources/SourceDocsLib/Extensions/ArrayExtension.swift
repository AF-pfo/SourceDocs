//
//  ArrayExtension.swift
//  CYaml
//
//  Created by Paul Forstner on 11.04.19.
//

import Foundation

extension Array {
    
    public func item(at index: Int) -> Element? {
        
        if 0..<self.count ~= index {
            return self[index]
        }
        
        return nil
    }
}
