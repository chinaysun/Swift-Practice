//
//  TransformationTool.swift
//  ImageDownLoadAndUpload
//
//  Created by SUN YU on 4/6/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

protocol DataSendDelegate
{
    func sendDowloadProgress(progress:Double)
}

class TransformationTool
{
    
    private var  _downloadImage:UIImage?
    
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
    
    var delegate: DataSendDelegate? = nil
    
    
    
    func dowloadImageFromSever(complication:@escaping ()->())
    {
        
        Alamofire.request("http://c3headlines.typepad.com/.a/6a010536b58035970c013486e5c5e6970c-pi").downloadProgress{
                progress in
            
            
            print("Download Progress: \(progress.fractionCompleted)")
            
                if self.delegate != nil
                {
                        self.delegate?.sendDowloadProgress(progress: progress.fractionCompleted)
                }
            
            
            
            
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
    
    func uploadImageToServer(uploadImage:UIImage,complication:@escaping ()->())
    {
        
        let data = UIImageJPEGRepresentation(uploadImage, 0.5)
        let url = try! URLRequest(url: URL(string:"http://127.0.0.1:8888/MelbourneCafe/upload.php")!, method: .post, headers: nil)
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(data!, withName: "fileToUpload", fileName: "myTestPicture.jpeg", mimeType: "image/jpeg")}, with: url,encodingCompletion: {
                encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    print("upload successfully")
//                    upload.responseJSON { response in
//                        if((response.result.value) != nil) {
//                            
//                        } else {
//                            
//                        }
//                    }
                case .failure( _):
                    break
                }
                
                complication()
        })
        
        
    
    }
    
}
