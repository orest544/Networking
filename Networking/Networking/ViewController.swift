//
//  ViewController.swift
//  Currency convertor
//
//  Created by Orest Patlyka on 12/25/18.
//  Copyright © 2018 Orest Patlyka. All rights reserved.
//

import UIKit
import AVKit

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
    let nervyVideoService = NervyVideoService()
    
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
    
//    func createBody(parameters: [String: String],
//                    boundary: String,
//                    data: Data,
//                    mimeType: String,
//                    filename: String) -> Data {
//        let body = NSMutableData()
//
//        let boundaryPrefix = "--\(boundary)\r\n"
//
//        for (key, value) in parameters {
//            body.appendString(boundaryPrefix)
//            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//            body.appendString("\(value)\r\n")
//        }
//
//        body.appendString(boundaryPrefix)
//        body.appendString("Content-Disposition: form-data; name=\"video\"; filename=\"\(filename)\"\r\n")
//        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
//        body.append(data)
//        body.appendString("\r\n")
//        body.appendString("--".appending(boundary.appending("--")))
//
//
//
//        return body as Data
//    }
//
    @IBAction func uploadPhoto(_ sender: UIButton) {
        showActivityIndication()

        let videoURL = Bundle.main.url(forResource: "NervyVideo", withExtension: "mp4")!
        
        nervyVideoService.uploadNervyVideo(videoURL: videoURL) { value in
            DispatchQueue.main.async {
                self.testProgressView.progress = value
            }
        }.onSuccess { _ in
            print("success")
        }.onFailure { error in
            print(error.description)
        }
//
//        var urlRequest = URLRequest(url: URL(string: "http://ec2-35-156-108-213.eu-central-1.compute.amazonaws.com/api/v1/videos")!)
//        urlRequest.httpMethod = "POST"
//
//        URLSession.shared.uploadTask(with: urlRequest, fromFile: videoURL) { (data, response, error) in
//            print(data,response,error)
//            let json = try! JSONSerialization.jsonObject(with: data!, options: [])
//            print(json)
//        }.resume()
////
//        let videoData = try! Data(contentsOf: videoURL)
//
//        var urlRequest = URLRequest(url: URL(string: "http://ec2-35-156-108-213.eu-central-1.compute.amazonaws.com/api/v1/videos")!)
//        urlRequest.httpMethod = "POST"
//
//        let boundary = "Boundary-\(UUID().uuidString)"
//        let videoData2 = createBody(parameters: [:],
//                                    boundary: boundary,
//                                    data: videoData,
//                                    mimeType: "video/mp4",
//                                    filename: "NervyVideo.mp4")
//        urlRequest.httpBody = videoData2
//        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
//        urlRequest.setValue("Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjM1NTQ2NzA4ZDdlYWNmMWNhNDBkYWE1OWU3MGUzNmMwZjExYzk3Nzk2NDg5ODNlOGFjYTcyOTE0NTQwMGQyOGM2NTg1OWQ1NTBhMmE5NDc2In0.eyJhdWQiOiI0IiwiZXhwIjoxNTU5NTU3MTE1LCJqdGkiOiIzNTU0NjcwOGQ3ZWFjZjFjYTQwZGFhNTllNzBlMzZjMGYxMWM5Nzc5NjQ4OTgzZThhY2E3MjkxNDU0MDBkMjhjNjU4NTlkNTUwYTJhOTQ3NiIsImlhdCI6MTU1OTQ3MDcxNSwibmJmIjoxNTU5NDcwNzE1LCJzdWIiOiI3Iiwic2NvcGVzIjpbXX0.10RJJuoVagoAhyxoIrOcA-MxNU7uuq4bK8PPBrdJJ1O42Rrc20Cj8fNKRvv6nhR51BO1rbegOR0Qb65U2zJQrUi1vqPFINk1WZZn9sa8P6anAgG8BaltKodu2cF_FSMldR7TcoDRGHb-KwLTPD41838K09ijZnP8Ucd0TBO4fH4D0YEirwgPEJUFd8gzXAkZ0neIereXEX5I8dB7g618ha-6Bjx31kC44I4u_SuRTzdU-2iGAF0_RVlnMNSOIG03Flu5LNbqzw_pPo2B1jU_aMSEeWsKMM9EVToKNTP_s_IY07mdRQ9MQsiBTtXYefZYXXU5e5g6dXo0bYej5S3kh3f0a-J5zdnelH168YduFK_M1yMhH-nFsE4BgegCyudBz6SZBmKyjHEFTND6OgM1T_qY6oX1sK_zHwM5dOFgywXOCBAL47N8Jz2uuT4Q-4Qx6Ww8GJCvK526wiHmf8eghBGPJp86L0ey0sOP8LPdQeXadA8a3xqrp1qi3-hvkiwJSF6gbrz7B06L1rrwCzZ1y_HucG8qQqBwNQfdugwER3OR6yAY39B2lCUXJqdY6Y5j_0c8nv4fmZ2evlCCgIgEqysUZT_zTaN14tqLT00rUZ8GHf6xmIG4qHGUCoKWxnU3o2FToNUI-H3vDXXaxw6crYu6fISkqgV87mpGyueBKgA", forHTTPHeaderField: "Authorization")
////
//        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//            print(data,response,error)
//            let json = try! JSONSerialization.jsonObject(with: data!, options: [])
//            print(json)
//        }.resume()
        
//        URLSession.shared.uploadTask(with: urlRequest, from: urlRequest.httpBody) { (data, response, error) in
//            print(data,response,error)
//            let json = try! JSONSerialization.jsonObject(with: data!, options: [])
//            print(json)
//        }.resume()
//
        //
//
//        let upload = Upload(parsedType: EmptyResult.self)
//        upload.performUploadTask(with: urlRequest, progress: { (progress) in
//            DispatchQueue.main.async {
//                self.testProgressView.progress = progress
//            }
//        }, logsEnable: true)
//            .onSuccess { _ in
//                print("Success")
//            }.onFailure { error in
//                print("Failure")
//            }

        

//        let photo = imageView.image!
//
//        let videoDataString = String(data: videoData2.base64EncodedData(), encoding: .utf8)
//        nervyVideoService.uploadNervyVideo(NervyVideoBody(video: videoData2))
//        downloadService.uploadPhoto(uploadingProgress: { [weak self] (progress) in
//            }, photo: body)
//            .onSuccess { _ in
//                print("success uploading")
//            }.onFailure { error in
//                print(error.description)
//            }

//        let multipartData = MultipartFormData()
//        multipartData.append(photo.jpegData(compressionQuality: 0.8)!,
//                             withName: "avatar",
//                             fileName: "profile_photo",
//                             mimeType: "image/jpeg")
//
//        let body = UpdateAvatarBody(avatar: imageData)

        
        
        
//        Alamofire.upload(multipartFormData: { (multipartData) in
//            let videoData = try! Data(contentsOf: videoURL)
//            multipartData.append(videoData, withName: "image", fileName: "NervyVideo", mimeType: "mp4")
//        }, to: "http://ec2-35-156-108-213.eu-central-1.compute.amazonaws.com/api/v1/account/avatar",
//           method: .post,
//           headers: nil) { result in
//            switch result {
//            case .success(request: let request, streamingFromDisk: _, streamFileURL: _):
//                request.responseJSON(completionHandler: { (response) in
//                    response.result.withValue({ JSON in
//                        print(JSON)
//                    }).withError({ error in
//                        print(error)
//                    })
//                })
//            case .failure(_):
//                print("failure")
//            }
//        }
        
        
//        downloadService.uploadPhoto(body: body) { (progress) in
//            DispatchQueue.main.async {
//                self.testProgressView.progress = progress
//            }
//        }
//
    }
    
}

extension URLRequest {
    
    /**
     Configures the URL request for `multipart/form-data`. The request's `httpBody` is set, and a value is set for the HTTP header field `Content-Type`.
     
     - Parameter parameters: The form data to set.
     - Parameter encoding: The encoding to use for the keys and values.
     
     - Throws: `MultipartFormDataEncodingError` if any keys or values in `parameters` are not entirely in `encoding`.
     
     - Note: The default `httpMethod` is `GET`, and `GET` requests do not typically have a response body. Remember to set the `httpMethod` to e.g. `POST` before sending the request.
     - Seealso: https://html.spec.whatwg.org/multipage/form-control-infrastructure.html#multipart-form-data
     */
    public mutating func setMultipartFormData(_ parameters: [String: String], encoding: String.Encoding) throws {
        
        let makeRandom = { UInt32.random(in: (.min)...(.max)) }
        let boundary = String(format: "------------------------%08X%08X", makeRandom(), makeRandom())
        
        let contentType: String = try {
            guard let charset = CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(encoding.rawValue)) else {
                throw MultipartFormDataEncodingError.characterSetName
            }
            return "multipart/form-data; charset=\(charset); boundary=\(boundary)"
            }()
        addValue(contentType, forHTTPHeaderField: "Content-Type")
        
        httpBody = try {
            var body = Data()
            
            for (rawName, rawValue) in parameters {
                if !body.isEmpty {
                    body.append("\r\n".data(using: .utf8)!)
                }
                
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                
                guard
                    rawName.canBeConverted(to: encoding),
                    let disposition = "Content-Disposition: form-data; name=\"\(rawName)\"\r\n".data(using: encoding) else {
                        throw MultipartFormDataEncodingError.name(rawName)
                }
                body.append(disposition)
                
                body.append("\r\n".data(using: .utf8)!)
                
                guard let value = rawValue.data(using: encoding) else {
                    throw MultipartFormDataEncodingError.value(rawValue, name: rawName)
                }
                
                body.append(value)
            }
            
            body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            
            return body
            }()
    }
}

public enum MultipartFormDataEncodingError: Error {
    case characterSetName
    case name(String)
    case value(String, name: String)
}
