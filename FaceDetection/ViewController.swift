//
//  ViewController.swift
//  FaceDetection
//
//  Created by MACBOOK PRO RETINA on 20/06/2019.
//  Copyright © 2019 MACBOOK PRO RETINA. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let image = UIImage(named: "suits") else { return }
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
         let scaledHeight = view.frame.width / image.size.width * image.size.height
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: scaledHeight)
        imageView.backgroundColor = .blue
        view.addSubview(imageView)
        
        let request =  VNDetectFaceRectanglesRequest { (req, error) in
            if let error = error {
                print("error detecting faces")
                return
            }
            print(req)
            req.results?.forEach({ (res) in
                guard let faceObservation = res as? VNFaceObservation else { return }
                let x = self.view.frame.width * faceObservation.boundingBox.origin.x
                let height = scaledHeight * faceObservation.boundingBox.height
                let y = scaledHeight * (1 - faceObservation.boundingBox.origin.y) - height
                let width = self.view.frame.width * faceObservation.boundingBox.width
                
                let redView = UIView()
                redView.alpha = 0.4
                redView.frame = CGRect(x: x, y: y, width: width, height: height)
                redView.backgroundColor = UIColor.red
                self.view.addSubview(redView)
                print(faceObservation.boundingBox)
            })
        }
        guard let cgImage = image.cgImage else { return }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([request])
        } catch let reqError {
            print("error performing request",reqError)
        }
        
    }


}

