public struct ForEach<Data: RandomAccessCollection, Key: Hashable, Content: Node>: Node {
  public var data: Data
  public var key: (Data.Element) -> Key
  public var content: Never { fatalError() }
  
  package var contents: (Data.Element) -> Content
  
  init(_ data: Data, key: @escaping (Data.Element) -> Key, @HTMLBuilder contents: @escaping (Data.Element) -> Content) {
    self.data = data
    self.key = key
    self.contents = contents
  }
}

public func forEach<Data: RandomAccessCollection>(
  _ data: Data,
  key: @escaping (Data.Element) -> some Hashable,
  @HTMLBuilder contents: @escaping (Data.Element) -> some Node
) -> some Node {
  ForEach(data, key: key, contents: contents)
}

public func forEach<Data: RandomAccessCollection>(
  _ data: Data,
  @HTMLBuilder contents: @escaping (Data.Element) -> some Node
) -> some Node where Data.Element: Identifiable {
  ForEach(data, key: \.id, contents: contents)
}
