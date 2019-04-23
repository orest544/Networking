//
//  ViewController.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 12/25/18.
//  Copyright © 2018 Orest Patlyka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var testProgressView: UIProgressView!
    @IBOutlet weak var imageView: UIImageView!
    
    lazy var refresherView: UIActivityIndicatorView = {
        let refresherView = UIActivityIndicatorView()
        refresherView.style = .whiteLarge
        refresherView.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 0.2)
        
        refresherView.translatesAutoresizingMaskIntoConstraints = false
        
        return refresherView
    }()
    
    private var imagePickerController = UIImagePickerController()
    
    let currencyService = CurrencyService()
    let aireFrescoTestService = AireFrescoTestService()
    let afWithQueriesService = AFWithQueriesService()
    let googlePlacesService = GoogleAutocompleteService()
    let downloadService: TestDownloadServiceInterface = TestDownloadService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRefresherView()
        setUpImagePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let queries = GetPaymentPlansQuery(countryCode: "VEN",
//                                           coupon: "fnPyrogI")
//        afWithQueriesService.getPaymentPlans(queries: queries)
//            .onSuccess { (paymentPlans) in
//                print(paymentPlans)
//            }.onFailure { (error) in
//                print(error.localizedDescription)
//            }
//
//        afWithQueriesService.getPaymentPlans(queries: queries)
//            .onSuccess { (paymentPlans) in
//                print(paymentPlans)
//            }.onFailure { (error) in
//                print(error.localizedDescription)
//            }
//
//        let changePasswordBody = ChangePasswordBody(newPassword: "Test1234",
//                                                    newPasswordConfirmation: "Test1234",
//                                                    currentPassword: "Test1234")
//
//        aireFrescoTestService.changePassword(with: changePasswordBody)
//            .onSuccess { _ in
//                print("Success!!")
//            }.onFailure { (error) in
//                print(error)
//            }
//
//        aireFrescoTestService.changePassword(with: changePasswordBody)
//            .onSuccess { _ in
//                print("Success!!")
//            }.onFailure { (error) in
//                print(error)
//            }

    }
    
    private func setUpRefresherView() {
        view.addSubview(refresherView)
        
        view.leadingAnchor.constraint(equalTo: refresherView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: refresherView.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: refresherView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: refresherView.bottomAnchor).isActive = true
    }
    
    private func setUpImagePicker() {
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
    }
    
    private func showActivityIndication() {
        refresherView.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refresherView.stopAnimating()
        }
    }

    
    @IBAction func selectPhoto(_ sender: UIButton) {
        self.present(imagePickerController, animated: true)
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.dismiss(animated: true)
        }
        imageView.image = image
        
        picker.dismiss(animated: true, completion: nil)
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
        let credentials = SignInBody(email: "orest.patlyka@gmail.com",
                                     password: "Test1234")
        
        aireFrescoTestService.signIn(with: credentials)
            .onSuccess { user in
                print(user)
                let result = KeychainManager.saveTokenToKeychain(user.id,
                                                                 token: user.meta.token)
                // handle result, mb log out
                print("Saving token to keychain: \(result)")
                
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
                                           coupon: nil)
        
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

    @IBAction func download(_ sender: UIButton) {
        showActivityIndication()
        
        downloadService.downloadSession { [weak self] progress in
//                print("Download progress: \(progress)")
                DispatchQueue.main.async {
                    self?.testProgressView.progress = progress
                }
            }.onSuccess { [weak self] (fileURL) in
                print("Download succeeded, file URL: \(fileURL)")
            }.onFailure { (error) in
                print("Download failed: \(error.description)")
            }
    }
    
    @IBAction func resumeTasks(_ sender: UIButton) {
        
    }
    
    @IBAction func cancelTasks(_ sender: UIButton) {
        let queries = GetPaymentPlansQuery(countryCode: "VEN",
                                           coupon: "fnPyrogI")
        afWithQueriesService.getPaymentPlans(queries: queries)
            .onSuccess { (paymentPlans) in
                print(paymentPlans)
            }.onFailure { (error) in
                print(error.localizedDescription)
            }
        
        afWithQueriesService.getPaymentPlans(queries: queries)
            .onSuccess { (paymentPlans) in
                print(paymentPlans)
            }.onFailure { (error) in
                print(error.localizedDescription)
            }
        
        let changePasswordBody = ChangePasswordBody(newPassword: "Test1234",
                                                    newPasswordConfirmation: "Test1234",
                                                    currentPassword: "Test1234")
        
        aireFrescoTestService.changePassword(with: changePasswordBody)
            .onSuccess { _ in
                print("Success!!")
            }.onFailure { (error) in
                print(error)
            }
        
        aireFrescoTestService.changePassword(with: changePasswordBody)
            .onSuccess { _ in
                print("Success!!")
            }.onFailure { (error) in
                print(error)
        }
    }
    
    func createBody(parameters: [String: String],
                    boundary: String,
                    data: Data,
                    mimeType: String,
                    filename: String) -> Data {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
    
    @IBAction func uploadPhoto(_ sender: UIButton) {
        showActivityIndication()

        let boundary = "Boundary-\(UUID().uuidString)"

        let photo = imageView.image!
        let imageData = createBody(parameters: [:], boundary: boundary,
                              data: photo.jpegData(compressionQuality: 0.7)!,
                              mimeType: "image/jpeg",
                              filename: "profile_photo")
//
//        downloadService.uploadPhoto(uploadingProgress: { [weak self] (progress) in
//
//            }, photo: body)
//            .onSuccess { _ in
//                print("success uploading")
//            }.onFailure { error in
//                print(error.description)
//            }
        
        let body = UpdateAvatarBody(avatar: photo.jpegData(compressionQuality: 0.7)!)
        
        downloadService.uploadPhoto(body: body) { (progress) in
            DispatchQueue.main.async {
                self.testProgressView.progress = progress
            }
        }
    
    }
    
}



extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
