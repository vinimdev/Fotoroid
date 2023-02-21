//
//  ViewController.swift
//  Fotoroid
//
//  Created by Vinicius Meira on 20/02/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! EffectsViewController
        vc.image = (sender as! UIImage)
    }

    @IBAction func selectSource(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar foto", message: "De onde você quer escolhar a sua foto?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { action in
                self.selectedPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { action in
            self.selectedPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { action in
            self.selectedPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func selectedPicture(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let originalWidth = image.size.width
            let aspectRatio = originalWidth / image.size.height
            var smallSize: CGSize
            if aspectRatio > 1 {
                smallSize = CGSize(width: 1000, height: 1000/aspectRatio)
            } else {
                smallSize = CGSize(width: 1000*aspectRatio, height: 1000)
            }
            
            UIGraphicsBeginImageContext(smallSize)
            image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
            let smallImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            dismiss(animated: true, completion: {
                self.performSegue(withIdentifier: "effectsSegue", sender: smallImage)
            })
        }
    }
}
