//
//  Vlog.swift
//  FoodVlog(MVVM)
//
//  Created by Isiah Parra on 6/15/22.
//

import Foundation

class Vlog: Codable {
    enum Key {
        static let collectionType = "vlogs"
        static let name = "name"
        static let date = "date"
        static let entry = "entry"
        static let uuid = "uuid"
        static let location = "location"
        static let imageURL = "imageURL"
    }
    
    //MARK: Properties
    var name: String
    let date: Date
    var location: String
    var entry: String
    let uuid: String
    var imageURL: URL?
    
    // Dictionary representation
    var vlogData: [String:AnyHashable] {
        ["name": self.name,
         "entry": self.entry,
         "location": self.location,
         "uuid": self.uuid,
         "date": self.date.timeIntervalSince1970,
         "imageURL": self.imageURL?.absoluteString]
    }
    
    //MARK: Initalizers
    //designated initalizer
    init(name: String, date: Date = Date(), location: String, entry: String, uuid: String = UUID().uuidString, imageURL: URL? = nil) {
        self.name = name
        self.date = date
        self.location = location
        self.entry = entry
        self.uuid = uuid
        self.imageURL = imageURL
    }
    
    convenience init?(fromDictionary dictionary: [String:Any]) {
        guard let name = dictionary[Key.name] as? String,
        let date = dictionary[Key.date] as? Double,
        let location = dictionary[Key.location] as? String,
        let entry = dictionary[Key.entry] as? String,
        let uuid = dictionary[Key.entry] as? String,
        let imageURL = dictionary[Key.imageURL] as? String
        else {return nil}
        
        self.init(name: name, date: Date(timeIntervalSince1970: date), location: location, entry: entry, uuid: uuid, imageURL: URL(string: imageURL))
    }
    
}// end of class

extension Vlog: Equatable {
    static func == (lhs: Vlog, rhs: Vlog) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    
}
