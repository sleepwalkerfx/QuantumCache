//
//  QuantumCacheEnumTypeTests.swift
//  
//
//  Created by Rukshan on 30/08/2024.
//


import XCTest
@testable import QuantumCache

enum MockEnumContent: CachableContent, Hashable {
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
            return AnyHashable(content)
        case .data(_, let content):
            return AnyHashable(content)
        }
    }
    
    // Implement Hashable and Equatable for enums
    static func == (lhs: MockEnumContent, rhs: MockEnumContent) -> Bool {
        switch (lhs, rhs) {
        case (.text(let id1, let content1), .text(let id2, let content2)):
            return id1 == id2 && content1 == content2
        case (.data(let id1, let content1), .data(let id2, let content2)):
            return id1 == id2 && content1 == content2
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .text(let id, let content):
            hasher.combine(id)
            hasher.combine(content)
        case .data(let id, let content):
            hasher.combine(id)
            hasher.combine(content)
        }
    }
}

final class QuantumCacheEnumTypeTests: XCTestCase {

    func testCacheWithEnumContent() {
        let cache = QuantumCache<MockEnumContent>(capacity: 2)
        
        let content1 = MockEnumContent.text(id: 1, content: "Text Content 1")
        let content2 = MockEnumContent.data(id: 2, content: Data([0x01, 0x02, 0x03]))
        
        cache.put(content1)
        cache.put(content2)
        
        let retrievedContent1 = cache.get(1)
        let retrievedContent2 = cache.get(2)
        
        XCTAssertEqual(retrievedContent1, content1) // Ensure enum content matches
        XCTAssertEqual(retrievedContent2, content2) // Ensure enum content matches
    }
    
    func testCacheWithEnumContentMutability() {
        let cache = QuantumCache<MockEnumContent>(capacity: 2)
        
        let content1 = MockEnumContent.text(id: 1, content: "Original Text")
        cache.put(content1)
        
        // Mock change by creating a new instance with the same ID
        let modifiedContent1 = MockEnumContent.text(id: 1, content: "Modified Text")
        cache.put(modifiedContent1)
        
        let retrievedContent1 = cache.get(1)
        
        // Verify the modification is reflected when retrieving from the cache
        XCTAssertEqual(retrievedContent1, modifiedContent1)
    }
    
    func testCacheWithEnumContentEviction() {
        let cache = QuantumCache<MockEnumContent>(capacity: 2)
        
        let content1 = MockEnumContent.text(id: 1, content: "First")
        let content2 = MockEnumContent.data(id: 2, content: Data([0x01, 0x02]))
        let content3 = MockEnumContent.text(id: 3, content: "Third")
        
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
