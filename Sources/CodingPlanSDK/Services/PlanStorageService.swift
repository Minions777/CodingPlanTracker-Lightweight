import Foundation

class PlanStorageService {
    static let shared = PlanStorageService()
    private let fileURL: URL
    
    private init() {
        let documentsURL = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first!
        fileURL = documentsURL.appendingPathComponent("coding-plans.json")
    }
    
    func loadPlans() throws -> [PlanItem] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([PlanItem].self, from: data)
    }
    
    func savePlans(_ plans: [PlanItem]) throws {
        let data = try JSONEncoder().encode(plans)
        try data.write(to: fileURL, options: .atomic)
    }
}