import XCTest
@testable import QuantumCache

struct Post: Identifiable, CachableContent {
    var id: Int
    var content: String
}

final class QuantumCacheTests: XCTestCase {

    func testInsertAndRetrieveItem() {
        let cache = QuantumCache<Post>(capacity: 2)
        let item1 = Post(id: 1, content: "First Item")
        
        cache.put(item1)
        let retrievedItem = cache.get(1)
        
        XCTAssertNotNil(retrievedItem)
        XCTAssertEqual(retrievedItem?.id, 1)
        XCTAssertEqual(retrievedItem?.content, "First Item")
    }
    
    func testCacheEvictionPolicy() {
        let cache = QuantumCache<Post>(capacity: 2)
        let item1 = Post(id: 1, content: "First Item")
        let item2 = Post(id: 2, content: "Second Item")
        let item3 = Post(id: 3, content: "Third Item")
        
        cache.put(item1)
        cache.put(item2)
        cache.put(item3) // This should evict item1 since the capacity is 2
        
        XCTAssertNil(cache.get(1)) // Item 1 should have been evicted
        XCTAssertNotNil(cache.get(2)) // Item 2 should still be present
        XCTAssertNotNil(cache.get(3)) // Item 3 should be present
    }
    
    func testCacheUpdateExistingItem() {
        let cache = QuantumCache<Post>(capacity: 2)
        let item1 = Post(id: 1, content: "First Item")
        let updatedItem1 = Post(id: 1, content: "Updated First Item")
        
        cache.put(item1)
        cache.put(updatedItem1)
        
        let retrievedItem = cache.get(1)
        
        XCTAssertNotNil(retrievedItem)
        XCTAssertEqual(retrievedItem?.id, 1)
        XCTAssertEqual(retrievedItem?.content, "Updated First Item")
    }
    
    func testAccessMovesItemToMRU() {
        let cache = QuantumCache<Post>(capacity: 2)
        let item1 = Post(id: 1, content: "First Item")
        let item2 = Post(id: 2, content: "Second Item")
        let item3 = Post(id: 3, content: "Third Item")
        
        cache.put(item1)
        cache.put(item2)
        
        _ = cache.get(1) // Access item1 to make it MRU
        
        cache.put(item3) // This should evict item2 since item1 was accessed last
        
        XCTAssertNotNil(cache.get(1)) // Item 1 should still be present
        XCTAssertNil(cache.get(2)) // Item 2 should have been evicted
        XCTAssertNotNil(cache.get(3)) // Item 3 should be present
    }
    
    func testInsertBeyondCapacity() {
        let cache = QuantumCache<Post>(capacity: 2)
        let item1 = Post(id: 1, content: "First Item")
        let item2 = Post(id: 2, content: "Second Item")
        let item3 = Post(id: 3, content: "Third Item")
        let item4 = Post(id: 4, content: "Fourth Item")
        
        cache.put(item1)
        cache.put(item2)
        cache.put(item3)
        cache.put(item4) // This should evict items 1 and 2 since the capacity is 2
        
        XCTAssertNil(cache.get(1)) // Item 1 should have been evicted
        XCTAssertNil(cache.get(2)) // Item 2 should have been evicted
        XCTAssertNotNil(cache.get(3)) // Item 3 should be present
        XCTAssertNotNil(cache.get(4)) // Item 4 should be present
    }
}
