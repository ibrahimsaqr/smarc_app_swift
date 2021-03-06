//
//  LoginVC.swift
//  SmarcHome
//
//  Created by Ibrahim Saqr on 4/2/18.
//  Copyright © 2018 Ibrahim Saqr. All rights reserved.
//

import UIKit;

class LoginVC: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad();
        spinner.isHidden = true;
        spinner.stopAnimating();
    }

    @IBAction func onBackBtnClicked(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: CoreConst.STORYBOARD_ID, bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: CoreConst.MAIN_PAGE_ID)
        self.present(newViewController, animated: true, completion: nil)
    }

    @IBAction func onForgetPasswordBtnClicked(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: AuthConst.STORYBOARD_ID, bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: AuthConst.FORGET_PASSWORD_PAGE)
        self.present(newViewController, animated: true, completion: nil)
    }

    @IBAction func onLoginBtnClicked(_ sender: Any) {
        self.spinner.startAnimating();
        self.spinner.isHidden = false;

        // get the email and password
        guard let email = emailInput.text , emailInput.text != "" else { return }
        guard let password = passwordInput.text , passwordInput.text != "" else { return }

        AuthService.instance.login(email: email, password: password) { (success) in
            self.spinner.isHidden = true;
            self.spinner.stopAnimating();

            if success {
                // connect to SocketIO
//                SocketIOService.instance.connect()

                // redirect to home page
                let storyBoard: UIStoryboard = UIStoryboard(name: CoreConst.STORYBOARD_ID, bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: CoreConst.HOME_PAGE_ID)
                self.present(newViewController, animated: true, completion: nil)
            } else {
                self.spinner.isHidden = true;
                self.spinner.stopAnimating();

                let alert = UIAlertController(title: AuthConst.ALERT_TITLE, message: AuthConst.ALERT_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)

                alert.addAction(UIAlertAction(title: AuthConst.ALERT_ACTION_RETRY, style: .default, handler: { action in
                    self.onLoginBtnClicked({})
                }))

                alert.addAction(UIAlertAction(title: AuthConst.ALERT_ACTION_EXIT, style: .destructive, handler: { action in
                    //to terminate app, do not use exit(0) because this is logged as a crash.
                    UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
                }))

                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
