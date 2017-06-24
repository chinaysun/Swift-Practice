//
//  MyViewController.swift
//  TableViewPractice
//
//  Created by SUN YU on 22/6/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,MKMapViewDelegate {
    
    @IBOutlet weak var myLocationTextLabel: UILabel!

    struct animalList {
        var animalType:String!
        var animalList:[Animal]!
    }
    
    var myAnimalData:[animalList] = [animalList]()
    
    var myCLManager = CLLocationManager()

    @IBOutlet weak var myMapView: MKMapView!
    {
        didSet
        {
            self.myMapView.mapType = .standard
        }
    }
    
    @IBOutlet weak var myTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //get current location
        self.createCLManager()
        
        // Do any additional setup after loading the view.
        self.loadData()
        
    
        // add annotations into map
        for animalType in self.myAnimalData
        {
            //add annotations
            myMapView.addAnnotations(animalType.animalList)
            
            //start to monitor the points
            for animal in animalType.animalList
            {
                self.startMonitoring(animal: animal)
            }
            
        }
        
        
        
    }
    
    /* MARK: - CL Functions
     */
    
    private func createCLManager()
    {
        //initial the delegate
        self.myCLManager.delegate = self
        
        let authorizedCode = CLLocationManager.authorizationStatus()
        
        if authorizedCode == CLAuthorizationStatus.notDetermined
        {
            
            myCLManager.requestWhenInUseAuthorization()
            
        }else
        {
            self.getLocation()
        }
        
    }
    
    private func getLocation()
    {
        myCLManager.desiredAccuracy = kCLLocationAccuracyBest
        myCLManager.distanceFilter = 10
        
        myCLManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        
        //display location in map
        self.displayLocationInMap(location: location)
        
        //change the distance
        self.calculateDistanceFromCurrentPosition(location:location)
        
        //get my current address
        self.getCurrentAddress(location: location)
        
    }
    
    func getCurrentAddress(location:CLLocation)
    {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {
        
            (placemarks,error)->Void in
            
            if let placemark:CLPlacemark = placemarks?[0]
            {
                self.myLocationTextLabel.text = placemark.name
            }
        
        
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        switch  status
        {
        case .notDetermined:
            myCLManager.requestWhenInUseAuthorization()
        case .authorizedAlways,.authorizedWhenInUse:
            getLocation()
        case .denied,.restricted:
            //create alert that guides users to setting
            self.createAlertForSetting()
            
        }
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Some error Occur block the location service")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Fail to monitor region")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("The user entry the")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("The user exist the area")
    }
    
    func region(animalArea animal:Animal)->CLCircularRegion
    {
        let region = CLCircularRegion(center: animal.coordinate, radius: 50.0, identifier: animal.name!)
        
        //only notify when user entry
        region.notifyOnEntry = true
        region.notifyOnExit = false
        
        return region
    }
    
    
    func startMonitoring(animal:Animal)
    {
        
        
        //check weather supports
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self)
        {
            print("Your device does not support this function")
        }
        
        print("start Monitoring")
        
        let region = self.region(animalArea: animal)
        
        self.myCLManager.startMonitoring(for: region)
        
    }
    
    func stopMonitoring(animal:Animal)
    {
        for region in self.myCLManager.monitoredRegions
        {
            guard let circularRegion = region as? CLCircularRegion , circularRegion.identifier == animal.name!
            else
            {
                continue
            }
            
            self.myCLManager.stopMonitoring(for: region)
        }
    }
    
    func createAlertForSetting()
    {
        let alert = UIAlertController(title: "Notification", message: "Please allow us to use your location", preferredStyle: UIAlertControllerStyle.alert)
        let goSettingButton = UIAlertAction(title: "Go Setting", style: UIAlertActionStyle.default, handler: {
            action in
            
            guard let settingUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingUrl)
            {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingUrl, completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
        })
        
        alert.addAction(goSettingButton)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(cancelButton)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    /* MARK: - MAP Functions
     */
    
    func displayLocationInMap(location:CLLocation)
    {
        //set map based on span & user current location
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.005, 0.005)
        let userCurrentLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let displayRegion = MKCoordinateRegionMake(userCurrentLocation, span)
        
        myMapView.setRegion(displayRegion, animated: true)
        
        myMapView.showsUserLocation = true
        myMapView.showsCompass = true
    }
    
    
    //This function is invoked every time the user zooms in/out
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        var overlays:[MKOverlay]?
        
        //add circle for each point
        //let radius = max(10.0,1000.0*mapView.region.span.latitudeDelta,1000.0*mapView.region.span.latitudeDelta)
        let radius = 50.0
        
        
        overlays = mapView.overlays
        
        if overlays?.count == 0
        {
        
            for animalType in self.myAnimalData
            {
                for animal in animalType.animalList
                {
                    self.createRadar(center: animal.coordinate, radius: radius)
                }
            }
            
            return
        }
        
        mapView.removeOverlays(overlays!)
        
        for overlay in overlays!
        {
            self.createRadar(center: overlay.coordinate, radius: radius)
            
        }
        
        
        
    }
    
    
    func createRadar(center:CLLocationCoordinate2D,radius:CLLocationDistance)
    {
        let circle = MKCircle(center: center, radius: radius)
        
        self.myMapView.add(circle)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let circleRenderer = MKCircleRenderer.init(overlay: overlay)
        circleRenderer.fillColor = UIColor.purple
        circleRenderer.alpha = 0.5
        
        return circleRenderer
    }
    
    
    /* MARK: - General Functions
     */
    
    
    //Manally write data
    func loadData()
    {
        var animalName:[String] = ["Dog","Cat","Kangoroo","Panda","Snake"]
        var animalLocation:[(Double,Double)] =
        [
            (-37.801286501963055,144.9533395401977),
            (-37.80272762821298,144.95527073068843),
            (-37.816967834392095,144.88952442331538),
            (-37.82347672821129,144.91166874094233),
            (-37.80015053557233,144.90360065622554)
        ]
        var animalDescription:[String] =
        [
            "This is a dog",
            "This is a cat",
            "This is a Kangoroo",
            "This is a Panda",
            "This is a Snake"
        ]
        var levelOfFierce:[Double] =
        [
            0.0,
            1,
            3,
            3.5,
            5
        ]
        
        var typeOfAnimal:[String] = ["Pet","Pet","Wild Animal","Wild Animal","Wild Animal"]
        
        
        var petList:[Animal] = [Animal]()
        var wildAnimalList:[Animal] = [Animal]()
        
        for index in 0...4
        {
            let animal:Animal = Animal()
            
            animal.name = animalName[index]
            animal.latitude = animalLocation[index].0
            animal.longitude = animalLocation[index].1
            animal.animalDescription = animalDescription[index]
            animal.levelOfFirece = levelOfFierce[index]
            animal.typeOfAnimal = typeOfAnimal[index]
            
            if animal.typeOfAnimal == "Pet"
            {
                petList.append(animal)
                
            }else
            {
                wildAnimalList.append(animal)
            }
            
        }
        
        let petAnimalList:animalList = animalList(animalType: "Pet", animalList: petList)
        self.myAnimalData.append(petAnimalList)
        
        let wildAnimalData:animalList = animalList(animalType: "Wild Animal", animalList: wildAnimalList)
        self.myAnimalData.append(wildAnimalData)
        
        
        
    }
    
    func calculateDistanceFromCurrentPosition(location:CLLocation)
    {
        for animalList in self.myAnimalData
        {
            for animal in animalList.animalList
            {
                animal.calculateDistance(userLocation: location)
            }
            
        }
        
        //sort the list
        for index in 0...(self.myAnimalData.count - 1)
        {
            self.myAnimalData[index].animalList.sort(by: {$0.0.distanceFromUserLocation < $0.1.distanceFromUserLocation})
        }
    
        //change section position
        self.myAnimalData.sort(by: {$0.0.animalList[0].distanceFromUserLocation < $0.1.animalList[0].distanceFromUserLocation})
        
        
        myTableView.reloadData()
        

    }
    


    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.myAnimalData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.myAnimalData[section].animalList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "animals", for: indexPath)
        
        let animal:Animal = self.myAnimalData[indexPath.section].animalList[indexPath.row]
        
        // Configure the cell...
        if let animalCell = cell as? MyTableViewCell
        {
            animalCell.animal = animal
        
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.myAnimalData[section].animalType
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        passedAnimal = self.myAnimalData[indexPath.section].animalList[indexPath.row]
        performSegue(withIdentifier: "showAnimalDetail", sender: self)
    }
    
    var passedAnimal:Animal?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showAnimalDetail"
        {
            let destinationView:AnimalDetail = segue.destination as! AnimalDetail
            
            destinationView.passedAnimal = self.passedAnimal!

           
        }
    }

}


