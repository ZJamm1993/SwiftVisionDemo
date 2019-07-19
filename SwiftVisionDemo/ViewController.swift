//
//  ViewController.swift
//  Sapp
//
//  Created by dabby on 2019/7/19.
//  Copyright © 2019 Jam. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var inputImageView: UIImageView!
    @IBOutlet weak var outputImageView: UIImageView!
    
    var model: DeepLabV3Model = DeepLabV3Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func myFunc() -> String {
        return "adf"
    }
    
    @IBAction func addNewPhoto(_ sender: UIBarButtonItem) {
        let picker = UIImagePickerController()
        picker.sourceType = .savedPhotosAlbum
        picker.delegate = self
        self.present(picker, animated: true) {
            print("presented UIImagePickerController")
        }
//        self .addNumber(number1: 1, number2: 2)
    }
    
//    func addNumber(number1: Int, number2: Int) -> Void {
//        print("sth");
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage]
        self.didSelectPhoto(image: image as! UIImage)
        picker.dismiss(animated: true) {
            print("dismissed UIImagePickerController")
        }
    }
    
    func didSelectPhoto(image: UIImage) {
        self.inputImageView.image = image
        self.model.inputImage(image: image) { (outputArr: Array) in
            let first = outputArr.first
            self.outputImageView.image = first
        }
    }
}

