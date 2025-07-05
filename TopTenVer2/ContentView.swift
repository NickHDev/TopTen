//
//  ContentView.swift
//  TopTenVer2
//
//  Created by Nicholas M Hieb on 6/29/25.
//

import SwiftUI
import SwiftData

struct ContentView: View
{
  @Environment(\.modelContext) var context
  
  @Query var list: [ListItem] = []
  @State private var newListName: String = ""
  
  
  var body: some View
  {
    VStack
    {
      Text("Top 10 Lists")
        .font(.title)
        .padding(10)
        .background(Color.teal.opacity(1))
        .foregroundColor(.black)
        .cornerRadius(10)
        .shadow(radius: 6)
      
      NavigationStack
      {
        List
        {
          ForEach(list) { item in
            NavigationLink(destination: ListDetail(listItem: item)) {
              Text(item.name)
            }
          }
          .onDelete(perform: deleteItems)
        }
        .toolbar {
          ToolbarItem(placement: .automatic)
            {
              TextField("Enter New List", text: $newListName)
                .textFieldStyle(.roundedBorder)
                .padding(.vertical, 4)
            }
          ToolbarItem(placement: .navigationBarTrailing) {
            EditButton()
          }
          ToolbarItem {
            Button(action: addList) {
              Label("Add Item", systemImage: "plus")
            }
          }
        }
      }
    }
    
  }
  
  
  private func addList()
  {
    let newList = ListItem(name: newListName)
    for i in 1...10 {
      let newEntry = ListEntry(name: "Item \(i)", rank: i)
      newList.entries.append(newEntry)
    }
    context.insert(newList)
    newListName = ""
  }
  
  private func deleteItems(offsets: IndexSet)
  {
    withAnimation
    {
      for index in offsets
      {
        let item = list[index]
        context.delete(item)
      }
    }
  }
  
}

#Preview {
  ContentView()
    .modelContainer(for: [ListItem.self, ListEntry.self], inMemory: true)
}
