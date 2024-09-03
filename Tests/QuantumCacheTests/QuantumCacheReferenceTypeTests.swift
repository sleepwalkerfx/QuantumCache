//
//  QuantumCacheReferenceTypeTests.swift
//  
//
//  Created by Rukshan on 30/08/2024.
//

import XCTest
@testable import QuantumCache


class ReferenceContent: CachableContent {
    var id: Int
    var content: String
    
    init(id: Int, content: String) {
        self.id = id
        self.content = content
    }
}


final class QuantumCacheReferenceTypeTests: XCTestCase {

    func testCacheWithReferenceContent() {
        let cache = QuantumCache<ReferenceContent>(capacity: 2)
        
        let content1 = ReferenceContent(id: 1, content: "Content 1")
        let content2 = ReferenceContent(id: 2, content: "Content 2")
        
        cache.put(content1)
        cache.put(content2)
        
        let retrievedContent1 = cache.get(1)
        let retrievedContent2 = cache.get(2)
        
        XCTAssertTrue(content1 === retrievedContent1) // Ensure reference equality
        XCTAssertTrue(content2 === retrievedContent2) // Ensure reference equality
    }
    
    func testCacheWithReferenceContentMutability() {
        let cache = QuantumCache<ReferenceContent>(capacity: 2)
        
        let content1 = ReferenceContent(id: 1, content: "Original Content")
        cache.put(content1)
        
        let retrievedContent1 = cache.get(1)
        retrievedContent1?.content = "Modified Content"
        
        // Verify the modification is reflected in the original content
        XCTAssertEqual(content1.content, "Modified Content")
        XCTAssertEqual(retrievedContent1?.content, "Modified Content")
    }
    
    func testCacheWithReferenceContentEviction() {
        let cache = QuantumCache<ReferenceContent>(capacity: 2)
        
        let content1 = ReferenceContent(id: 1, content: "First")
        let content2 = ReferenceContent(id: 2, content: "Second")
        let content3 = ReferenceContent(id: 3, content: "Third")
        
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
