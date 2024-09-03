//
//  QuantumCache.swift
//
//
//  Created by Rukshan on 30/08/2024.
//

import Foundation

/// A thread-safe Least Recently Used (LRU) Cache implementation.
public final class QuantumCache<DataType> where DataType: CachableContent {
    
    // MARK: - Private Properties
    
    /// Dictionary to store the cache items, where the key is the item's unique identifier.
    private var cache: [Int: ListNode<DataType>]
    
    /// The maximum capacity of the cache.
    private var _capacity: Int
    
    /// Sentinel node; left.next points to the least recently used (LRU) node in the cache.
    private var left: ListNode<DataType>
    
    /// Sentinel node; right.prev points to the most recently used (MRU) node in the cache.
    private var right: ListNode<DataType>
    
    /// A recursive lock to ensure thread safety.
    private let lock = NSRecursiveLock()
    
    // MARK: - Initialization
    
    /// Initializes a new QuantumCache with a specified capacity.
    /// - Parameter capacity: The maximum number of items that the cache can hold.
    public init(capacity: Int) {
        self.cache = [Int: ListNode<DataType>]()
        self._capacity = capacity
        
        // Initialize sentinel nodes to mark the boundaries of the doubly linked list.
        self.left = ListNode()
        self.right = ListNode()
        
        // Link the sentinel nodes.
        self.left.next = self.right
        self.right.prev = self.left
    }
    
    // MARK: - Public Methods
    
    /// Retrieves the content associated with the given id.
    /// - Parameter id: The unique identifier of the content.
    /// - Returns: The cached content, or `nil` if the content is not found.
    public func get(_ id: Int) -> DataType? {
        var result: DataType?
        lock.lock()
        defer {
            lock.unlock()
        }
        if let node = self.cache[id] {
            // Move the accessed node to the MRU position.
            self.remove(node)
            self.insert(node)
            result = node.item
        }
        return result
    }
    
    /// Inserts or updates the cache with the given content.
    /// - Parameter content: The content to be cached.
    public func put(_ content: DataType) {
        lock.lock()
        defer {
            lock.unlock()
        }
        if let node = cache[content.id] {
            // Remove the old node if it exists.
            remove(node)
        }
        
        // Insert the new node at the MRU position.
        let newNode = ListNode(item: content)
        insert(newNode)
        cache[content.id] = newNode
        
        // Check if the cache exceeds its capacity.
        if cache.count > _capacity {
            if let lru = left.next {
                // Remove the least recently used (LRU) node.
                remove(lru)
                if let id = lru.item?.id {
                    cache[id] = nil
                }
            }
        }
    }
    
    /// The maximum capacity of the cache.
    public var capacity: Int {
        return _capacity
    }
    
    // MARK: - Private Methods
    
    /// Inserts the given node at the MRU position (just before the right dummy node).
    /// - Parameter node: The node to be inserted.
    private func insert(_ node: ListNode<DataType>) {
        lock.lock()
        defer { lock.unlock() }
        let prev = right.prev
        prev?.next = node
        node.next = right
        node.prev = prev
        right.prev = node
    }
    
    /// Removes the given node from the linked list.
    /// - Parameter node: The node to be removed.
    private func remove(_ node: ListNode<DataType>) {
        lock.lock()
        defer { lock.unlock() }
        let prev = node.prev
        let next = node.next
        prev?.next = next
        next?.prev = prev
    }
}
