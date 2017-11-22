//
//  ImageClient.swift
//  RxSwiftPractice
//
//  Created by Yu Sun on 22/11/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
import Foundation

protocol ImageCaching {
    func saveImageToCache(image: UIImage?, urlString: String)
    func imageFromCacheWithUrlString(urlString: String) -> UIImage?
}

class ImageCache: ImageCaching {

    var cacheDictionary = Dictionary<String, UIImage>()
    
    func saveImageToCache(image: UIImage?, urlString: String) {
        if let image = image {
            cacheDictionary[urlString] = image
        }
    }
    
    func imageFromCacheWithUrlString(urlString: String) -> UIImage? {
        return cacheDictionary[urlString]
    }

}

class ImageClient {
    
    private let cache: ImageCache = ImageCache()
    
    // Driver is an Observable that always returns on the main thread
    func downloadImageWithUrlString(urlString: String) -> Driver<UIImage?> {
        
        return Observable.create({ [unowned self] observer -> Disposable in

            if let image = self.cache.imageFromCacheWithUrlString(urlString: urlString) {
                observer.onNext(image)
                observer.onCompleted()
            }else {

                let request = URLRequest(url: URL(string: urlString)!)

                let task = URLSession.shared.dataTask(with: request) { data, response, error in

                    if let error = error {
                        observer.onError(error)
                    }
                    
                    if let data = data {
                        
                        if let image = UIImage(data: data) {
                            self.cache.saveImageToCache(image: image, urlString: urlString)
                            observer.onNext(image)
                            observer.onCompleted()
                        }else
                        {
                            observer.onError(error!)
                        }
                    }else {
                        observer.onError(error!)
                    }
                    
                }

                task.resume()
                
                return Disposables.create { task.cancel() }
            }

            return Disposables.create()
        })
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .asDriver(onErrorJustReturn: nil)
        
    }
    
}


