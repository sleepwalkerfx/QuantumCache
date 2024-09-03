# QuantumCache

**QuantumCache** is a high-performance Least Recently Used (LRU) cache implementation in Swift. It is designed to be fast and efficient, supporting various types of cached content, including complex types and enums with generic associated values.

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

Tests ensure that the cache correctly handles custom classes where instances are referenced rather than copied. This includes:

-   **Reference Equality**: Confirming that the cache maintains references to the same instances.
-   **Mutability**: Verifying that changes to cached objects are reflected when retrieved.
-   **Eviction**: Ensuring proper eviction behavior with reference-type objects.

#### Example:

```swift
class ReferenceContent: CachableContent {
    var id: Int
    var content: String
    
    init(id: Int, content: String) {
        self.id = id
        self.content = content
    }
}
```
### 2. Enums with Associated Values

**QuantumCache** supports enums with associated values and has been tested for:

-   **Equality and Hashing**: Ensuring that enums with associated values are correctly compared and hashed.
-   **Eviction**: Properly managing cache entries for enums with associated values.

#### Example:
```swift
enum MockEnumContent: CachableContent, Hashable {
    case text(id: Int, content: String)
    case data(id: Int, content: Data)
}
```
### 3. Enums with Generic Associated Types

The cache has also been tested with enums that have generic associated values, verifying:

-   **Equality**: Ensuring correct comparison of enums with generic types.
-   **Hashing**: Properly handling hashing for enums with generic values.
-   **Eviction**: Correctly evicting entries when the cache exceeds its capacity.

```swift
enum GenericEnumContent<T>: CachableContent, Hashable where T: Hashable {
    case integer(id: Int, value: Int)
    case string(id: Int, value: String)
    case generic(id: Int, value: T)
}
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

