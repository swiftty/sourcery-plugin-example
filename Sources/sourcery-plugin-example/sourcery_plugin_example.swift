// The Swift Programming Language
// https://docs.swift.org/swift-book



struct Foo: AutoEquatable {
    let bar: String
    let baz: Int
}

private func _f(_ f: Foo) {
    print(f.name)
}
