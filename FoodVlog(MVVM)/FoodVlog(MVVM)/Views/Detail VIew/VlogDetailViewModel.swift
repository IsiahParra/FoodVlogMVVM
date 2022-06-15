//
//  VlogDetailViewModel.swift
//  FoodVlog(MVVM)
//
//  Created by Isiah Parra on 6/15/22.
//

import Foundation
import UIKit

class VlogDetailViewModel {
    
    var vlog: Vlog?
    private let service: FirebaseSyncable
    
    init(vlog: Vlog? = nil, service: FirebaseSyncable = FirebaseService()) {
        self.vlog = vlog
        self.service = service
    }
    
    func saveVlog(with name: String, entry: String, location: String, image: UIImage) {
        if vlog != nil {
            updateVlog(with: name, entry: entry, location: location, image: image)
        } else {
            self.vlog = Vlog(name: name, location: location, entry: entry)
            service.save(vlog: self.vlog!, with: image)
        }
    }
    
    private func updateVlog(with name: String, entry: String, location: String, image: UIImage) {
        
        guard let vlog = vlog else {
            return
        }
        vlog.name = name
        vlog.entry = entry
        vlog.location = location
        service.save(vlog: vlog, with: image)
    }
    
    func getImage(completion: @escaping (UIImage?) -> Void) {
        guard let vlog = vlog else {
            return
        }
        service.fetchImage(from: vlog) { result in
            switch result {
            case .success(let image):
                completion(image)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
}// end of class
