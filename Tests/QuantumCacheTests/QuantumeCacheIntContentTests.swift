//
//  QuantumeCacheIntContentTests.swift
//  
//
//  Created by Rukshan on 30/08/2024.
//

import XCTest
@testable import QuantumCache

// Mock struct conforming to CachableContent with Int content
struct MockIntContent: CachableContent {
    var id: Int
    var content: Int
}

// Mock struct conforming to CachableContent with Double content
struct MockDoubleContent: CachableContent {
    var id: Int
    var content: Double
}

// Mock struct conforming to CachableContent with a custom struct
struct MockComplexContent: CachableContent {
    var id: Int
    var content: CustomData
}

// Example custom data type
struct CustomData: Equatable, CustomDebugStringConvertible {
    let name: String
    let value: Int
    
    var debugDescription: String {
        return "\(name): \(value)"
    }
}

final class QuantumeCacheIntContentTests: XCTestCase {

    func testCacheWithIntContent() {
        let cache = QuantumCache<MockIntContent>(capacity: 2)
        let item1 = MockIntContent(id: 1, content: 42)
        let item2 = MockIntContent(id: 2, content: 100)
        
        cache.put(item1)
        cache.put(item2)
        
        let retrievedItem1 = cache.get(1)
        let retrievedItem2 = cache.get(2)
        
        XCTAssertEqual(retrievedItem1?.content, 42)
        XCTAssertEqual(retrievedItem2?.content, 100)
    }
    
    func testCacheWithDoubleContent() {
        let cache = QuantumCache<MockDoubleContent>(capacity: 2)
        let item1 = MockDoubleContent(id: 1, content: 3.14)
        let item2 = MockDoubleContent(id: 2, content: 2.71)
        
        cache.put(item1)
        cache.put(item2)
        
        let retrievedItem1 = cache.get(1)
        let retrievedItem2 = cache.get(2)
        
        XCTAssertEqual(retrievedItem1?.content, 3.14)
        XCTAssertEqual(retrievedItem2?.content, 2.71)
    }
    
    func testCacheWithComplexContent() {
        let cache = QuantumCache<MockComplexContent>(capacity: 2)
        let complexItem1 = MockComplexContent(id: 1, content: CustomData(name: "Item1", value: 10))
        let complexItem2 = MockComplexContent(id: 2, content: CustomData(name: "Item2", value: 20))
        
        cache.put(complexItem1)
        cache.put(complexItem2)
        
        let retrievedComplexItem1 = cache.get(1)
        let retrievedComplexItem2 = cache.get(2)
        
        XCTAssertEqual(retrievedComplexItem1?.content, CustomData(name: "Item1", value: 10))
        XCTAssertEqual(retrievedComplexItem2?.content, CustomData(name: "Item2", value: 20))
    }
    
    func testComplexContentEviction() {
        let cache = QuantumCache<MockComplexContent>(capacity: 2)
        let complexItem1 = MockComplexContent(id: 1, content: CustomData(name: "Item1", value: 10))
        let complexItem2 = MockComplexContent(id: 2, content: CustomData(name: "Item2", value: 20))
        let complexItem3 = MockComplexContent(id: 3, content: CustomData(name: "Item3", value: 30))
        
        cache.put(complexItem1)
        cache.put(complexItem2)
        cache.put(complexItem3) // Should evict complexItem1
        
        XCTAssertNil(cache.get(1)) // complexItem1 should be evicted
        XCTAssertNotNil(cache.get(2)) // complexItem2 should still be present
        XCTAssertNotNil(cache.get(3)) // complexItem3 should be present
    }
}


