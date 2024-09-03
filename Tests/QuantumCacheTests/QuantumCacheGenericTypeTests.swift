//
//  QuantumCacheGenericTypeTests.swift
//  
//
//  Created by Rukshan on 30/08/2024.
//

import XCTest
@testable import QuantumCache

// Custom class conforming to CachableContent with a generic type
class GenericContent<T>: CachableContent {
    var id: Int
    var content: T
    
    init(id: Int, content: T) {
        self.id = id
        self.content = content
    }
}

// Example complex data type
struct ComplexStruct {
    let title: String
    let attributes: [String: String]
}

final class QuantumCacheGenericTypeTests: XCTestCase {

    func testCacheWithGenericStringContent() {
        let cache = QuantumCache<GenericContent<String>>(capacity: 2)
        let item1 = GenericContent(id: 1, content: "First String")
        let item2 = GenericContent(id: 2, content: "Second String")
        
        cache.put(item1)
        cache.put(item2)
        
        let retrievedItem1 = cache.get(1)
        let retrievedItem2 = cache.get(2)
        
        XCTAssertEqual(retrievedItem1?.content, "First String")
        XCTAssertEqual(retrievedItem2?.content, "Second String")
    }
    
    func testCacheWithGenericIntContent() {
        let cache = QuantumCache<GenericContent<Int>>(capacity: 2)
        let item1 = GenericContent(id: 1, content: 100)
        let item2 = GenericContent(id: 2, content: 200)
        
        cache.put(item1)
        cache.put(item2)
        
        let retrievedItem1 = cache.get(1)
        let retrievedItem2 = cache.get(2)
        
        XCTAssertEqual(retrievedItem1?.content, 100)
        XCTAssertEqual(retrievedItem2?.content, 200)
    }
    
    func testCacheWithComplexStructContent() {
        let cache = QuantumCache<GenericContent<ComplexStruct>>(capacity: 2)
        let struct1 = ComplexStruct(title: "Item 1", attributes: ["key1": "value1"])
        let struct2 = ComplexStruct(title: "Item 2", attributes: ["key2": "value2"])
        
        let item1 = GenericContent(id: 1, content: struct1)
        let item2 = GenericContent(id: 2, content: struct2)
        
        cache.put(item1)
        cache.put(item2)
        
        let retrievedItem1 = cache.get(1)
        let retrievedItem2 = cache.get(2)
        
        XCTAssertEqual(retrievedItem1?.content.title, "Item 1")
        XCTAssertEqual(retrievedItem1?.content.attributes["key1"], "value1")
        XCTAssertEqual(retrievedItem2?.content.title, "Item 2")
        XCTAssertEqual(retrievedItem2?.content.attributes["key2"], "value2")
    }
    
    func testCacheWithGenericContentEviction() {
        let cache = QuantumCache<GenericContent<String>>(capacity: 2)
        let item1 = GenericContent(id: 1, content: "First String")
        let item2 = GenericContent(id: 2, content: "Second String")
        let item3 = GenericContent(id: 3, content: "Third String")
        
        cache.put(item1)
        cache.put(item2)
        cache.put(item3) // Should evict item1
        
        XCTAssertNil(cache.get(1)) // Item 1 should be evicted
        XCTAssertEqual(cache.get(2)?.content, "Second String") // Item 2 should still be present
        XCTAssertEqual(cache.get(3)?.content, "Third String") // Item 3 should be present
    }
}
