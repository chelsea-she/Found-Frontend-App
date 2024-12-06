//
//  UIkit test.swift
//  Found
//
//  Created by Ryan Ye on 12/2/24.
//

import UIKit

class FoundPushSuccessPage: UIViewController {
    private var post:Post
    private var success:Bool
    
    init(success: Bool, post:Post){
        self.post = post
        self.success = success
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(success){
            view.backgroundColor = .systemBackground
            let label = UILabel()
            label.text = post.itemName
            label.textColor = .black
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
        else{
            view.backgroundColor = .systemRed
            let label = UILabel()
            label.text = "Unsuccessful, try again"
            label.textColor = .white
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    }
}
