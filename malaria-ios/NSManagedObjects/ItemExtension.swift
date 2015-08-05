import Foundation

public extension Item{
    
    /// increase number of items
    /// :param: `Int64`: quantity
    public func add(number: Int64){
        self.quantity = (self.quantity + number) % Int64.max
    }
    
    /// decrease number of items.
    /// :param: `Int64`: quantity always equal or greated than 0
    public func remove(number: Int64){
        self.quantity = max(self.quantity - number, 0)
    }
    
    /// toggle check item
    public func toogle() {
        self.check = !self.check
    }    
}