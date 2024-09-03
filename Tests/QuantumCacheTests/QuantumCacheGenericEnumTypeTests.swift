//
//  QuantumCacheGenericEnumTypeTests.swift
//  
//
//  Created by Rukshan on 30/08/2024.
//

import XCTest
@testable import QuantumCache

import Foundation

enum GenericEnumContent<T>: CachableContent, Hashable where T: Hashable {
    case integer(id: Int, value: Int)
    case string(id: Int, value: String)
    case generic(id: Int, value: T)
    
    var id: Int {
        switch self {
        case .integer(let id, _), .string(let id, _), .generic(let id, _):
            return id
        }
    }
    
    var content: AnyHashable {
        switch self {
        case .integer(_, let value):
            return AnyHashable(value)
        case .string(_, let value):
            return AnyHashable(value)
        case .generic(_, let value):
            return AnyHashable(value)
        }
    }
    
    static func == (lhs: GenericEnumContent, rhs: GenericEnumContent) -> Bool {
        switch (lhs, rhs) {
        case (.integer(let id1, let value1), .integer(let id2, let value2)):
            return id1 == id2 && value1 == value2
        case (.string(let id1, let value1), .string(let id2, let value2)):
            return id1 == id2 && value1 == value2
        case (.generic(let id1, let value1), .generic(let id2, let value2)):
            return id1 == id2 && value1 == value2
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .integer(let id, let value):
            hasher.combine(id)
            hasher.combine(value)
        case .string(let id, let value):
            hasher.combine(id)
            hasher.combine(value)
        case .generic(let id, let value):
            hasher.combine(id)
            hasher.combine(value)
        }
    }
}

final class QuantumCacheGenericEnumTypeTests: XCTestCase {

    func testCacheWithGenericEnumContent() {
        let cache = QuantumCache<GenericEnumContent<String>>(capacity: 2)
        
        let content1 = GenericEnumContent<String>.string(id: 1, value: "String Content 1")
        let content2 = GenericEnumContent<String>.generic(id: 2, value: "Generic Value")
        
        cache.put(content1)
        cache.put(content2)
        
        let retrievedContent1 = cache.get(1)
        let retrievedContent2 = cache.get(2)
        
        XCTAssertEqual(retrievedContent1, content1) // Ensure enum content matches
        XCTAssertEqual(retrievedContent2, content2) // Ensure enum content matches
    }
    
    func testCacheWithGenericEnumContentMutability() {
        let cache = QuantumCache<GenericEnumContent<String>>(capacity: 2)
        
        let content1 = GenericEnumContent<String>.string(id: 1, value: "Original Text")
        cache.put(content1)
        
        // Mock change by creating a new instance with the same ID
        let modifiedContent1 = GenericEnumContent<String>.string(id: 1, value: "Modified Text")
        cache.put(modifiedContent1)
        
        let retrievedContent1 = cache.get(1)
        
        // Verify the modification is reflected when retrieving from the cache
        XCTAssertEqual(retrievedContent1, modifiedContent1)
    }
    
    func testCacheWithGenericEnumContentEviction() {
        let cache = QuantumCache<GenericEnumContent<String>>(capacity: 2)
        
        let content1 = GenericEnumContent<String>.string(id: 1, value: "First")
        let content2 = GenericEnumContent<String>.generic(id: 2, value: "Second")
        let content3 = GenericEnumContent<String>.string(id: 3, value: "Third")
        
        cache.put(content1)
        cache.put(content2)
        cache.put(content3) // Should evict content1
        
        // Ensure content1 is evicted
        XCTAssertNil(cache.get(1))
        
        // Ensure content2 and content3 are still present
        XCTAssertNotNil(cache.get(2))
        XCTAssertNotNil(cache.get(3))
    }
}

