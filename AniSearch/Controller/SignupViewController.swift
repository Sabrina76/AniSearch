//
//  SignupViewController.swift
//  AniSearch
//
//  Created by Sabrina Chen on 4/2/22.
//

import UIKit
import Parse

protocol AccountCreationDelegate: AnyObject {
    func new(_ username: String, _ password: String)
}

class SignupViewController: UIViewController {

    @IBOutlet weak var signupUsername: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var signupPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var contentView: UIView!
    
    weak var delegate: AccountCreationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColor()
        // Do any additional setup after loading the view.
    }
    func setColor() {
        let color = UIColor(red: CGFloat(UserDefaults.standard.float(forKey: "Background_R")), green:CGFloat(UserDefaults.standard.float(forKey:"Background_G")), blue:CGFloat(UserDefaults.standard.float(forKey: "Background_B")), alpha: 1)
        self.view.backgroundColor = color
        signupUsername.backgroundColor = color
        email.backgroundColor = color
        signupPassword.backgroundColor = color
        confirmPassword.backgroundColor = color
        self.view.backgroundColor = color
        contentView.backgroundColor = color
    }
    
    @IBAction func signUp(_ sender: Any) {
        if signupPassword.text == confirmPassword.text{
            let user = PFUser()
            user.username = signupUsername.text
            user.password = signupPassword.text
            user.email = email.text
            user.signUpInBackground { (success, error) in
                if success{
                    self.delegate?.new(self.signupUsername.text ?? "", self.signupPassword.text ?? "")
                    self.dismiss(animated: true, completion: nil)
                }
                else{
                    print("Error: \(error?.localizedDescription as Optional)")
                }
            }
        }
        else {
            print("Error: password does not match")
        }
    }
    
    @IBAction func signInButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
