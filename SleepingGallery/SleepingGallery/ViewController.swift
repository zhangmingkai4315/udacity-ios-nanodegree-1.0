//
//  ViewController.swift
//  SleepingGallery
//
//  Created by mingkai on 2019/7/25.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBOutlet weak var photoTitleLabel: UILabel!
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var grabImageButton: UIButton!
    
    private func setUIEnabled(_ enabled: Bool) {
        photoTitleLabel.isEnabled = enabled
        grabImageButton.isEnabled = enabled
        
        if enabled {
            grabImageButton.alpha = 1.0
        } else {
            grabImageButton.alpha = 0.5
        }
    }
    
    @IBAction func grabNewImage(_ sender: AnyObject) {
        setUIEnabled(false)
        getImageFromFlickr()
    }
    
    private func getImageFromFlickr(){
        let methodParameters = [
            Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.GalleryPhotosMethod,
            Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.GalleryID: Constants.FlickrParameterValues.GalleryID,
            Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NOJSONCallBack: Constants.FlickrParameterValues.DisableJSONCallback
        ]
        let urlString = Constants.Flickr.API_BASE_URL + escapedParameters(parameters: methodParameters as [String:AnyObject])
        
        let session = URLSession.shared
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request){(data, response, error) in
            func displayError(_ error: String){
                print(error)
                DispatchQueue.main.async {
                    self.setUIEnabled(true)
                }
            }
            
            guard (error == nil) else{
                displayError("error in request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            // parse the data
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* GUARD: Did Flickr return an error (stat != ok)? */
            guard let stat = parsedResult[Constants.FlickrResponseKeys.Status] as? String, stat == Constants.FlickrResponseValues.OKStatus else {
                displayError("Flickr API returned an error. See error code and message in \(parsedResult)")
                return
            }
            
            /* GUARD: Are the "photos" and "photo" keys in our result? */
            guard let photosDictionary = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String:AnyObject], let photoArray = photosDictionary[Constants.FlickrResponseKeys.Photo] as? [[String:AnyObject]] else {
                displayError("Cannot find keys '\(Constants.FlickrResponseKeys.Photos)' and '\(Constants.FlickrResponseKeys.Photo)' in \(parsedResult)")
                return
            }
            
            let radomPhotoIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
            let photoDict = photoArray[radomPhotoIndex] as [String:AnyObject]
            let photoTitle = photoDict[Constants.FlickrResponseKeys.Title] as? String
            
            guard let imageUrlString = photoDict[Constants.FlickrResponseKeys.MediumURL] as? String else{
                displayError("Cannot find key '\(Constants.FlickrResponseKeys.MediumURL)' in \(photosDictionary)")
                return
            }
            
            let imageURL = URL(string: imageUrlString)
            if let imageData = try? Data(contentsOf: imageURL!){
                DispatchQueue.main.async {
                    self.setUIEnabled(true)
                    self.photoImageView.image = UIImage(data:imageData)
                    self.photoTitleLabel.text = photoTitle ?? "(untitle)"
                }
            }
        }
         // start the task!
        task.resume()
        
    }

    private func escapedParameters(parameters: [String:AnyObject] )->String{
        if parameters.isEmpty{
            return ""
        }
        var keyValuePairs = [String]()
        for (key, value ) in parameters{
            let strValue = "\(value)"
            let escapedValue = strValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            keyValuePairs.append(key+"="+"\(escapedValue!)")
        }
        return "?\(keyValuePairs.joined(separator: "&"))"
    }
}

