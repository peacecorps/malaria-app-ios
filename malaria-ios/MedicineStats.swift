import Foundation

class MedicineStats{
    var medicine: Medicine!
    
    init(medicine: Medicine){
        self.medicine = medicine
    }
    
    func numberPillsTaken(date1: NSDate = NSDate.lateDate, date2: NSDate = NSDate.earliestDate) -> Int{
        var count = 0
        for r in medicine.registriesManager.getRegistries(date1: date1, date2: date2){
            if (r.tookMedicine){
                count++
            }
        }
        
        return count
    }
    
    func numberSupposedPills(date1: NSDate = NSDate.lateDate, date2: NSDate = NSDate.earliestDate) -> Int{
        return medicine.registriesManager.getRegistries(date1: date1, date2: date2).count
    }
    
    func pillAdherence(date1: NSDate = NSDate.lateDate, date2: NSDate = NSDate.earliestDate) -> Float{
        let supposedPills = numberSupposedPills(date1: date1, date2: date2)
        if(supposedPills == 0){
            return 1.0
        }
        
        let pillsTaken = numberPillsTaken(date1: date1, date2: date2)
        
        return Float(pillsTaken)/(Float(supposedPills))
    }
    
    func pillStreak(date1: NSDate = NSDate.lateDate, date2: NSDate = NSDate.earliestDate) -> Int{
        var result = 0
        
        for r in medicine.registriesManager.getRegistries(date1: date1, date2: date2, mostRecentFirst: false){
            if r.tookMedicine{
                result += 1
            }else{
                result = 0
            }
        }
        
        return result
    }
}