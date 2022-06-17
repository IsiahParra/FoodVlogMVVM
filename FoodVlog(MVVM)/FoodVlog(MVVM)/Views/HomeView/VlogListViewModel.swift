//
//  VlogListViewModel.swift
//  FoodVlog(MVVM)
//
//  Created by Isiah Parra on 6/15/22.
//

import Foundation
protocol VlogListViewModelDelegate: AnyObject {
    func vlogsLoadedSuccessfully()
}

class VlogListViewModel {
    
    var vlogs: [Vlog] = []
    private var service: FirebaseSyncable
    private weak var delegate: VlogListViewModelDelegate?
    //dependency injection
    init(delegate: VlogListViewModelDelegate, service: FirebaseSyncable = FirebaseService()) {
        self.delegate = delegate
        self.service = service
    }
    
    func loadData() {
        service.loadVlogs { result in
            switch result{
            case .success(let vlogs):
                self.vlogs = vlogs
                self.delegate?.vlogsLoadedSuccessfully()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func delete(index: Int) {
        let vlog = vlogs[index]
        vlogs.remove(at: index)
        service.delete(vlog: vlog)
    }
}// end of class
