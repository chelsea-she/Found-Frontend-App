//
//  UIkit test.swift
//  Found
//
//  Created by Ryan Ye on 12/2/24.
//

import UIKit

class ViewLostQueries: UIViewController {
    private var posts:[Post]
    private var success:Bool
    
    init(success: Bool, posts:[Post]){
        self.posts = posts
        self.success = success
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(success){
            successView()
        }
        else{
            unsuccessView()

        }
    }
    
    func successView(){
        //view controller goes here
    }
    
    func unsuccessView(){
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
