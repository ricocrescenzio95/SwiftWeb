public struct ForEach<Data: RandomAccessCollection, ID: Hashable, Content: Node>: Node {
  public var data: Data
  public var id: (Data.Element) -> ID
  public var content: some Node { fatalError() }
  
  package var contents: (Data.Element) -> Content
  
  public init(_ data: Data, id: @escaping (Data.Element) -> ID, @HTMLBuilder contents: @escaping (Data.Element) -> Content) {
    self.data = data
    self.id = id
    self.contents = contents
  }
  
  public init(_ data: Data, @HTMLBuilder contents: @escaping (Data.Element) -> Content) where Data.Element: Identifiable, Data.Element.ID == ID {
    self.data = data
    self.id = \.id
    self.contents = contents
  }
}
