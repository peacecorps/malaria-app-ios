import Foundation

extension Item{
    func add(number: Int64){
        self.quantity += number
    }
    
    func remove(number: Int64){
        self.quantity = max(self.quantity - number, 0)
    }
}