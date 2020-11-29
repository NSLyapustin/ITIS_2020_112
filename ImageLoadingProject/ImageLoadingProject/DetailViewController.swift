//
//  DetailViewController.swift
//  ImageLoadingProject
//
//  Created by Никита Ляпустин on 26.11.2020.
//

import UIKit

class DetailViewController: UIViewController, URLSessionDownloadDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var progressBar: UIProgressView!
    
    var imageUrl: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.progress = 0
        download(from: imageUrl)
    }
    
    func download(from url: URL) {
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        
        let downloadTask = session.downloadTask(with: url)
        downloadTask.resume()
    }
    
    func readDownloadedData(of url: URL) -> Data {
        do {
            let reader = try FileHandle(forReadingFrom: url)
            let data = reader.readDataToEndOfFile()
            
            return data
        } catch {
            fatalError("Cannot read data")
        }
    }
    
    func addImageSubviewByData(data: Data) {
        DispatchQueue.main.async {
            guard let image = UIImage(data: data) else {
                return
            }
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
        
            self.scrollView.addSubview(imageView)
            imageView.frame = CGRect(x: 20, y: 20, width: self.view.frame.width-40, height: self.view.frame.height - 40)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async {
            self.progressBar.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let data = readDownloadedData(of: location)
        addImageSubviewByData(data: data)
        
        DispatchQueue.main.async {
            self.progressBar.isHidden = true
        }
    }
}
