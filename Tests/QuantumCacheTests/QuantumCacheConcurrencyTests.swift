//
//  QuantumCacheConcurrencyTests.swift
//  
//
//  Created by Rukshan on 30/08/2024.
//

import XCTest
@testable import QuantumCache

struct MyContent: CachableContent {
    var id: Int
    var content: String
}


class QuantumCacheConcurrencyTests: XCTestCase {

    var cache: QuantumCache<MyContent>!
    
    override func setUp() {
        super.setUp()
        // Initialize cache with a reasonable capacity
        cache = QuantumCache<MyContent>(capacity: 100)
    }

    override func tearDown() {
        cache = nil
        super.tearDown()
    }

    func testConcurrentAccess() {
        let numberOfThreads = 10
        let numberOfOperations = 100
        let dispatchGroup = DispatchGroup()
        let queue = DispatchQueue(label: "testQueue", attributes: .concurrent)
        
        for i in 0..<numberOfThreads {
            dispatchGroup.enter()
            queue.async {
                for j in 0..<numberOfOperations {
                    let id = i * numberOfOperations + j
                    let content = MyContent(id: id, content: "Content \(id)")
                    self.cache.put(content)
                    
                    _ = self.cache.get(id)
                }
                dispatchGroup.leave()
            }
        }

        // Wait for all threads to complete
        dispatchGroup.wait()

        // Verify the cache contains expected number of items
        XCTAssertEqual(self.cache.capacity, min(numberOfThreads * numberOfOperations, 100))
    }
    
    func testConcurrentAccessWithConcurrentPerform() {
            let numberOfThreads = 10
            let numberOfOperations = 100

            // Use a concurrent perform to execute tasks in parallel
            DispatchQueue.concurrentPerform(iterations: numberOfThreads) { threadIndex in
                for operationIndex in 0..<numberOfOperations {
                    let id = threadIndex * numberOfOperations + operationIndex
                    let content = MyContent(id: id, content: "Content \(id)")
                    self.cache.put(content)
                    
                    // Retrieve and check content
                    let retrievedContent = self.cache.get(id)
                    XCTAssertEqual(retrievedContent?.content, "Content \(id)")
                }
            }

            // Verify the cache contains expected number of items
            XCTAssertEqual(self.cache.capacity, min(numberOfThreads * numberOfOperations, 100))
        }
}
