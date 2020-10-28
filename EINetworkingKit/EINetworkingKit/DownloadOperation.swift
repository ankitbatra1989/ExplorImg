//
//  DownloadOperation.swift
//  ExplorImg
//
//  Created by Ankit Batra on 26/10/20.
//

import Foundation
import UIKit

public class DownloadOperation: AsynchronousOperation {
    
    var task: URLSessionTask!
    
    public init(url: URL) {
        super.init()
        
        let sessionConfiguration = URLSessionConfiguration.default
        let session: URLSession = URLSession(configuration: sessionConfiguration)
        task = session.downloadTask(with: url) { temporaryURL, response, error in
            defer {
                self.completeOperation()
            }
            guard error == nil && temporaryURL != nil else {
                print("Error downloading image")
                return
            }
            
            do {
                //Saving the image to documents directory
                let manager = FileManager.default
                let documents = try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let destinationURL = documents.appendingPathComponent(url.lastPathComponent)
                if manager.fileExists(atPath: destinationURL.path) {
                    try manager.removeItem(at: destinationURL)
                }
                try manager.moveItem(at: temporaryURL!, to: destinationURL)
                
            } catch let moveError {
                print(moveError)
            }
        }
    }
    
    public override func cancel() {
        task.cancel()
        super.cancel()
    }
    
    public override func main() {
        task.resume()
    }
    
}
