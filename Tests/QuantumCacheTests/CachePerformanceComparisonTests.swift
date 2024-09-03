//
//  CachePerformanceComparisonTests.swift
//
//
//  Created by Rukshan on 31/08/2024.
//

import Foundation
import XCTest
@testable import QuantumCache


import Foundation

// A class type that conforms to CachableContent
class NSCacheContent: CachableContent {
    var id: Int
    var content: String
    
    init(id: Int, content: String) {
        self.id = id
        self.content = content
    }
}

class CachePerformanceComparisonTests: XCTestCase {

    var quantumCache: QuantumCache<MyContent>!
    var nsCache: NSCache<NSNumber, NSCacheContent>!

    override func setUp() {
        super.setUp()
        // Initialize caches with a reasonable capacity
        quantumCache = QuantumCache<MyContent>(capacity: 1000)
        nsCache = NSCache<NSNumber, NSCacheContent>()
        
    }

    override func tearDown() {
        quantumCache = nil
        nsCache = nil
        super.tearDown()
    }

    func testPerformanceQuantumCache() {
        let numberOfThreads = 10
        let numberOfOperations = 1000

        measure {
            DispatchQueue.concurrentPerform(iterations: numberOfThreads) { threadIndex in
                for operationIndex in 0..<numberOfOperations {
                    let id = threadIndex * numberOfOperations + operationIndex
                    let content = MyContent(id: id, content: "Content \(id)")
                    quantumCache.put(content)
                    
                    // Optionally retrieve content to ensure correctness
                    _ = quantumCache.get(id)
                }
            }
        }
    }

    func testPerformanceNSCache() {
        let numberOfThreads = 10
        let numberOfOperations = 1000

        measure {
            DispatchQueue.concurrentPerform(iterations: numberOfThreads) { threadIndex in
                for operationIndex in 0..<numberOfOperations {
                    let id = threadIndex * numberOfOperations + operationIndex
                    let content = NSCacheContent(id: id, content: "Content \(id)")
                    nsCache.setObject(content, forKey: NSNumber(value: id))
                    
                    // Optionally retrieve content to ensure correctness
                    _ = nsCache.object(forKey: NSNumber(value: id))
                }
            }
        }
    }
}
