@Model
class Lap {
    var id: UUID
    var date: Date
    var duration: TimeInterval
    var steps: Int
    
    init(date: Date, duration: TimeInterval, steps: Int) {
        self.id = UUID()
        self.date = date
        self.duration = duration
        self.steps = steps
    }
}