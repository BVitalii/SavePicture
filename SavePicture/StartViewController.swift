//
//  StartViewController.swift
//  SavePicture
//
//  Created by Виталий Бородулин on 06.07.2023.
//

import UIKit

class StartViewController: UIViewController {
    
    var myTextLable: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var imageview: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var backButton:UIButton = {
        let button = UIButton()
        button.setTitle("Назад", for: .normal)
        button.addTarget(self, action: #selector(barButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.layer.cornerRadius = 22
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
    }
    
    
    func addSubview(){
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hidekeyboard)))
        view.backgroundColor = .systemGreen
        view.addSubview(addButton)
        view.addSubview(backButton)
        view.addSubview(imageview)
        view.addSubview(myTextLable)
        setConsraint()
        
    }
    
//    static func instanceFromNib() -> CustomView {
//        return UINib(nibName: "CustomView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomView }
//
    @objc func barButtonTapped(_: UIButton){
        self.dismiss(animated: true)
    }
    
    @objc func hidekeyboard(){
        self.view.endEditing(true)
    }
    
    @objc func addButtonTapped(_: UIButton){
        selectPhoto()
    }
    
    func configureWith(image: UIImage, text: String) {
        imageview.image = image
        myTextLable.text = text
        
        setupUI()
    }
    
    func setupUI() {
        imageview.layer.cornerRadius = 16
        imageview.clipsToBounds = true
        
        myTextLable.textColor = .brown
        
    }
    
    func selectPhoto (){
        let  alert = UIAlertController(title: "Загрузить из", message: "", preferredStyle: .alert)
        
        let mediaAction = UIAlertAction(title: "Фото", style: .default) { _ in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            
            picker.delegate = self
            self.present(picker, animated: true)
            
        }
        alert.addAction(mediaAction)
        
        let cameraAction = UIAlertAction(title: "Камера", style: .default) { _ in
            print("камера")
        }
        alert.addAction(cameraAction)
        
        let cancelAction = UIAlertAction(title: "Выход", style: .cancel) { _ in
            print("Выход")
        }
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
    
    func setConsraint(){
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.widthAnchor.constraint(equalToConstant: 70),
            
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            addButton.heightAnchor.constraint(equalToConstant: 44),
            addButton.widthAnchor.constraint(equalToConstant: 44),
            
            imageview.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            imageview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            imageview.bottomAnchor.constraint(equalTo: myTextLable.topAnchor, constant: -15),
            
            myTextLable.heightAnchor.constraint(equalToConstant: 44),
            myTextLable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            myTextLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            myTextLable.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -15)
        ])
    }
    
}
extension StartViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var shosenImage = UIImage()
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            shosenImage = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            shosenImage = image
        }
        
        
        
        picker.dismiss(animated: true)
    }
    
}

