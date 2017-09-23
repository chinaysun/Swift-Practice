//
//  ViewController.swift
//  AddEventToCalender
//
//  Created by SUN YU on 23/9/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(tapMeButton)
        
        //constraints
        tapMeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tapMeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tapMeButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        tapMeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
        
        
    }
    
    
    lazy var tapMeButton:UILabel = {
       
        var button = UILabel()
        button.text = "Click Me To Add Event"
        button.textColor = UIColor.blue
        button.font = button.font.withSize(17)
        button.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addToCalender)))
        
        return button
        
    }()
    
    
    
    func addToCalender()
    {

        let eventStore:EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: EKEntityType.event, completion:{ (granted,error) in
        
        if granted && error == nil
        {
            
            let event:EKEvent = EKEvent(eventStore: eventStore)
            event.startDate = Date()
            event.endDate = Date()
            event.title = "Movie Event"
            event.notes = "Please let me see the movie"
            event.calendar = eventStore.defaultCalendarForNewEvents
            
            do
            {
            
              try  eventStore.save(event, span:.thisEvent )
            
            }catch let error
            {
              print("Error is:\(error) ")
            }
            
        }
        
        
        
        
        })
    }

}

