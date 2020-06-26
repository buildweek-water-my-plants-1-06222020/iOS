//
//  OnboardViewController.swift
//  WaterMyPlants
//
//  Created by Joe Veverka on 6/19/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit

//Helper enum
enum LoginType {
    case signUp
    case signIn
}

class OnboardViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var signUpSignInLabel: UILabel!
    @IBOutlet weak var createAccountLabel: UILabel!
    @IBOutlet weak var signUpSignInSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var greyView1: UIView!
    @IBOutlet weak var greyView2: UIView!
    @IBOutlet weak var loginScrollView: UIScrollView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var rememberMeButton: UIButton!
    
    //MARK: - Properties
    var plantController = PlantController()
    var selectedLoginType: LoginType = .signIn {
        
        didSet {
            
            switch selectedLoginType {
                
            case .signUp:
                // signUp label
                signUpSignInLabel.fadeOut()
                signUpSignInLabel.text = "Sign Up"
                signUpSignInLabel.fadeIn()
                // createAccount label
                createAccountLabel.fadeOut()
                createAccountLabel.text = "Create Account"
                createAccountLabel.fadeIn()
                // phoneText
                phoneNumberTextField.isHidden = false
                phoneNumberTextField.fadeIn()
                phoneNumberTextField.isHidden = false
                // signInButton
                signInButton.fadeOut()
                signInButton.isEnabled = false
                // signUpButton
                signUpButton.fadeIn()
                signUpButton.isEnabled = true
                // rememberMe button
                rememberMeButton.fadeOut()
                rememberMeButton.isEnabled = false
                
            case .signIn:
                // Sign In label
                signUpSignInLabel.fadeOut()
                signUpSignInLabel.text = "Sign In"
                signUpSignInLabel.fadeIn()
                // create account label
                createAccountLabel.fadeOut()
                createAccountLabel.text = "Welcome Back"
                createAccountLabel.fadeIn()
                // phoneText
                phoneNumberTextField.fadeOut()
                // signIn button
                signInButton.fadeOut()
                signInButton.isHidden = false
                signInButton.fadeIn()
                signInButton.isEnabled = true
                // signUp button
                signUpButton.fadeOut()
                signUpButton.isEnabled = false
                // remember me button
                rememberMeButton.fadeIn()
                rememberMeButton.isEnabled = true

            }
        }
    }

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.addBottomBorder()
        passwordTextField.addBottomBorder()
        phoneNumberTextField.addBottomBorder()
        greyView1.layer.cornerRadius = 15.0
        greyView2.layer.cornerRadius = 15.0
        signInButton.isHidden = true
        autofillTextFields()
        updateRememberMeButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        signUpSignInLabel.fadeIn()
        createAccountLabel.fadeIn()

        //handling keyboard
        self.loginScrollView.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        phoneNumberTextField.delegate = self
        usernameTextField.tag = 1
        passwordTextField.tag = 2

        //subscribe to a Notification which will fire before the keyboard will show
        subscribeToNotification(UIResponder.keyboardWillShowNotification, selector: #selector(keyboardWillShowOrHide))

        //subscribe to a Notification which will fire before the keyboard will hide
        subscribeToNotification(UIResponder.keyboardWillHideNotification, selector: #selector(keyboardWillShowOrHide))

        //make a call to our keyboard handling function as soon as the view is loaded.
        initializeHideKeyboard()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Unsubscribe from all our notifications
        unsubscribeFromAllNotifications()
    }
    
    @IBAction func signUpSignInSegmentedAction(_ sender: UISegmentedControl) {
        switch signUpSignInSegmentedControl.selectedSegmentIndex {
        case 0:
            selectedLoginType = .signUp
            passwordTextField.textContentType = .newPassword
            
        case 1:
            selectedLoginType = .signIn
            passwordTextField.textContentType = .password
            
        default:
            break
        }
    }
    
    // FIXME: - Passing dummy phonenumber....
    // MARK: - Actions
    @IBAction func signUp(_ sender: UIButton) {
        guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            password.isEmpty == false,
            let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            username.isEmpty == false,
            let phoneNumber = phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            phoneNumber.isEmpty == false
            else { return }
        
        
        
        let userRep = UserRepresentation(username: username, password: password, phoneNumber: phoneNumber, identifier: nil)
        
        plantController.signUp(for: userRep) { (result) in
            if result == .success(true) {
                print(result)
                DispatchQueue.main.async {
                    self.signUpSignInSegmentedControl.selectedSegmentIndex = 1
                    // Sign In label
                    self.signUpSignInLabel.fadeOut()
                    self.signUpSignInLabel.text = "Sign In"
                    self.signUpSignInLabel.fadeIn()
                    // create account label
                    self.createAccountLabel.fadeOut()
                    self.createAccountLabel.text = "Welcome Back"
                    self.createAccountLabel.fadeIn()
                    // phoneText
                    self.phoneNumberTextField.fadeOut()
                    // signIn button
                    self.signInButton.fadeOut()
                    self.signInButton.isHidden = false
                    self.signInButton.fadeIn()
                    self.signInButton.isEnabled = true
                    // signUp button
                    self.signUpButton.fadeOut()
                    self.signUpButton.isEnabled = false
                    // remember me button
                    self.rememberMeButton.fadeIn()
                    self.rememberMeButton.isEnabled = true
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    
                }
            } else {
                let title =  "Registration Failed"
                let message = "Please try again later."
                print(result)
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    let alertActionFailure = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(alertActionFailure)
                    self.present(alertController, animated: true) {
                        self.usernameTextField.text = ""
                        self.passwordTextField.text = ""
                    }
                }
            }
        }
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            password.isEmpty == false,
            let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            username.isEmpty == false
            else { return }
        let phoneNumber = "1234567890"
        let userRep = UserRepresentation(username: username, password: password, phoneNumber: phoneNumber, identifier: nil)
        
        plantController.logIn(for: userRep) { (result) in
            if result == .success(true) {
                UserDefaults.standard.set(true, forKey: "isSigningIn") // this just makes sure the fetch method will be called
                print(result)
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    }
                }
            } else {
                let title =  "Sign-In Failed"
                let message = "Please try again later."
                print(result)
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    let alertActionFailure = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(alertActionFailure)
                    self.present(alertController, animated: true) {
                        self.usernameTextField.text = ""
                        self.passwordTextField.text = ""
                    }
                }
            }
        }
    }
    
    @IBAction func rememberMeButtonPressed(_ sender: UIButton) {
        // save username and pass
        UserDefaults.standard.set(usernameTextField.text, forKey: "usernameKey")
        UserDefaults.standard.set(passwordTextField.text, forKey: "passwordKey")
        rememberMeButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
    }
    
    @IBAction func credentialsDidUpdate(_ sender: UITextField) {
        updateRememberMeButton()
    }
    
    // MARK: - Methods
    private func updateRememberMeButton() {
        // should rememberMeButton be selected
        if usernameTextField.text == UserDefaults.standard.object(forKey: "usernameKey") as? String
            && passwordTextField.text == UserDefaults.standard.object(forKey: "passwordKey") as? String {
            rememberMeButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        } else {
            rememberMeButton.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }
    
    private func autofillTextFields() {
        guard let rememberUsername = UserDefaults.standard.object(forKey: "usernameKey") as? String,
            let rememberPassword = UserDefaults.standard.object(forKey: "passwordKey") as? String else { return }
        
        usernameTextField.text = rememberUsername
        passwordTextField.text = rememberPassword
    }
}

// MARK: - Extensions
extension OnboardViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}

extension UIView {
    func fadeIn(
        _ duration: TimeInterval = 1.0,
        delay: TimeInterval = 0.0,
        completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(
        _ duration: TimeInterval = 1.0,
        delay: TimeInterval = 0.0,
        completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}

extension OnboardViewController {
    func initializeHideKeyboard() {
        //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        
        //Add this tap gesture recognizer to the parent view
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard() {
        //endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShowOrHide(notification: NSNotification) {
        // Get required info out of the notification
        if let scrollView = loginScrollView,
            let userInfo = notification.userInfo,
            let endValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey],
            let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey],
            let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] {
            
            // Transform the keyboard's frame into our view's coordinate system
            let endRect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
            
            // Find out how much the keyboard overlaps our scroll view
            let keyboardOverlap = scrollView.frame.maxY - endRect.origin.y
            
            // Set the scroll view's content inset & scroll indicator to avoid the keyboard
            scrollView.contentInset.bottom = keyboardOverlap
            scrollView.verticalScrollIndicatorInsets.bottom = keyboardOverlap
            
            let duration = (durationValue as AnyObject).doubleValue
            let options = UIView.AnimationOptions(rawValue: UInt((curveValue as AnyObject).integerValue << 16))
            UIView.animate(withDuration: duration!, delay: 0, options: options, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}
