//
//  ViewController.swift
//  TaskTracker
//
//  Created by wfh on 06/01/21.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var registrationView: UIView!
    @IBOutlet weak var loginEmailTextField: UITextField!
    
    @IBOutlet weak var loginPasswordTextField: UITextField!
    @IBOutlet weak var registerEmailTextField: UITextField!
    @IBOutlet weak var registerPasswordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var agePasswordTextField: UITextField!
    
    var logInViewModel = LogInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSegmentSelectedView(segment: 0)
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        setSegmentSelectedView(segment: segmentController.selectedSegmentIndex)
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        CustomActivityIndicator.instance.showLoaderView()
        logInViewModel.serviceCallForRegister(name: registerEmailTextField.text ?? "", password: registerPasswordTextField.text ?? "", email: registerEmailTextField.text ?? "", age: agePasswordTextField.text ?? "") {[weak self] (isRegisterSuccess, data) in
            CustomActivityIndicator.instance.hideLoaderView()
            if isRegisterSuccess {
                //Navigate to Dashboard
            } else {
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

