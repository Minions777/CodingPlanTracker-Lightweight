import SwiftUI
import CodingPlanSDK

struct WatchPlanListView: View {
    @State private var plans: [PlanItem] = []
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($plans) { $plan in
                    WatchPlanRowView(plan: $plan)
                }
            }
            .navigationTitle("编程计划")
            .onAppear(perform: loadPlans)
            .onChange(of: plans) { _, _ in savePlans() }
        }
    }
    
    private func loadPlans() {
        do {
            plans = try PlanStorageService.shared.loadPlans()
        } catch {
            print("Watch加载计划失败: \(error)")
        }
    }
    
    private func savePlans() {
        do {
            try PlanStorageService.shared.savePlans(plans)
        } catch {
            print("Watch保存计划失败: \(error)")
        }
    }
}

struct WatchPlanRowView: View {
    @Binding var plan: PlanItem
    
    var body: some View {
        Button {
            plan.isCompleted.toggle()
        } label: {
            HStack {
                Image(systemName: plan.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(plan.isCompleted ? .green : .secondary)
                Text(plan.title)
                    .lineLimit(2)
                    .strikethrough(plan.isCompleted)
                Spacer()
            }
        }
        .buttonStyle(.plain)
    }
}