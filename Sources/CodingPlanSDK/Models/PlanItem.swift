import Foundation

struct PlanItem: Identifiable, Codable {
    let id: UUID
    let title: String
    let isCompleted: Bool
    let letterTag: Character?
    let dueDate: Date?
    
    init(
        id: UUID = UUID(),
        title: String,
        isCompleted: Bool = false,
        letterTag: Character? = nil,
        dueDate: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.letterTag = letterTag
        self.dueDate = dueDate
    }
}