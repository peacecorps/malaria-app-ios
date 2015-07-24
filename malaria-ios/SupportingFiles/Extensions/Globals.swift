import Foundation

func delay(seconds: Double, function: () -> ()){
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
    dispatch_after(time, dispatch_get_main_queue(), function)
}