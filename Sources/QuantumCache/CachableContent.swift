//
//  CachableContent.swift
//  
//
//  Created by Rukshan on 03/09/2024.
//

import Foundation

/// Protocol defining the requirements for content that can be cached.
public protocol CachableContent {
    associatedtype ContentType
    
    /// Unique identifier for the cached content.
    var id: Int { get }
    
    /// The actual content to be cached.
    var content: ContentType { get }
}
