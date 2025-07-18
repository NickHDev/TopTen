//
//  List.swift
//  TopTenVer2
//
//  Created by Nicholas M Hieb on 6/29/25.
//

import Foundation
import SwiftData
import SwiftUI
// Swift Data for saving the lists to the phone
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
// How to layout the list of 10 items
struct ListDetail: View {
  @Bindable var listItem: ListItem
  var sortedEntries: [ListEntry] {
    listItem.entries.sorted { $0.rank < $1.rank }
  }
  
  var body: some View {
    VStack {
      Text(listItem.name)
        .font(.headline)
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
      
      Divider()
      
      List() {
        ForEach(sortedEntries) { entry in
          HStack {
            switch entry.rank {
            case 1:
              HStack {
                Image(systemName: "star.fill")
                  .foregroundStyle(.yellow)
                Text("1.")
              }
            case 2:
              HStack {
                Image(systemName: "star.fill")
                  .foregroundStyle(.gray)
                Text("2.")
              }
            case 3:
              HStack {
                Image(systemName: "star.fill")
                  .foregroundStyle(.brown)
                Text("3.")
              }
            default:
              Text("\(entry.rank).")
            }
            TextField("Entry", text: Binding(get: {
              entry.name
            }, set: { newValue in
              entry.name = newValue
            }))
            .textFieldStyle(RoundedBorderTextFieldStyle())
          }
          .padding(.vertical, 4)
        }
        .onMove(perform: moveEntries)
      }
      .toolbar {
        EditButton()
      }
    }
  }
  // Function to be able to move items in the list
  private func moveEntries(from source: IndexSet, to destination: Int) {
    var entries = sortedEntries
    entries.move(fromOffsets: source, toOffset: destination)
    for (index, entry) in entries.enumerated() {
      entry.rank = index + 1
    }
  }
}

// How the list item looks
struct ComicListRow: View {
  let item: ListItem
  
  var body: some View {
    HStack {
      ZStack {
        Circle()
          .fill(Color.blue)
          .frame(width: 40, height: 40)
        
        Circle()
          .stroke(Color.clear, lineWidth: 2)
          .frame(width: 40, height: 40)
      }
      
      VStack(alignment: .leading, spacing: 4) {
        Text(item.name)
          .font(.system(size: 20, weight: .bold, design: .rounded))
          .foregroundColor(.black)
      }
      
      Spacer()
      
    }
    .padding(4)
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(Color.white)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 2, y: 2)
    )
    .overlay(
      RoundedRectangle(cornerRadius: 16)
        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
    )
    .padding(.horizontal, 8)
    .padding(.vertical, 3)
  }
}

// How the button for the list item looks
struct ComicButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.system(size: 15, weight: .bold, design: .rounded))
      .foregroundColor(.white)
      .padding(.horizontal, 5)
      .padding(.vertical, 5)
      .background(
        RoundedRectangle(cornerRadius: 12)
          .fill(Gradient(colors: [.blue, .mint]))
          .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
      )
      .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
      .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
  }
}
