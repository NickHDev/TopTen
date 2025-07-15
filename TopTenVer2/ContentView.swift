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
    ZStack {
      VStack(spacing: 20) {
        // Custom title
        Image("comic shape")
            .resizable()
            .frame(width: 300, height: 175
            )
            .aspectRatio(contentMode: .fit)
        
        NavigationStack {
          List {
            ForEach(list) { item in
              NavigationLink(destination: ListDetail(listItem: item)) {
                ComicListRow(item: item)
              }
            }
            .onDelete(perform: deleteItems)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
          }
          .listStyle(PlainListStyle())
          .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
              TextField("Enter New List", text: $newListName)
                .textFieldStyle(.roundedBorder)
              
              Button(action: addList){
                HStack(alignment: .center) {
                  Image(systemName: "plus")
                    .foregroundColor(.white)
                  Text("Add")
                }
              }
              .buttonStyle(ComicButtonStyle())
              .padding(3)

              EditButton()
                .foregroundColor(.white)
                .background(
                  RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue)
                    .shadow(color: .black.opacity(0.3), radius: 1.5, x: 1.5, y: 1.5)
                )
            }
          }
        }
      }
    }
  }
  
  
  // Adding a list using Swift Data to save it
  private func addList()
  {
    withAnimation(Animation.easeIn)
    {
      let newList = ListItem(name: newListName)
      for i in 1...10 {
        let newEntry = ListEntry(name: "Item \(i)", rank: i)
        newList.entries.append(newEntry)
      }
      context.insert(newList)
      newListName = ""
    }
  }
  // Delete Items in the list using Swift Data
  private func deleteItems(offsets: IndexSet)
  {
    withAnimation(Animation.easeOut)
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
