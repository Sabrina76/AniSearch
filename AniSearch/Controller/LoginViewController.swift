//
//  LoginViewController.swift
//  AniSearch
//
//  Created by Sabrina Chen on 4/2/22.
//

import UIKit
import Parse

class LoginViewController: UIViewController, AccountCreationDelegate {

    @IBOutlet weak var loginUsername: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    @IBOutlet weak var welcomeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setColor()
    }
    
    func setColor(){
        let color = UIColor(red: CGFloat(UserDefaults.standard.float(forKey: "Background_R")), green:CGFloat(UserDefaults.standard.float(forKey:"Background_G")), blue:CGFloat(UserDefaults.standard.float(forKey: "Background_B")), alpha: 1)
        self.view.backgroundColor = color
        loginUsername.backgroundColor = color
        loginPassword.backgroundColor = color
    }
    
    @IBAction func signIn(_ sender: Any) {
        let username = loginUsername.text!
        let password = loginPassword.text!
        PFUser.logInWithUsername(inBackground: username, password: password)
            {(user, error) in
                if user != nil{
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
                else{
                    print("Error \(error?.localizedDescription as Optional)")
                }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController, let signUp = nav.topViewController as? SignupViewController {
            signUp.delegate = self
        }
    }
    
    func new(_ username: String, _ password:String) {
        PFUser.logInWithUsername(inBackground: username, password: password)
            {(user, error) in
                if user != nil{
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
                else{
                    print("Error \(error?.localizedDescription as Optional)")
                }
        }
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toSignup", sender: self)
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
