//
//  ContentView.swift
//  Devote
//
//  Created by Pham Nguyen Phu on 11/04/2023.
//

import CoreData
import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTY
    
    @State var task: String = ""
    
    private var isButtonDisable: Bool {
        task.isEmpty
    }
    
    // FETCHING DATA
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default
    )
    private var items: FetchedResults<Item>
    
    // MARK: - FUNCTION
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.completion = false
            newItem.id = UUID()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            task = ""
            hideKeyboard()
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    VStack(spacing: 16) {
                        TextField("New Task", text: $task)
                            .padding()
                            .background(
                                Color(UIColor.systemGray6)
                            )
                            .cornerRadius(12)
                        
                        Button {
                            addItem()
                        } label: {
                            Spacer()
                            Text("SAVE")
                            Spacer()
                        }
                        .disabled(isButtonDisable)
                        .padding()
                        .foregroundColor(.white)
                        .font(.headline)
                        .background(isButtonDisable ? .gray : .pink)
                        .cornerRadius(12)
                    } //: VSTACK
                    .padding()
                    List {
                        ForEach(items) { item in
                            NavigationLink {
                                Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(item.task ?? "")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    Text(item.timestamp!, formatter: itemFormatter)
                                }
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
                    .frame(maxWidth: 640)
                } //: VSTACK
            } //: ZSTACK
            .background(
                BackgroundImageView()
            )
            .background(
                backgroundGradient
            )
            
            .navigationTitle("Daily Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            } //: TOOLBAR
        } //: NAVIGATION
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
