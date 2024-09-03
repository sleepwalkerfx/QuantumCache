//
//  ListNode.swift
//
//
//  Created by Rukshan on 30/08/2024.
//

import Foundation

class ListNode<T> {
    var item: T?
    var next: ListNode?
    var prev: ListNode?
    
    init(item: T? = nil, next: ListNode? = nil, prev: ListNode? = nil) {
        self.item = item
        self.next = next
        self.prev = prev
    }
}

extension ListNode: CustomDebugStringConvertible where T: CachableContent {
    var debugDescription: String {
        guard let item else {
            return ""
        }
        return "\(item.content)"
    }
}
