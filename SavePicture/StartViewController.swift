//
//  StartViewController.swift
//  SavePicture
//
//  Created by Виталий Бородулин on 06.07.2023.
//

import UIKit

class StartViewController: UIViewController {
    
    var curNewName: String?
    
    var contentView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var myTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 0.8
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        //        imageView.backgroundColor = .white
        //        imageView.layer.borderWidth = 1
        //        imageView.layer.borderColor = UIColor.gray.cgColor
        //        imageView.layer.cornerRadius = 5
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
        button.layer.borderWidth = 0.8
        button.layer.borderColor = UIColor.gray.cgColor
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var saveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "tray.and.arrow.down"), for: .normal)
        button.layer.cornerRadius = 22
        button.layer.borderWidth = 0.8
        button.layer.borderColor = UIColor.gray.cgColor
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(savebuttonTapped), for: .touchUpInside)
        return button
    }()
    
    var loadButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "tray.and.arrow.up"), for: .normal)
        button.layer.cornerRadius = 22
        button.layer.borderWidth = 0.8
        button.layer.borderColor = UIColor.gray.cgColor
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loadButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        myTextField.delegate = self
    }
    
    func addSubview(){
        view.addSubview(contentView)
        contentView.backgroundColor = .systemGreen
        contentView.addSubview(addButton)
        contentView.addSubview(backButton)
        contentView.addSubview(imageView)
        contentView.addSubview(myTextField)
        contentView.addSubview(loadButton)
        contentView.addSubview(saveButton)
        setConsraint()
        
        
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hidekeyboard)))
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func barButtonTapped(_: UIButton){
        self.dismiss(animated: true)
    }
    
    @objc func hidekeyboard(){
        func textFieldDidEndEditing(_ textField: UITextField) {
            guard let name = textField.text else { return }
            curNewName = name
            
        }
        self.view.endEditing(true)
    }
    
    @objc func addButtonTapped(_: UIButton){
        selectPhoto()
    }
    
    @objc func willShowKeyboard(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let buttonSpace = self.contentView.frame.height - (myTextField.frame.origin.y + myTextField.frame.height)
            self.contentView.frame.origin.y -= keyboardHeight - buttonSpace
        }
    }
    
    @objc func willHideKeyboard(_ notification: NSNotification) {
        self.contentView.frame.origin.y = 0
    }
    
    @objc func savebuttonTapped(_ sender: Any) {
        saveNewNameImage()
    }
    
    @objc func loadButtonTapped(_ sender: Any) {
        loadNewNameImage()
    }
    
    func saveImage(image: UIImage) -> String? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first, let curNewName = curNewName else { return nil }
        
        let fileName = curNewName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        guard let data = image.jpegData(compressionQuality: 1) else { return nil }
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                checkNamePhoto ()
                print("Removed old image")
            } catch let error {
                print("couldn't remove file at path", error)
            }
        }
        do {
            try data.write(to: fileURL)
            return fileName
        } catch let error {
            print("error saving file with error", error)
            return nil
        }
    }
    
    func loadImage(fileName: String) -> UIImage? {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let imageUrl = documentsDirectory.appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        return nil
    }
    
    func checkNamePhoto (){
        let  alert = UIAlertController(title: "Ошибка сохранения", message: "выберете другое имя", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Выход", style: .cancel) { _ in
            print("Выход")
        }
        alert.addAction(cancelAction)
        present(alert, animated: true)
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
    
    func loadNewNameImage(){
        guard let name = UserDefaults.standard.value(forKey: "key") as? String else {
            return
        }
        let newImage = loadImage(fileName: name)
        imageView.image = newImage
        
        myTextField.text = name
    }
    
    func saveNewNameImage() {
        guard let image = imageView.image else {
            return
        }
        let nameImage = saveImage(image: image)
        UserDefaults.standard.setValue(nameImage, forKey: "key")
        
    }
    
    func setConsraint(){
        NSLayoutConstraint.activate([
            
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.widthAnchor.constraint(equalToConstant: 70),
            
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            addButton.heightAnchor.constraint(equalToConstant: 44),
            addButton.widthAnchor.constraint(equalToConstant: 44),
            
            loadButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15),
            loadButton.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -15),
            loadButton.heightAnchor.constraint(equalToConstant: 44),
            loadButton.widthAnchor.constraint(equalToConstant: 44),
            
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15),
            saveButton.trailingAnchor.constraint(equalTo: loadButton.leadingAnchor, constant: -15),
            saveButton.heightAnchor.constraint(equalToConstant: 44),
            saveButton.widthAnchor.constraint(equalToConstant: 44),
            
            imageView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: -5),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            // imageView.bottomAnchor.constraint(equalTo: myTextField.topAnchor, constant: -100),
            
            myTextField.heightAnchor.constraint(equalToConstant: 44),
            myTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            myTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            myTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10)
        ])
    }
    
}
extension StartViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var chosenImage = UIImage()
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            chosenImage = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            chosenImage = image
        }
        imageView.image = chosenImage
        
        picker.allowsEditing = true
        
        picker.dismiss(animated: true)
    }
    
}

extension StartViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let name = textField.text else { return }
        curNewName = name
        
    }
}

