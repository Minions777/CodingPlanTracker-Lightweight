import Foundation

extension Date {
    static let shortFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    var isOverdue: Bool {
        self < Calendar.current.startOfDay(for: Date())
    }
}