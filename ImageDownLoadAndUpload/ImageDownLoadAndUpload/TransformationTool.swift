//
//  TransformationTool.swift
//  ImageDownLoadAndUpload
//
//  Created by SUN YU on 4/6/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import Foundation
import Alamofire

class TransformationTool
{
    
    private var _downloadProgress:Double?
    private var  _downloadImage:UIImage?
    
    var downloadProgress:Double
    {
        get{
        
            if _downloadProgress == nil
            {
                _downloadProgress = 0.0
            }
        
            return _downloadProgress!
        }
    }
    
    var downloadImage:UIImage
    {
        
        get
        {
            
            if _downloadImage == nil
            {
                //return a default picture
                _downloadImage = UIImage(named:"userDefaultImage")
                
            }
            
            return _downloadImage!
        }
    }
    
    
    
    
    
    func dowloadImageFromSever(complication:@escaping ()->())
    {
        
        Alamofire.request("http://blogs.reading.ac.uk/climate-lab-book/files/2016/02/callendar_fig1.png").downloadProgress{
                progress in
            
                self ._downloadProgress = progress.fractionCompleted
            
                print("Download Progress: \(progress.fractionCompleted)")
            
            }
            .responseData
            {
                response in
                
                switch response.result
                {
                    case .success:
                        if let data = response.result.value
                        {
                            
                            self._downloadImage = UIImage(data: data)
                        }
                    case .failure(let error):
                        print(error)
                    
                }
                
                complication()
                
            }
    }
    
}
