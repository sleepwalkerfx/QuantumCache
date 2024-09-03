# QuantumCache

**QuantumCache** is a thread-safe, high-performance Least Recently Used (LRU) cache implementation in Swift. It is designed to be fast and efficient, supporting various types of cached content, including complex types and enums with generic associated values.

## Features

- **Generic Cache Implementation**: Works with any type conforming to `CachableContent`.
- **High Performance**: Optimized for speed with an efficient LRU eviction strategy.
- **Support for Complex Types**: Handles custom classes and enums with associated values and generic types.

## Time Complexity

- **O(1) Access and Update**: QuantumCache provides constant-time complexity for both retrieving (getting) and inserting (putting) items in the cache. This is achieved through a combination of a hash map for fast lookups and a doubly linked list to maintain the order of usage.
- **O(1) Eviction**: When the cache exceeds its capacity, the least recently used (LRU) item is evicted in constant time, ensuring that the performance remains consistent even as the cache fills up.

## Advantages Over NSCache

While `NSCache` is a powerful and convenient caching solution in Swift, `QuantumCache` offers several advantages:

- **Support for Value Types**: Unlike `NSCache`, which primarily works with reference types, `QuantumCache` can efficiently cache value types (e.g., structs, enums) in addition to reference types. This makes it more versatile and suitable for a broader range of use cases.

- **No NSObject Subclass Required**: Unlike `NSCache`, which requires cached objects to be subclasses of `NSObject`, `QuantumCache` does not impose such a restriction. This allows you to use plain Swift structs, enums, and classes. Using plain Swift types can be more efficient and align better with Swift’s value semantics, avoiding the overhead associated with `NSObject` subclassing.

- **Deterministic Eviction Policy**: `QuantumCache` follows a strict Least Recently Used (LRU) eviction policy. This deterministic approach ensures that the oldest unused item is always removed first when the cache exceeds its capacity. `NSCache`, on the other hand, may not strictly adhere to LRU, as its eviction policy is based on internal heuristics and system memory pressure.
  
- **Thread Safety**: `QuantumCache` uses `NSRecursiveLock` to ensure thread-safe operations across multiple threads. While `NSCache` is also thread-safe, `QuantumCache`'s locking mechanism is transparent and designed to handle more complex access patterns, such as nested locking scenarios.

- **Fine-Grained Control**: `QuantumCache` provides more granular control over the cache's behavior, allowing developers to customize the eviction process and tailor the cache for specific needs. This level of control is not directly available with `NSCache`.

- **Predictable Performance**: With constant-time complexity for both insertion and access operations, `QuantumCache` offers predictable and consistent performance, which is critical for applications where cache performance is a bottleneck.

- **Customization**: The `CachableContent` protocol allows developers to define custom cacheable types with any associated data. This level of customization isn't as straightforward with `NSCache`.



## Installation

You can add `QuantumCache` to your Swift project by using Swift Package Manager. Add the following dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/sleepwalkerfx/QuantumCache.git", from: "1.0.0")
]
```

## Usage

Here’s a basic example of how to use `QuantumCache`:

```swift
import QuantumCache

struct MyContent: CachableContent {
    var id: Int
    var content: String
}

let cache = QuantumCache<MyContent>(capacity: 3)
let item1 = MyContent(id: 1, content: "Hello")
let item2 = MyContent(id: 2, content: "World")

cache.put(item1)
cache.put(item2)

if let retrievedItem = cache.get(1) {
    print(retrievedItem.content) // Output: Hello
}
```
## Advanced Usage

**QuantumCache** has been thoroughly tested with various complex types to ensure robustness and correctness.

### 1. Custom Classes with Reference Semantics

**QuantumCache** has been tested to ensure it correctly handles custom classes where instances are referenced rather than copied. This includes:

- **Reference Equality**: Confirming that the cache maintains references to the same instances.
- **Mutability**: Verifying that changes to cached objects are reflected when retrieved.
- **Eviction**: Ensuring proper eviction behavior with reference-type objects.

#### Example:

Here’s how you can define and use a `QuantumCache` with custom classes:

```swift
// Define a custom class conforming to `CachableContent`
class ReferenceContent: CachableContent {
    var id: Int
    var content: String
    
    init(id: Int, content: String) {
        self.id = id
        self.content = content
    }
}

// Create a QuantumCache instance with a specified capacity
let cache = QuantumCache<ReferenceContent>(capacity: 3)

// Create instances of ReferenceContent
let firstItem = ReferenceContent(id: 1, content: "First Item")
let secondItem = ReferenceContent(id: 2, content: "Second Item")
let thirdItem = ReferenceContent(id: 3, content: "Third Item")

// Put items into the cache
cache.put(firstItem)
cache.put(secondItem)
cache.put(thirdItem)

// Access items from the cache and modify them
if let cachedFirstItem = cache.get(1) {
    print("Retrieved cached first item: \(cachedFirstItem.content)")
    // Modify the content of the retrieved item
    cachedFirstItem.content = "Updated First Item"
}

// Insert more items to trigger eviction
let fourthItem = ReferenceContent(id: 4, content: "Fourth Item")
cache.put(fourthItem)

// Access previously cached items
if let updatedFirstItem = cache.get(1) {
    print("Retrieved updated first item: \(updatedFirstItem.content)")
}

if let cachedSecondItem = cache.get(2) {
    print("Retrieved cached second item: \(cachedSecondItem.content)")
} else {
    print("Second item has been evicted")
}

if let cachedThirdItem = cache.get(3) {
    print("Retrieved cached third item: \(cachedThirdItem.content)")
} else {
    print("Third item has been evicted")
}

if let cachedFourthItem = cache.get(4) {
    print("Retrieved cached fourth item: \(cachedFourthItem.content)")
}
```

### 2. Enums with Associated Values

**QuantumCache** supports enums with associated values and has been tested for:

- **Equality and Hashing**: Ensuring that enums with associated values are correctly compared and hashed.
- **Eviction**: Properly managing cache entries for enums with associated values.

#### Example:

Here's how you can define and use a `QuantumCache` with an enum that has associated values:

```swift
// Define the enum with associated values conforming to `CachableContent` and `Hashable`
enum MockEnumContent: CachableContent, Hashable {
    case text(id: Int, content: String)
    case data(id: Int, content: Data)

    // CachableContent Protocol Requirements
    var id: Int {
        switch self {
        case .text(let id, _):
            return id
        case .data(let id, _):
            return id
        }
    }

    var content: Any {
        switch self {
        case .text(_, let content):
            return content
        case .data(_, let content):
            return content
        }
    }
}

// Create a QuantumCache instance with a specified capacity
let cache = QuantumCache<MockEnumContent>(capacity: 5)

// Put items into the cache
let textItem = MockEnumContent.text(id: 1, content: "Hello, World!")
cache.put(textItem)

let dataItem = MockEnumContent.data(id: 2, content: Data([0x00, 0x01, 0x02]))
cache.put(dataItem)

// Access items from the cache
if let cachedTextItem = cache.get(1) {
    print("Retrieved cached text: \(cachedTextItem)")
}

if let cachedDataItem = cache.get(2) {
    print("Retrieved cached data: \(cachedDataItem)")
}

// Example output:
// Retrieved cached text: text(id: 1, content: "Hello, World!")
// Retrieved cached data: data(id: 2, content: 3 bytes)
```

### 3. Enums with Generic Associated Types

**QuantumCache** supports enums with generic associated values. It has been tested for:

- **Equality**: Ensuring correct comparison of enums with generic types.
- **Hashing**: Properly handling hashing for enums with generic values.
- **Eviction**: Correctly evicting entries when the cache exceeds its capacity.

#### Example:

Here's how you can define and use a `QuantumCache` with an enum that has generic associated values:

```swift
// Define the enum with generic associated values conforming to `CachableContent`
enum GenericEnumContent<T>: CachableContent {
    case integer(id: Int, value: Int)
    case string(id: Int, value: String)
    case generic(id: Int, value: T)

    // CachableContent Protocol Requirements
    var id: Int {
        switch self {
        case .integer(let id, _):
            return id
        case .string(let id, _):
            return id
        case .generic(let id, _):
            return id
        }
    }

    var content: Any {
        switch self {
        case .integer(_, let value):
            return value
        case .string(_, let value):
            return value
        case .generic(_, let value):
            return value
        }
    }
}

// Create a QuantumCache instance with a custom type for the associated type of .generic case
let cache = QuantumCache<GenericEnumContent<Data>>(capacity: 5)

// Put items into the cache
let intItem: GenericEnumContent<Data> = GenericEnumContent.integer(id: 1, value: 42)
cache.put(intItem)

let stringItem: GenericEnumContent<Data> = GenericEnumContent.string(id: 2, value: "Hello, Swift!")
cache.put(stringItem)

let genericItem = GenericEnumContent.generic(id: 3, value: Data([0x00, 0x01]))
cache.put(genericItem)

// Access items from the cache
if let cachedIntItem = cache.get(1) {
    print("Retrieved cached integer: \(cachedIntItem)")
}

if let cachedStringItem = cache.get(2) {
    print("Retrieved cached string: \(cachedStringItem)")
}

if let cachedGenericItem = cache.get(3) {
    print("Retrieved cached generic value: \(cachedGenericItem)")
}

// Example output:
// Retrieved cached integer: integer(id: 1, value: 42)
// Retrieved cached string: string(id: 2, value: "Hello, Swift!")
// Retrieved cached generic value: generic(id: 3, value: "Generic Value")
```

## Running Tests

To run the tests, use the following command:
```sh
swift test
```
## Contributing

Contributions are welcome! Please open an issue or a pull request if you have suggestions, improvements, or bug fixes.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

For more detailed information on the implementation and usage, check out the code and tests in the repository.

