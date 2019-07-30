//
//  ViewController.swift
//  FlickFinder
//
//  Created by mingkai on 2019/7/28.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var keyBoardOnScreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phraseTextField.delegate = self
        latitudeTextField.delegate = self
        longitudeTextField.delegate = self
        
        subscribeToNotification(UIResponder.keyboardWillShowNotification, selector: #selector(keyboardWillShow))
        subscribeToNotification(UIResponder.keyboardWillHideNotification, selector: #selector(keyboardWillHide))
        
        subscribeToNotification(UIResponder.keyboardDidHideNotification, selector: #selector(keyboardDidHide))
        subscribeToNotification(UIResponder.keyboardDidShowNotification, selector: #selector(keyboardDidShow))
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotification()
    }
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTitleLabel: UILabel!
    
    @IBOutlet weak var phraseTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    
    @IBOutlet weak var phraseSearchButton: UIButton!
    @IBOutlet weak var latlonSearchButton: UIButton!
    
    
    func setUIEnabled(_ enabled: Bool){
        photoTitleLabel.isEnabled = enabled
        phraseTextField.isEnabled = enabled
        latitudeTextField.isEnabled = enabled
        longitudeTextField.isEnabled = enabled
        phraseSearchButton.isEnabled = enabled
        latlonSearchButton.isEnabled = enabled
        if enabled {
            phraseSearchButton.alpha = 1.0
            latlonSearchButton.alpha = 1.0
        }else{
            phraseSearchButton.alpha = 0.5
            latlonSearchButton.alpha = 0.5
        }
        
    }
    
    
    @IBAction func searchByPhrase(_ sender: UIButton) {
        userDidTapView(self)
        setUIEnabled(false)
        
        if !phraseTextField.text!.isEmpty{
            photoTitleLabel.text = "searching..."
            let methodParameters: [String: String?]=[
                Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod,
                Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
                Constants.FlickrParameterKeys.Text: phraseTextField.text!,
                Constants.FlickrParameterKeys.SafeSearch: Constants.FlickrParameterValues.UseSafeSearch,
                Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
                Constants.FlickrParameterKeys.Extras:
                    Constants.FlickrParameterValues.MediumURL,
                Constants.FlickrParameterKeys.NoJSONCallback:
                    Constants.FlickrParameterValues.DisableJSONCallback
            ]
            
            displayImageFromFlickrBySearch(methodParameters as [String : AnyObject],withRandomNumber: nil)
        }else {
            setUIEnabled(true)
            photoTitleLabel.text = "search phrase empty!"
        }
    }
    
    private func bboxString() ->String{
        if let lat = Double(latitudeTextField.text!),let lng = Double(longitudeTextField.text!){
            let minimumLong = max((lng - Constants.Flickr.SearchBBoxHalfWidth), Constants.Flickr.SearchLonRange.0)
            let minimumLat = max((lat - Constants.Flickr.SearchBBoxHalfHeight), Constants.Flickr.SearchLatRange.0)
            let maximumLong = min((lng + Constants.Flickr.SearchBBoxHalfWidth), Constants.Flickr.SearchLonRange.1)
            let maximumLat = min((lat + Constants.Flickr.SearchBBoxHalfHeight), Constants.Flickr.SearchLatRange.1)
            return "\(minimumLong),\(minimumLat),\(maximumLong),\(maximumLat)"
        }else{
            return "0,0,0,0"
        }
    }
    
    @IBAction func searchByLatlon(_ sender: UIButton) {
        userDidTapView(self)
        setUIEnabled(false)
        if isTextFieldValid(latitudeTextField, forRange: Constants.Flickr.SearchLatRange) && isTextFieldValid(longitudeTextField, forRange: Constants.Flickr.SearchLonRange){
            photoTitleLabel.text = "Searching..."
            let methodParameters: [String: String?]=[
                Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod,
                Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
                Constants.FlickrParameterKeys.SafeSearch: Constants.FlickrParameterValues.UseSafeSearch,
                Constants.FlickrParameterKeys.BoundingBox: bboxString(),
                Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
                Constants.FlickrParameterKeys.Extras:
                    Constants.FlickrParameterValues.MediumURL,
                Constants.FlickrParameterKeys.NoJSONCallback:
                    Constants.FlickrParameterValues.DisableJSONCallback
            ]
            displayImageFromFlickrBySearch(methodParameters as [String : AnyObject],withRandomNumber: nil)
        }else{
            setUIEnabled(true)
            photoTitleLabel.text = "lat should be [-90,90] lon should be [-180,180]"
        }
        
    }
    
    private func decodeJSON(data: Data,methods:[String:AnyObject], withRandomNumber: Int?){
        let parseResult : [String:AnyObject]!
        do {
            parseResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
        }catch{
            displayError("could not parse the data")
            return
        }
        
        guard let stat = parseResult[Constants.FlickrResponseKeys.Status] as? String, stat == Constants.FlickrResponseValues.OKStatus else{
            displayError("Flickr API return an error \(parseResult)")
            return
        }

        guard let photosDictionary = parseResult[Constants.FlickrResponseKeys.Photos] as? [String: AnyObject] else {
            displayError("can't find key \(Constants.FlickrResponseKeys.Photos) in \(String(describing: parseResult))")
            return
        }
        /* GUARD: Is "pages" key in the photosDictionary? */

        guard let photosArray = photosDictionary[Constants.FlickrResponseKeys.Photo] as? [[String: AnyObject]] else {
            displayError("Cannot find key '\(Constants.FlickrResponseKeys.Photo)' in \(photosDictionary)")
            return
        }
        if photosArray.count == 0 {
            displayError("No Photos Found. Search Again.")
            return
        }
        
        if withRandomNumber == nil{
            guard let totalPages = photosDictionary[Constants.FlickrResponseKeys.Pages] as? Int else {
                displayError("Cannot find page number in \(photosDictionary)")
                return
            }
            let pageLimit = min(totalPages, 40)
            let randomPage = Int(arc4random_uniform(UInt32(pageLimit))) + 1
            displayImageFromFlickrBySearch(methods, withRandomNumber: randomPage)
            return
        }
        
        
        let randomPhotoIndex = Int(arc4random_uniform(UInt32(photosArray.count)))
        let photoDictionary = photosArray[randomPhotoIndex] as [String: AnyObject]
        let photoTitle = photoDictionary[Constants.FlickrResponseKeys.Title] as? String
        /* GUARD: Does our photo have a key for 'url_m'? */
        guard let imageUrlString = photoDictionary[Constants.FlickrResponseKeys.MediumURL] as? String else {
            displayError("Cannot find key '\(Constants.FlickrResponseKeys.MediumURL)' in \(photoDictionary)")
            return
        }
        let imageURL = URL(string: imageUrlString)
        if let imageData = try? Data(contentsOf: imageURL!) {
            performUIUpdatesOnMain {
                self.setUIEnabled(true)
                self.photoImageView.image = UIImage(data: imageData)
                self.photoTitleLabel.text = photoTitle ?? "(Untitled)"
            }
        } else {
            displayError("Image does not exist at \(String(describing: imageURL))")
        }
        
    }
    private func performUIUpdatesOnMain(_ updates: @escaping () -> Void){
        DispatchQueue.main.async {
            updates()
        }
    }
    
    private func displayError(_ error: String){
        print(error)
        performUIUpdatesOnMain {
            self.setUIEnabled(true)
            self.photoTitleLabel.text = "No photo returned. Try again."
            self.photoImageView.image = nil
        }
    }
    
    private func displayImageFromFlickrBySearch(_ methodParameters:[String:AnyObject], withRandomNumber: Int?){
        let session = URLSession.shared
        let request = URLRequest(url: flickrURLFromParameters(methodParameters,pageNumber: withRandomNumber))
        print(flickrURLFromParameters(methodParameters,pageNumber: withRandomNumber))
        let task = session.dataTask(with: request){(data, response, error) in
            
            guard (error == nil) else{
                self.displayError("there was an error with your request:\(String(describing: error))")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                self.displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                self.displayError("No data was returned by the request!")
                return
            }
            self.decodeJSON(data: data, methods: methodParameters, withRandomNumber: withRandomNumber)
        }
        task.resume()
    }
    
    private func flickrURLFromParameters(_ parameters: [String: AnyObject], pageNumber: Int?) -> URL {
        var components = URLComponents()
        components.scheme = Constants.Flickr.APIScheme
        components.host = Constants.Flickr.APIHost
        components.path = Constants.Flickr.APIPath
        
        components.queryItems = [URLQueryItem]()
        
        for (k,v) in parameters{
            let q = URLQueryItem(name: k, value: "\(v)")
            components.queryItems!.append(q)
        }
        if pageNumber != nil{
            let q = URLQueryItem(name: Constants.FlickrParameterKeys.Page, value: "\(String(describing: pageNumber))")
            components.queryItems!.append(q)
        }
        return components.url!
    }
}

extension ViewController: UITextFieldDelegate{
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        if !keyBoardOnScreen{
            view.frame.origin.y -= keyboardHeight(notification)
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        if keyBoardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)
        }
    }
    
    @objc func keyboardDidShow(_ notification: Notification){
        keyBoardOnScreen = true
    }
    @objc func keyboardDidHide(_ notification: Notification){
        keyBoardOnScreen = false
    }
    
    func keyboardHeight(_ notification: Notification) -> CGFloat{
        let userInfo = (notification as NSNotification).userInfo
        let keyBoardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyBoardSize.cgRectValue.height
    }
    func resignIfFirstResponse(_ textField: UITextField){
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(_ sender: AnyObject){
        resignIfFirstResponse(phraseTextField)
        resignIfFirstResponse(latitudeTextField)
        resignIfFirstResponse(longitudeTextField)
    }
    
    func isTextFieldValid(_ textField: UITextField, forRange: (Double, Double)) ->Bool{
        if let value = Double(textField.text!), !textField.text!.isEmpty{
            return isValueInRange(value, min: forRange.0, max: forRange.1)
        }
        return false
    }
    
    func isValueInRange(_ value: Double, min: Double, max: Double)->Bool{
        return !(value<min||value>max)
    }
    
}

private extension ViewController{
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector){
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotification(){
        NotificationCenter.default.removeObserver(self)
    }
}
