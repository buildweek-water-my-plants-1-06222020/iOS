//
//  CreatePlantVC.swift
//  WaterMyPlants
//
//  Created by Shawn James on 6/19/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit

class CreatePlantVC: UIViewController {
    
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var addAPhotoLabel: UILabel!
    @IBOutlet weak var uploadThisImageButton: UIButton!
    @IBOutlet weak var uploadProgressBar: UIProgressView!
    @IBOutlet weak var removeThisImageButton: UIButton!
    
    public var imagePicker: UIImagePickerController? // save reference to it
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialViews()
    }
    
    private func setupInitialViews() {
        deactivateButton(uploadThisImageButton)
        deactivateButton(removeThisImageButton)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
    @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
        presentPhotoLibraryActionSheet()
    }
    
    private func presentPhotoLibraryActionSheet() {
        // make sure imagePicker is nill
        if self.imagePicker != nil {
            self.imagePicker?.delegate = nil
            self.imagePicker = nil
        }
        // init image picker
        self.imagePicker = UIImagePickerController()
        // action sheet
        let actionSheet = UIAlertController(title: "Select Source Type", message: nil, preferredStyle: .actionSheet)
        // imagePickerActions
        if UIImagePickerController.isSourceTypeAvailable(.camera) { // need to have real device
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.presentImagePicker(controller: self.imagePicker!, sourceType: .camera)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
                self.presentImagePicker(controller: self.imagePicker!, sourceType: .photoLibrary)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            actionSheet.addAction(UIAlertAction(title: "Saved Albums", style: .default, handler: { _ in
                self.presentImagePicker(controller: self.imagePicker!, sourceType: .savedPhotosAlbum)
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        // present action sheet
        self.present(actionSheet, animated: true)
    }
    
    // helper for imagePicker
    func presentImagePicker(controller: UIImagePickerController, sourceType: UIImagePickerController.SourceType) {
        controller.delegate = self
        controller.sourceType = sourceType
        self.present(controller, animated: true)
    }
    
    @IBAction func uploadThisImageButtonPressed(_ sender: UIButton) {
        deactivateButton(uploadThisImageButton)
        uploadProgressBar.alpha = 1
        // TODO: activate and scale progress bar height
        // TODO: upload image to cloudinary or firebase
    }
    
    @IBAction func removeThisImageButtonPressed(_ sender: UIButton) {
        selectedImage.image = nil // reset image
        activateButton(addPhotoButton)
        addAPhotoLabel.alpha = 1
        deactivateButton(removeThisImageButton)
        deactivateButton(uploadThisImageButton)
    }
    
    func activateButton(_ button: UIButton) {
        button.isEnabled = true
        button.alpha = 1
    }
    
    func deactivateButton(_ button: UIButton) {
        button.isEnabled = false
        button.alpha = 0
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CreatePlantVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return self.imagePickerControllerDidCancel(picker)
        }
        self.selectedImage.image = image
        picker.dismiss(animated: true) {
            // clean up
            picker.delegate = nil
            self.imagePicker = nil
        }
        deactivateButton(addPhotoButton)
        addAPhotoLabel.alpha = 0
        activateButton(uploadThisImageButton)
        activateButton(removeThisImageButton)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            // clean up
            picker.delegate = nil
            self.imagePicker = nil
        }
    }
    
}
