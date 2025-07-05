//
//  List.swift
//  TopTenVer2
//
//  Created by Nicholas M Hieb on 6/29/25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class ListEntry: Identifiable, Equatable {
  var name: String
  var rank: Int
  init (name: String, rank: Int) {
    self.name = name
    self.rank = rank
  }
}
@Model
final class ListItem: Identifiable {
    var name: String
    @Relationship(deleteRule: .cascade) var entries: [ListEntry] = []

    init(name: String) {
        self.name = name
    }
}
struct ListDetail: View {
  @Bindable var listItem: ListItem
  @Query private var draftEntries: [ListEntry]
  @State private var newListName: String = ""
  
  var body: some View {
    VStack {
      Text(listItem.name)
        .font(.headline)
        .padding()
        .background(Color.secondary)
        .cornerRadius(8)
      Divider()
      
      List() {
        ForEach(draftEntries) { entry in
          HStack {
            Text("\(entry.rank)")
              .frame(width: 30, alignment: .leading)
              .fontWeight(.bold)
            TextField("Entry", text: $newListName)
              .textFieldStyle(RoundedBorderTextFieldStyle())
          }
          .padding(.vertical, 4)
        }
        .onMove(perform: moveEntries)
      }
      .navigationTitle("Edit \(listItem.name)")
      .toolbar {
        EditButton()
      }
    }
  }
  
  private func moveEntries(from source: IndexSet, to destination: Int) {
    var updatedEntries = draftEntries
    updatedEntries.move(fromOffsets: source, toOffset: destination)
    for (index, entry) in updatedEntries.enumerated() {
      entry.rank = index + 1
    }
  }
  
  
}
