//
//  LoginViewController.swift
//  SystemTask
//
//  Created by Kanchireddy sreelatha on 08/07/24.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var errorLabel:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func LoginTap(_ sender: Any) {
        //MARK: - login api will get banner token
        guard let email = emailTxt.text, let password = passwordTxt.text else {
                    errorLabel.text = "Please enter email and password. like this email as: apptesting@gmail.com password as : apple@123"
                    return
                }
                
                let validation = validateCredentials(email: email, password: password)
                
                if validation.isValid {
                    errorLabel.text = nil
                    errorLabel.isHidden = true
                    // Proceed with login
                    // performLogin(email: email, password: password)
                    let params = ["email" : emailTxt.text ?? "",
                                  "password" : passwordTxt.text ?? ""]
                    ApiManager.instance.netWorkCall(baseUrl: ApiManager.url.login, parameters: params, methodType: .post,page:nil) { data, response, err in
                        
                        let httpResponse = response as! HTTPURLResponse
                        // if httpResponse.statusCode == 200 {
                        
                        do {
                            let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: [])
                            let authtoken = ((json as! NSDictionary).object(forKey: "data") as! NSDictionary).object(forKey: "access_token") as! String
                            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                            UserDefaults.standard.set(authtoken, forKey: "authToken")
                            
                            self.present(authtoken: authtoken)
                        } catch {
                            print(error)
                        }
                    }
                } else {
                    errorLabel.isHidden = false
                    errorLabel.text = validation.errorMessage
                }
        
    }
    func isValidEmail(_ email: String) -> Bool {
            let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}$"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
            return emailPredicate.evaluate(with: email)
        }


        func validateCredentials(email: String, password: String) -> (isValid: Bool, errorMessage: String?) {
            if !isValidEmail(email) {
                return (false, "Invalid email address.")
            }
            

            
            return (true, nil)
        }
    func present(authtoken:String) {
        if let entryPopUp = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            entryPopUp.token = authtoken
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(entryPopUp, animated: true)
               // self.present(entryPopUp, animated: true, completion: nil)
            }
            
        }
        
    }
    

}
