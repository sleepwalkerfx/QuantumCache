//
//  QuantumCacheComplexTypeTests.swift
//  
//
//  Created by Rukshan on 30/08/2024.
//

import XCTest
@testable import QuantumCache

// Custom class conforming to CachableContent
class MockClassContent: CachableContent {
    var id: Int
    var content: ComplexData
    
    init(id: Int, content: ComplexData) {
        self.id = id
        self.content = content
    }
}

// Example complex data type
class ComplexData: Equatable, CustomDebugStringConvertible {
    let details: [String: AnyHashable]
    let tags: [String]
    
    init(details: [String: AnyHashable], tags: [String]) {
        self.details = details
        self.tags = tags
    }
    
    static func == (lhs: ComplexData, rhs: ComplexData) -> Bool {
        return lhs.details == rhs.details && lhs.tags == rhs.tags
    }
    
    var debugDescription: String {
        return "Details: \(details), Tags: \(tags)"
    }
}

// Enum with associated values conforming to CachableContent
enum MockSimpleEnumContent: CachableContent {
    case text(id: Int, content: String)
    case data(id: Int, content: Data)
    
    var id: Int {
        switch self {
        case .text(let id, _), .data(let id, _):
            return id
        }
    }
    
    var content: AnyHashable {
        switch self {
        case .text(_, let content):
            return content
        case .data(_, let content):
            return content
        }
    }
}

final class QuantumCacheComplexTypeTests: XCTestCase {

    func testCacheWithCustomClassContent() {
        let cache = QuantumCache<MockClassContent>(capacity: 2)
        let content1 = ComplexData(details: ["name": "Test1", "value": 1], tags: ["swift", "cache"])
        let content2 = ComplexData(details: ["name": "Test2", "value": 2], tags: ["unit", "test"])
        let item1 = MockClassContent(id: 1, content: content1)
        let item2 = MockClassContent(id: 2, content: content2)
        
        cache.put(item1)
        cache.put(item2)
        
        let retrievedItem1 = cache.get(1)
        let retrievedItem2 = cache.get(2)
        
        XCTAssertEqual(retrievedItem1?.content, content1)
        XCTAssertEqual(retrievedItem2?.content, content2)
    }
    
    func testCacheWithCustomClassEviction() {
        let cache = QuantumCache<MockClassContent>(capacity: 2)
        let content1 = ComplexData(details: ["name": "Test1", "value": 1], tags: ["swift", "cache"])
        let content2 = ComplexData(details: ["name": "Test2", "value": 2], tags: ["unit", "test"])
        let content3 = ComplexData(details: ["name": "Test3", "value": 3], tags: ["eviction", "test"])
        
        let item1 = MockClassContent(id: 1, content: content1)
        let item2 = MockClassContent(id: 2, content: content2)
        let item3 = MockClassContent(id: 3, content: content3)
        
        cache.put(item1)
        cache.put(item2)
        cache.put(item3) // Should evict item1
        
        XCTAssertNil(cache.get(1)) // Item 1 should be evicted
        XCTAssertNotNil(cache.get(2)) // Item 2 should still be present
        XCTAssertNotNil(cache.get(3)) // Item 3 should be present
    }
    
    func testCacheWithEnumContent() {
        let cache = QuantumCache<MockSimpleEnumContent>(capacity: 2)
        let item1 = MockSimpleEnumContent.text(id: 1, content: "First Text")
        let item2 = MockSimpleEnumContent.data(id: 2, content: Data([0x00, 0x01]))
        
        cache.put(item1)
        cache.put(item2)
        
        let retrievedItem1 = cache.get(1)
        let retrievedItem2 = cache.get(2)
        
        XCTAssertEqual(retrievedItem1?.content as? String, "First Text")
        XCTAssertEqual(retrievedItem2?.content as? Data, Data([0x00, 0x01]))
    }
}


