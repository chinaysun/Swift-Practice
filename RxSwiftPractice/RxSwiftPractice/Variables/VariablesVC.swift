//
//  VariablesVC.swift
//  RxSwiftPractice
//
//  Created by Yu Sun on 22/11/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class VariablesVC: UIViewController {

    private lazy var imageView: UIImageView = {
       
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let imageDownloader: ImageClient = ImageClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 300),
                imageView.heightAnchor.constraint(equalToConstant: 300)
            ])
        
        variablesLearning()
        downloadImage(fromUrl: "http://i.cdn.turner.com/nba/nba/.element/img/1.0/teamsites/logos/teamlogos_500x500/bos.png")
    }
    
    private func variablesLearning() {
        
        // Variable wraps a Subject - specifically it is a behaviorSubject
        let variable = Variable(0)
        
        print("Before first subscription -- ")
        
        _ = variable.asObservable()
            .subscribe(onNext: { n in
                print("First \(n)")
            }, onCompleted: {
                print("Completed 1")
            })
        
        print("Before send 1")
        
        variable.value = 1
        
        print("Before second subscription ---")
        
        _ = variable.asObservable()
            .subscribe(onNext: { n in
                print("Second \(n)")
            }, onCompleted: {
                print("Completed 2")
            })
        
        print("Before send 2")
        
        variable.value = 2
        
        print("End ---")
        
    }
    
    private func downloadImage(fromUrl url: String) {
        
        _ = imageDownloader.downloadImageWithUrlString(urlString: url)
                .asObservable()
                .bind(to: imageView.rx.image)
        
    }

}
