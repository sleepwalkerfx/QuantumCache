//
//  QuantumCachePerformanceTests.swift
//  
//
//  Created by Rukshan on 31/08/2024.
//

import XCTest
@testable import QuantumCache

class QuantumCachePerformanceTests: XCTestCase {

    var cache: QuantumCache<MyContent>!

    override func setUp() {
        super.setUp()
        // Initialize cache with a reasonable capacity
        cache = QuantumCache<MyContent>(capacity: 1000)
    }

    override func tearDown() {
        cache = nil
        super.tearDown()
    }

    func testPerformanceConcurrentAccess() {
        let numberOfThreads = 10
        let numberOfOperations = 1000

        // Measure the time taken for concurrent access
        measure {
            DispatchQueue.concurrentPerform(iterations: numberOfThreads) { threadIndex in
                for operationIndex in 0..<numberOfOperations {
                    let id = threadIndex * numberOfOperations + operationIndex
                    let content = MyContent(id: id, content: "Content \(id)")
                    self.cache.put(content)
                    
                    // Optionally retrieve content to ensure correctness
                    _ = self.cache.get(id)
                }
            }
        }
    }
}
