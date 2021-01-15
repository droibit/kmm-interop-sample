//
//  TaskView.swift
//  ios
//
//  Created by Shinya Kumagai on 2021/01/15.
//  Copyright © 2021 orgName. All rights reserved.
//

import Shared
import SwiftUI

struct TaskView: View {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()

    @StateObject private var viewModel = TaskViewModel()
    
    @State private var selectedTask: Task?
    
    @State private var presentsNewTaskAlert: Bool = false
    
    var body: some View {
        List(viewModel.tasks) { task in
            Button(task.title) {
                self.selectedTask = task
            }.alert(item: self.$selectedTask) { selectedTask in
                Alert(title: Text(selectedTask.title),
                      message: Text("Status: \(task.status)\nCreated at \(Self.dateFormatter.string(from: TimeInterval(task.createdAtMillis)))"))
            }
        }
        .onAppear(perform: viewModel.onAppear)
        .listStyle(PlainListStyle())
        .navigationBarTitle("Task", displayMode: .inline)
        .navigationBarItems(
            trailing: Button(
                action: viewModel.createRandomTask,
                label: { Image(systemName: "plus") }
            )
        )
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TaskView()
        }
    }
}

private extension DateFormatter {
    func string(from date: TimeInterval) -> String {
        string(from: Date(timeIntervalSince1970: date / 1000.0))
    }
}
