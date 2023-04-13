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
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State var task: String = ""
    @State private var showNewTaskItem: Bool = false
    
    // FETCHING DATA
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default
    )
    private var items: FetchedResults<Item>
    
    // MARK: - FUNCTION
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            ZStack {
                // main view
                VStack {
                    // header
                    
                    HStack(spacing: 10) {
                        // TITLE
                        Text("Devote")
                            .font(.system(.largeTitle))
                            .fontWeight(.heavy)
                            .padding(.leading, 4)
                        Spacer()
                
                        // EDIT BUTTON
                        EditButton()
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.horizontal)
                            .frame(minWidth: 70, minHeight: 24)
                            .background(
                                Capsule()
                                    .stroke(lineWidth: 2)
                            )
                        
                        // APPEARANCE BUTTON
                        Button {
                            isDarkMode.toggle()
                        } label: {
                            Image(systemName: isDarkMode ? "moon.circle.fill" : "moon.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .font(.system(.title))
                        }
                    } //: HSTACK
                    .padding()
                    .foregroundColor(.white)
                    
                    Spacer(minLength: 80)
                    
                    // new task button
                    
                    Button {
                        showNewTaskItem = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("New Task")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(backgroundGradientButton)
                    .clipShape(Capsule())
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 2, y: 4)
                    
                    // tasks
                    if !items.isEmpty {
                        List {
                            ForEach(items) { item in
                                ListRowItemView(item: item)
                            }
                            .onDelete(perform: deleteItems)
                        }
                        .listStyle(.insetGrouped)
                        .scrollContentBackground(.hidden)
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
                        .frame(maxWidth: 640)
                    } else {
                        Spacer(minLength: 300)
                    }
                } //: VSTACK
                
                // new task item
                if showNewTaskItem {
                    BlankView()
                        .onTapGesture {
                            withAnimation {
                                showNewTaskItem = false
                            }
                        }
                    NewTaskView(isShowing: $showNewTaskItem)
                }
            } //: ZSTACK
            .background(
                BackgroundImageView()
            )
        } //: NAVIGATION
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
