//
//  ViewController.swift
//  TaskTracker
//
//  Created by Harsha on 06/01/21.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var segmentController: UISegmentedControl!{
        didSet{
            segmentController.layer.cornerRadius = 5
            segmentController.layer.borderWidth = 1
            segmentController.layer.borderColor = UIColor.gray.cgColor
        }
    }
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var registrationView: UIView!
    
    @IBOutlet weak var loginEmailTextField: UITextField!{
        didSet{
            loginEmailTextField.layer.cornerRadius = 5
            loginEmailTextField.layer.borderWidth = 1
            loginEmailTextField.layer.borderColor = UIColor.gray.cgColor
        }
    }
    @IBOutlet weak var loginPasswordTextField: UITextField!{
        didSet{
            loginPasswordTextField.layer.cornerRadius = 5
            loginPasswordTextField.layer.borderWidth = 1
            loginPasswordTextField.layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    @IBOutlet weak var registerEmailTextField: UITextField!{
        didSet{
            registerEmailTextField.layer.cornerRadius = 5
            registerEmailTextField.layer.borderWidth = 1
            registerEmailTextField.layer.borderColor = UIColor.gray.cgColor
        }
    }
    @IBOutlet weak var registerPasswordTextField: UITextField!{
        didSet{
            registerPasswordTextField.layer.cornerRadius = 5
            registerPasswordTextField.layer.borderWidth = 1
            registerPasswordTextField.layer.borderColor = UIColor.gray.cgColor
        }
    }
    @IBOutlet weak var nameTextField: UITextField!{
        didSet{
            nameTextField.layer.cornerRadius = 5
            nameTextField.layer.borderWidth = 1
            nameTextField.layer.borderColor = UIColor.gray.cgColor
        }
    }
    @IBOutlet weak var agePasswordTextField: UITextField!{
        didSet{
            agePasswordTextField.layer.cornerRadius = 5
            agePasswordTextField.layer.borderWidth = 1
            agePasswordTextField.layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet{
            loginButton.layer.cornerRadius = 5
            loginButton.layer.borderWidth = 1
            loginButton.layer.borderColor = UIColor.gray.cgColor
        }
    }
    @IBOutlet weak var registerButton: UIButton!{
        didSet{
            registerButton.layer.cornerRadius = 5
            registerButton.layer.borderWidth = 1
            registerButton.layer.borderColor = UIColor.gray.cgColor
        }
    }
    var logInViewModel = LogInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Welcome to BAS Trucks"
        setSegmentSelectedView(segment: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        setSegmentSelectedView(segment: segmentController.selectedSegmentIndex)
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        CustomActivityIndicator.instance.showLoaderView()
        logInViewModel.serviceCallForLogin(email: loginEmailTextField.text ?? "", password: loginPasswordTextField.text ?? "") {[weak self] (isLoginSuccess, data) in
            CustomActivityIndicator.instance.hideLoaderView()
            if isLoginSuccess {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "DashboardViewContrtoller") as? DashboardViewContrtoller {
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                Utils().showAlert(title: "Error", description: "Error Logging In!, Try again", buttonTitle:"OK", sender: self!)
            }
        }
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        CustomActivityIndicator.instance.showLoaderView()
        logInViewModel.serviceCallForRegister(name: registerEmailTextField.text ?? "", password: registerPasswordTextField.text ?? "", email: registerEmailTextField.text ?? "", age: agePasswordTextField.text ?? "") {[weak self] (isRegisterSuccess, data) in
            CustomActivityIndicator.instance.hideLoaderView()
            if isRegisterSuccess {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "DashboardViewContrtoller") as? DashboardViewContrtoller {
                    self?.navigationController?.pushViewController(vc, animated: true)
                }            } else {
                    Utils().showAlert(title: "Error", description: "Error Registering, Try again", buttonTitle:"OK", sender: self!)
                }
        }
    }
    
    func setSegmentSelectedView(segment: Int) {
        switch segment {
        case 0:
            loginView.isHidden = false
            registrationView.isHidden = true
        case 1:
            loginView.isHidden = true
            registrationView.isHidden = false
        default:
            break;
        }
    }
}

