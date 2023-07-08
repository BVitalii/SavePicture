//
//  ViewController.swift
//  SavePicture
//
//  Created by Виталий Бородулин on 06.07.2023.
//

import UIKit

class ViewController: UIViewController {
    
    var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(goToStartView), for: .touchUpInside)
        return button
    }()
    
    var loginTextField: UITextField = {
      let textField = UITextField()
        textField.layer.borderColor = UIColor.systemGreen.cgColor
        textField.layer.borderWidth = 0.8
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email"
        return textField
    }()
    
    var passwordTextField: UITextField = {
      let textField = UITextField()
        textField.layer.borderColor = UIColor.systemGreen.cgColor
        textField.layer.borderWidth = 0.8
        textField.layer.cornerRadius = 10
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        setConstraint()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hidekeyboard)))
    }
    
    @objc func hidekeyboard(){
        self.view.endEditing(true)
    }
    
    @objc func goToStartView(){
        let startViewController = StartViewController()
        startViewController.modalPresentationStyle = .fullScreen
        self.present(startViewController, animated: true)
    }
    
    func setConstraint(){
        NSLayoutConstraint.activate([
            loginTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            loginTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            loginTextField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 5),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 44)
            
        ])
    }
}

