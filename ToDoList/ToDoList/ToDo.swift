//
//  ToDo.swift
//  ToDoList
//
//  Created by Angela Sanhcez on 4/9/22.
//

import Foundation
import UIKit

struct ToDo: Codable{
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("todos").appendingPathExtension("plist")
    
    static func loadToDos() -> [ToDo]?  {
        guard let codedToDos = try? Data(contentsOf: ArchiveURL) else {return nil}
        
        let propertyListDecoder = PropertyListDecoder()
        
        return try? propertyListDecoder.decode(Array<ToDo>.self, from: codedToDos)
    }
    
    static func saveToDos(_ todos: [ToDo]) {
        let propertyListEncoder = PropertyListEncoder()
        
        let codedToDos = try? propertyListEncoder.encode(todos)
        
        try? codedToDos?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static let dueDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
 
    static func loadSampleToDo() -> [ToDo]{
        let todo1 = ToDo(title: "ToDo one", isComplete: false, dueDate: Date(), notes: "Note 1")
        let todo2 = ToDo(title: "ToDo two", isComplete: false, dueDate: Date(), notes: "Note 2")
        let todo3 = ToDo(title: "ToDo three", isComplete: false, dueDate: Date(), notes: "Note 3")
        
        return [todo1, todo2, todo3]
    }
}
