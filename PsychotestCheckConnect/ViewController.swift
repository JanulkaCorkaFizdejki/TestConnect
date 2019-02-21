//
//  ViewController.swift
//  PsychotestCheckConnect
//
//  Created by Robert Nowiński on 21/02/2019.
//  Copyright © 2019 Robert Nowiński. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func ButtonRun(_ sender: Any) {
        Connect(urlAdress: "http://psychotests.pl/iPhone/?data=testjson")
    }
    
  
    @IBOutlet weak var textLab: UITextView!
    
    func Connect (urlAdress: String) -> Void {
        var requestURL = URLRequest (url: URL (string: urlAdress)!)
        requestURL.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: requestURL){
            data, response, error in guard let data = data, error == nil else {
                print ("Error\(String(describing: error))")
                return
            }
            
             if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: AnyObject]]
                    if json != nil {
                        
                        var array = Array<String>()
                        var iterator: Int = 1
                        for question in json! {
                            let quest = question["question"] as? String
                            if quest != nil {
                                    array.append(String (iterator) + ". " + String (quest!) + "\n\n");
                                iterator += 1
                            }
                        }
                        DispatchQueue.main.async {
                            self.textLab.text = ""
                            array.forEach{
                                items in
                                var txlb: String = self.textLab.text
                                self.textLab.text = txlb + items
                            }
                        }
                        
                    } else {return }
                } catch {
                    print ("error")
                }
             } else {
                print ("connect error")
            }
        }
        task.resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

