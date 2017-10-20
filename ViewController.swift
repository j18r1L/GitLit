//
//  ViewController.swift
//  LoadImageFromUrl


import UIKit

class ViewController: UIViewController {

    
    @IBOutlet var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        get_image("http://www.kaleidosblog.com/tutorial/image.jpg", image)

    }



 

 
    func get_image(_ url_str:String, _ imageView:UIImageView)
    {
        
        let url:URL = URL(string: url_str)!
        let session = URLSession.shared
        
        let task = session.dataTask(with: url, completionHandler: {
            (
            data, response, error) in
            

            if data != nil
            {
                let image = UIImage(data: data!)

                if(image != nil)
                {
                
                    DispatchQueue.main.async(execute: {
                    
                        imageView.image = image
                        imageView.alpha = 0
                        
                        UIView.animate(withDuration: 2.5, animations: {
                            imageView.alpha = 1.0
                        })
                        
                    })
                
                }
            
            }
            
            
        })
        
        task.resume()
    }


}

