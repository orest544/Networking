//
//  ViewController.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 12/25/18.
//  Copyright © 2018 Orest Patlyka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var refresherView: UIActivityIndicatorView = {
        let refresherView = UIActivityIndicatorView()
        refresherView.style = .whiteLarge
        refresherView.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 0.2)
        
        refresherView.translatesAutoresizingMaskIntoConstraints = false
        
        return refresherView
    }()
    
    // MARK: - Services
    let currencyService = CurrencyService()
    let aireFrescoTestService = AireFrescoTestService()
    let afWithQueriesService = AFWithQueriesService()
    let googlePlacesService = GoogleAutocompleteService()
    let traxAuthService = LoginService()
    let traxSettingsService = SettingsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRefresherView()
    }
    
    private func setUpRefresherView() {
        view.addSubview(refresherView)
        
        view.leadingAnchor.constraint(equalTo: refresherView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: refresherView.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: refresherView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: refresherView.bottomAnchor).isActive = true
        
    }
    
    private func showActivityIndication() {
        refresherView.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refresherView.stopAnimating()
        }
    }

}

// TEST APIs
extension ViewController {
    
    @IBAction func getCurrencies(_ sender: UIButton) {
        showActivityIndication()
        currencyService.getCurrencies()
            .onSuccess { (currencies) in
                currencies.forEach { print($0) }
            }.onFailure { (error) in
                print(error)
            }
    }
    
    @IBAction func signInAF(_ sender: UIButton) {
        showActivityIndication()
        
        // Request with body and saving token
        let credentials = SignInBody(email: "test@test.com",
                                     password: "Test1234")
        
        aireFrescoTestService.signIn(with: credentials)
            .onSuccess { user in
                print(user)
                let result = KeychainManager.saveTokenToKeychain(id: String(user.id),
                                                                 token: user.meta.token)
                // handle result, mb log out
                print("Saving token to keychain: ", result)
                
                UserDefaults.standard.set(user.id, forKey: "userID")
            }.onFailure { error in
                print(error)
            }
    }
    
    @IBAction func signUpAF(_ sender: UIButton) {
        showActivityIndication()
        
        let signUpBody = SignUpBody(email: "oresttest3@gmail.com",
                                    firstName: "Orest",
                                    lastName: "Patlyka",
                                    password: "Test1234")
        
        aireFrescoTestService.sighUp(with: signUpBody)
            .onSuccess { (user) in
                print(user)
            }.onFailure { error in
                print(error)
            }
    }
    
    @IBAction func getPaymentPlans(_ sender: UIButton) {
        showActivityIndication()
        
        //TEST QUERIES
        let queries = GetPaymentPlansQuery(countryCode: "VEN",
                                           coupon: "fnPyrogI")
        
        afWithQueriesService.getPaymentPlans(queries: queries)
            .onSuccess { (paymentPlans) in
                print(paymentPlans)
            }.onFailure { (error) in
                print(error.localizedDescription)
            }
    }

    @IBAction func changePassword(_ sender: UIButton) {
        showActivityIndication()
        
        //TEST QUERIES
        let changePasswordBody = ChangePasswordBody(newPassword: "Test1234",
                                                    newPasswordConfirmation: "Test1234",
                                                    currentPassword: "Test1234")
        
        aireFrescoTestService.changePassword(with: changePasswordBody)
            .onSuccess { _ in
                print("Success!!")
            }.onFailure { (error) in
                print(error)
            }
    }
    
    @IBAction func getGoogleAutocomplete(_ sender: UIButton) {
        showActivityIndication()
        
        let getAutocompleteQueries = GoogleAutocompleteQueries(input: "Ukraine")
        
        googlePlacesService.getGoogleAutocomplete(with: getAutocompleteQueries)
            .onSuccess { (autocompleteResult) in
                print(autocompleteResult)
            }.onFailure { (error) in
                print(error.description)
            }
    }
    
    @IBAction func logInTrax(_ sender: UIButton) {
        showActivityIndication()
        
        let userCredentials = LoginCredentialsModel(email: "admin@trax.io",
                                                    password: "secret")
        
        traxAuthService.logIn(with: userCredentials)
            .onSuccess { (user) in
                // save token in keychain
                let token = user.data.tokenType + " " + user.data.accessToken
                KeychainManager.saveTokenToKeychain(id: userCredentials.email,
                                                    token: token)
                
                UserDefaults.standard.set(userCredentials.email, forKey: "userID")
                print(user)
            }.onFailure { (error) in
                print(error)
            }
    }
    
    @IBAction func getProfileTrax(_ sender: UIButton) {
        showActivityIndication()
        
        traxSettingsService.getProfile()
            .onSuccess { (profile) in
                print(profile.data)
            }.onFailure { (error) in
                print(error)
            }
    }
    
}
