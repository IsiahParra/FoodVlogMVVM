//
//  VlogDetailViewController.swift
//  FoodVlog(MVVM)
//
//  Created by Isiah Parra on 6/15/22.
//

import UIKit

class VlogDetailViewController: UIViewController,   UINavigationControllerDelegate {
    
    @IBOutlet weak var foodEntryTextField: UITextField!
    @IBOutlet weak var locationOfFoodTextField: UITextField!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodReviewTextField: UITextView!
    
    var viewModel: VlogDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        updateUI()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = foodEntryTextField.text, !title.isEmpty,
              let location = locationOfFoodTextField.text,
              let entry = foodReviewTextField.text
        else {return}
        let image = foodImageView.image
        viewModel.saveVlog(with: title, entry: entry, location: location, image: image) {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @objc func imageViewTapped() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    private func updateUI() {
        guard let vlog = viewModel.vlog else {return}
        foodEntryTextField.text = vlog.name
        locationOfFoodTextField.text = vlog.location
        foodReviewTextField.text = vlog.entry
        viewModel.getImage { image in
            self.foodImageView.image = image
        }
    }
    
    private func setupImageView() {
        foodImageView.contentMode = .scaleAspectFit
        foodImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        foodImageView.addGestureRecognizer(tapGesture)
    }
    
}// end of class

// Extension
extension VlogDetailViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
    foodImageView.image = image
    }
}
