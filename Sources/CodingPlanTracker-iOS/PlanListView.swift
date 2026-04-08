import SwiftUI
import CodingPlanSDK

struct PlanListView: View {
    @State private var plans: [PlanItem] = []
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($plans) { $plan in
                    PlanRowView(plan: $plan)
                }
                .onDelete(perform: deletePlan)
            }
            .navigationTitle("每日编程计划")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("添加计划") {
                        showingAddSheet = true
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddPlanView(onSave: addPlan)
            }
            .onAppear(perform: loadPlans)
        }
    }
    
    private func loadPlans() {
        do {
            plans = try PlanStorageService.shared.loadPlans()
        } catch {
            print("加载计划失败: \(error)")
        }
    }
    
    private func savePlans() {
        do {
            try PlanStorageService.shared.savePlans(plans)
        } catch {
            print("保存计划失败: \(error)")
        }
    }
    
    private func addPlan(_ plan: PlanItem) {
        plans.append(plan)
        savePlans()
    }
    
    private func deletePlan(offsets: IndexSet) {
        plans.remove(atOffsets: offsets)
        savePlans()
    }
}

struct PlanRowView: View {
    @Binding var plan: PlanItem
    
    var body: some View {
        HStack {
            Button {
                plan.isCompleted.toggle()
            } label: {
                Image(systemName: plan.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(plan.isCompleted ? .green : .secondary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(plan.title)
                    .strikethrough(plan.isCompleted)
                
                HStack(spacing: 8) {
                    if let tag = plan.letterTag {
                        Text(String(tag).uppercased())
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.blue)
                            .clipShape(Capsule())
                    }
                    
                    if let date = plan.dueDate {
                        Text(date, formatter: Date.shortFormatter)
                            .font(.caption)
                            .foregroundStyle(date.isOverdue ? .red : .secondary)
                    }
                }
            }
            
            Spacer()
        }
    }
}

struct AddPlanView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var selectedTag: Character?
    @State private var hasDueDate = false
    @State private var dueDate = Date()
    let onSave: (PlanItem) -> Void
    
    private let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    
    var body: some View {
        NavigationStack {
            Form {
                Section("计划内容") {
                    TextField("输入计划名称...", text: $title)
                }
                
                Section("字母标签（可选）") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 8) {
                        ForEach(letters, id: \.self) { letter in
                            Button {
                                selectedTag = selectedTag == letter ? nil : letter
                            } label: {
                                Text(String(letter))
                                    .font(.headline)
                                    .foregroundStyle(selectedTag == letter ? .white : .primary)
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity)
                                    .background(selectedTag == letter ? .blue : .gray.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                }
                
                Section("截止日期（可选）") {
                    Toggle("设置截止日期", isOn: $hasDueDate)
                    if hasDueDate {
                        DatePicker("选择日期", selection: $dueDate, displayedComponents: .date)
                    }
                }
            }
            .navigationTitle("添加新计划")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        let plan = PlanItem(
                            title: title,
                            letterTag: selectedTag,
                            dueDate: hasDueDate ? dueDate : nil
                        )
                        onSave(plan)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}