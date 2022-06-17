//
//  FirebaseService.swift
//  FoodVlog(MVVM)
//
//  Created by Isiah Parra on 6/15/22.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit

protocol FirebaseSyncable {
    func save(vlog: Vlog, with image: UIImage?, completion: @escaping () -> Void)
    func loadVlogs(callback: @escaping (Result<[Vlog], FirebaseError>) -> Void)
    func delete(vlog: Vlog)
    func saveImage(_ image: UIImage, to vlog: Vlog, completion: @escaping () -> Void)
    func fetchImage(from vlog: Vlog, completion: @escaping (Result<UIImage,FirebaseError>) -> Void)
    func deleteImage(from vlog: Vlog)
}
enum FirebaseError: Error {
    case firebaseError(Error)
    case failedToUnwrapData
    case noDataFound
}

struct FirebaseService: FirebaseSyncable {
    
    let reference = Firestore.firestore()
    let storage = Storage.storage().reference()
    
    func save(vlog: Vlog, with image: UIImage?,completion: @escaping () -> Void) {
        if let image = image {
            saveImage(image, to: vlog) {
                reference.collection(Vlog.Key.collectionType).document(vlog.uuid).setData(vlog.vlogData)
                completion()
            }
        } else {
            reference.collection(Vlog.Key.collectionType).document(vlog.uuid).setData(vlog.vlogData)
            completion()
        }
    }
    
    func loadVlogs(callback: @escaping (Result<[Vlog], FirebaseError>) -> Void) {
        reference.collection(Vlog.Key.collectionType).getDocuments { snapshot, error in
            if let error = error {
                callback(.failure(.firebaseError(error))); return
            }
            guard let data = snapshot?.documents else {
                callback(.failure(.noDataFound))
                return
            }
            let dataArray = data.compactMap({$0.data()})
            let vlogs = dataArray.compactMap({Vlog(fromDictionary: $0)})
            callback(.success(vlogs))
        }
    }
    
    func delete(vlog: Vlog) {
        reference.collection(Vlog.Key.collectionType).document(vlog.uuid).delete()
    }
    
    func saveImage(_ image: UIImage, to vlog: Vlog, completion: @escaping () -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5)
        else {return}
        storage.child("images").child(vlog.uuid).putData(imageData, metadata: nil) { response, error in
            if let error = error {
                print(error.localizedDescription)
                completion()
                return
            }
            self.storage.child("images").child(vlog.uuid).downloadURL { url, error in
                if let error = error {
                    print(error.localizedDescription)
                    completion()
                    return
                }
                guard let url = url else {
                    return
                }
                vlog.imageURL = url
                completion()
            }
        }
    }
    
    func fetchImage(from vlog: Vlog, completion: @escaping (Result<UIImage,FirebaseError>) -> Void) {
        storage.child("images").child(vlog.uuid).getData(maxSize: 1024 * 1024) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completion(.failure(.failedToUnwrapData))
                    return
                }
                completion(.success(image))
                
            case .failure(let error):
                completion(.failure(.firebaseError(error)))
            }
        }
    }
    
    func deleteImage(from vlog: Vlog) {
        storage.child("images").child(vlog.uuid).delete(completion: nil)
    }
    
}// end of struct
