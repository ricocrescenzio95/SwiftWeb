public struct ForEach<Data: RandomAccessCollection, ID: Hashable, Content: Node>: Node {
  public var data: Data
  public var id: (Data.Element) -> ID
  public var content: some Node { fatalError() }
  
  package var contents: (Data.Element) -> Content
  
  init(_ data: Data, id: @escaping (Data.Element) -> ID, @HTMLBuilder contents: @escaping (Data.Element) -> Content) {
    self.data = data
    self.id = id
    self.contents = contents
  }
}

public func forEach<Data: RandomAccessCollection>(
  _ data: Data,
  id: @escaping (Data.Element) -> some Hashable,
  @HTMLBuilder contents: @escaping (Data.Element) -> some Node
) -> some Node {
  ForEach(data, id: id, contents: contents)
}

public func forEach<Data: RandomAccessCollection>(
  _ data: Data,
  @HTMLBuilder contents: @escaping (Data.Element) -> some Node
) -> some Node where Data.Element: Identifiable {
  ForEach(data, id: \.id, contents: contents)
}
