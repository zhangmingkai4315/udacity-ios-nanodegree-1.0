//
//  ViewController.swift
//  Meme
//
//  Created by mingkai on 2019/7/7.
//  Copyright © 2019年 mingkai. All rights reserved.
//
import Foundation
import UIKit

class ViewController: UIViewController,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyBoardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyBoardNotifications()
    }
    
    let inputTextFieldDelegate = InputTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        topTextField = setupTextField(topTextField,text: "Top", delegate:inputTextFieldDelegate)
        bottomTextField = setupTextField(bottomTextField,text: "Bottom",delegate: inputTextFieldDelegate)
        
    }
    
    func setupTextField(_ textfield: UITextField,text: String,delegate: UITextFieldDelegate) -> UITextField{
        
        textfield.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 100)
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth:  -3,
        ]
        textfield.text = text
        textfield.delegate = delegate
        textfield.defaultTextAttributes = memeTextAttributes
        textfield.layer.zPosition = .greatestFiniteMagnitude
        return textfield
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBAction func pickImage(_ sender: UIBarButtonItem) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    // Dissmiss image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    @IBAction func imagePickFromCamera(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func openActivityDialog(_ sender: UIBarButtonItem) {
        
        let image = generatedMemedImage()
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
        
        
        
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        imagePickerView.image = UIImage()
        
    }
    
    
    
    func save(memedImage: UIImage){
//        let meme = Meme(
//            topString: topTextField.text,
//            bottomString: bottomTextField.text,
//            originalImage: imagePickerView.image,
//            memedImage: memedImage
//            )
//        print("save it \(meme.bottomString)")
    }
    @IBOutlet weak var toolbar: UIToolbar!
    func generatedMemedImage() -> UIImage{
        
        var image = UIImage()
        
        navbar.isHidden = true
        toolbar.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navbar.isHidden = false
        toolbar.isHidden = false
        
        
        return image
    }
    
    
    // 处理键盘出现时候遮挡住view的内容
    func getkeyboardHeight(_ notification: Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        if bottomTextField.isFirstResponder{
            view.frame.origin.y = -getkeyboardHeight(notification)
        }
    }
    @objc func keyboardWillHide(_ notification: Notification){
        view.frame.origin.y = 0
    }
    func subscribeToKeyBoardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyBoardNotifications(){
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

