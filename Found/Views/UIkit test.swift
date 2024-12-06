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
    private var isLoading: Bool
    private let label = UILabel()

    init(isLoading:Bool, success: Bool, post:Post){
        self.post = post
        self.success = success
        self.isLoading = isLoading
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(isLoading: Bool, success: Bool){
        self.success = success
        self.isLoading = isLoading
        if(success){
            view.backgroundColor = .systemBackground
            label.text = "Success!"
            label.textColor = .black

        }
        
        else{
            view.backgroundColor = .systemRed
            label.text = "Unsuccessful, try again"
            label.textColor = .white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        view.backgroundColor = .systemBackground
        label.text = "Loading"
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

    }
}
