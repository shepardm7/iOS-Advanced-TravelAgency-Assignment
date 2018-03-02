//
//  ViewController.swift
//  TravelAgency
//
//  Created by Sateek Roy on 2017-07-11.
//  Copyright © 2017 SateekLambton. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate  {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var bornText: UITextField!
    @IBOutlet weak var fromCountryText: UITextField!
    
    @IBOutlet weak var toCountryText: UITextField!
    
    @IBOutlet weak var betterPlaceText: UITextField!
    @IBOutlet weak var fromMap: MKMapView!
    
    @IBOutlet weak var toMap: MKMapView!
    
    @IBOutlet weak var betterPlacePhoto: UIImageView!
    
    @IBOutlet weak var betterPlaceDescription: UITextView!
    
    var mapManager = CLLocationManager()
    
    var country : [Country] = []
    var annotations : [MKPointAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Setup
        fromCountryText.delegate = self
        toCountryText.delegate = self
        mapManager.delegate = self                            // ViewController is the "owner" of the map.
        mapManager.desiredAccuracy = kCLLocationAccuracyBest  // Define the best location possible to be used in app.
        mapManager.requestWhenInUseAuthorization()            // The feature will not run in background
        mapManager.startUpdatingLocation()                    // Continuously geo-position update
        fromMap.delegate = self
        toMap.delegate = self
        
        
        self.betterPlaceDescription.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor;
        self.betterPlaceDescription.layer.borderWidth = 1.0;
        self.betterPlaceDescription.layer.cornerRadius = 8;
        
        
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (textField === fromCountryText) {
            findCountry(mapObj: fromMap, countryName: fromCountryText)
        }
        else if (textField === toCountryText) {
            findCountry(mapObj: toMap, countryName: toCountryText)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField === fromCountryText) {
            findCountry(mapObj: fromMap, countryName: fromCountryText)
        }
        else if (textField === toCountryText) {
            findCountry(mapObj: toMap, countryName: toCountryText)
        }
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        nameText.resignFirstResponder()
        bornText.resignFirstResponder()
        fromCountryText.resignFirstResponder()
        toCountryText.resignFirstResponder()
        betterPlaceText.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            betterPlacePhoto.image = selectedImage
            dismiss(animated: true, completion: nil)
        }
        else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
    }
    
    func loadData(){
        let ca  = Country(name: "Canada", latitude: 45.419124, longitude: -75.704084)
        let usa = Country(name: "USA", latitude: 38.897992, longitude: -77.035511)
        let mex = Country(name: "Mexico", latitude: 19.431713, longitude: -99.129942)
        let prt = Country(name: "Portugal", latitude: 38.729101, longitude: -9.137683)
        let sp  = Country(name: "Spain", latitude: 40.416545, longitude: -3.703608)
        
        country.append(ca)
        country.append(usa)
        country.append(mex)
        country.append(prt)
        country.append(sp)
    }
    
    func findCountry(mapObj: MKMapView, countryName: UITextField) {
        
        mapObj.removeAnnotations(annotations)
        if let c1 = retrieveData(countryName: countryName.text!) {
            let userAnnotation = MKPointAnnotation()
            userAnnotation.coordinate = CLLocationCoordinate2DMake(c1.getLatitude(), c1.getLongitude())
            mapObj.addAnnotation(userAnnotation)
            annotations.append(userAnnotation)
            
            
            // Here we define the map's zoom. The value 0.01 is a pattern
            let zoom:MKCoordinateSpan = MKCoordinateSpanMake(100, 100)
            
            // Store latitude and longitude received from smartphone
            let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(c1.getLatitude(), c1.getLongitude())
            
            // Based on myLocation and zoom define the region to be shown on the screen
            let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, zoom)
            
            // Setting the map itself based previous set-up
            mapObj.setRegion(region, animated: true)
            

        }
        
    }
    
    func retrieveData(countryName : String) -> Country? {
        for c in country {
            if c.getCountryName() == countryName {
                return c
            }
        }
        return nil
    }



}

