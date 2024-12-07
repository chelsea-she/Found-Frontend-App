//
//  FoundPostViewCell.swift
//  Found
//
//  Created by Ryan Ye on 12/6/24.
//

import UIKit
import SDWebImage
class FoundPostViewCell: UICollectionViewCell {
    
    //MARK: - Properties (view)
    private var itemNameLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var postDateLabel = UILabel()
    private var locationFoundLabel = UILabel()
    private var dropLocationLabel = UILabel()
    private var userIdLabel = UILabel()
    private let itemImageView = UIImageView()
    
    private var itemImages: [String] = []
    private var imageViews: [UIImageView] = []
    private var post: Post?
    static let reuse: String = "FoundPostViewCell"
    
    
    private let bookmarkLabel = UIImageView()
    
    //MARK: - init
    override init(frame: CGRect){
        super.init(frame: frame)
        
        setupImage()
        setupItemLabel()
        setupBookmarkLabel()
        setupDateLabel()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
        
    }
    //MARK: configure
    
    func configure(post: Post, bookmarked: Bool){
        self.post = post
        
//        let urlList = post.image.components(separatedBy: ", ").filter { !$0.isEmpty }
//        for urlString in urlList {
//                guard let url = URL(string: urlString) else {
//                    print("Invalid URL: \(urlString)")
//                    continue
//                }
//
//                let imageView = UIImageView()
//                imageView.contentMode = .scaleAspectFit
//
//                imageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
//                imageViews.append(imageView)
//        }
//        if let firstImageView = imageViews.first, let firstImage = firstImageView.image {
//            itemImageView.image = firstImage
//        } else {
//            print("No images available in imageViews.")
//        }
        let urlList = post.image.components(separatedBy: ", ").filter { !$0.isEmpty }
            if let firstURLString = urlList.first, let firstURL = URL(string: firstURLString) {
                itemImageView.sd_setImage(with: firstURL, placeholderImage: UIImage(systemName: "photo"))
            }
        
        itemNameLabel.text = post.itemName
        descriptionLabel.text = post.description
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        postDateLabel.text = dateFormatter.string(from: post.timestamp)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/dd"
//        postDateLabel.text = dateFormatter.string(from: post.timestamp)
        
        locationFoundLabel.text = post.locationFound
        dropLocationLabel.text = post.dropLocation
        userIdLabel.text = String(1)
        
        if bookmarked{
            bookmarkLabel.image = UIImage(systemName: "bookmark.fill")
            //print(recipe.name, "bookmarked")
        } else{
            bookmarkLabel.image = UIImage()
            //print(recipe.name, "not bookmarked")
        }
    }
        
    //MARK: setup
    private func setupImage() {
        contentView.addSubview(itemImageView)
        contentView.addSubview(itemNameLabel) // Add itemNameLabel to the hierarchy before setting constraints
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemImageView.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: 8), // Use contentView as reference
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            itemImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            itemImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
        
//        itemImageView.contentMode = .scaleAspectFill
//        itemImageView.layer.cornerRadius = 12
//        itemImageView.layer.masksToBounds = true
//
//        contentView.addSubview(itemImageView)
//        itemImageView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            itemImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
//            itemImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor)
//        ])
        
        
        
        
//        var previousImageView: UIImageView? = nil
//
//        for imageView in imageViews {
//            imageView.contentMode = .scaleAspectFill
//            imageView.layer.cornerRadius = 12
//            imageView.layer.masksToBounds = true
//
//            contentView.addSubview(imageView)
//            imageView.translatesAutoresizingMaskIntoConstraints = false
//
//            NSLayoutConstraint.activate([
//                imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//                imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//                imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor)
//            ])
//
//            if let previous = previousImageView {
//                imageView.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 8).isActive = true
//            } else {
//                imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//            }
//
//            previousImageView = imageView
//        }
//
//        // Adjust the contentView's bottom constraint to the last imageView
//        if let lastImageView = previousImageView {
//            lastImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//        }
//    }
    
//    private func setupBookmarkLabel(){
//
//        bookmarkLabel.tintColor = UIColor.foundColors.yellowOrange
//        bookmarkLabel.contentMode = .scaleAspectFit
//        bookmarkLabel.layer.masksToBounds = true
//
//        contentView.addSubview(bookmarkLabel)
//        bookmarkLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            bookmarkLabel.topAnchor.constraint(equalTo:itemImageView.bottomAnchor, constant: 8),
//            bookmarkLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            bookmarkLabel.widthAnchor.constraint(equalToConstant: 20),
//            bookmarkLabel.heightAnchor.constraint(equalToConstant: 20)
//        ])
//    }
    
    private func setupBookmarkLabel() {
        contentView.addSubview(bookmarkLabel)
        bookmarkLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookmarkLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 8), // Ensure itemImageView is added
            bookmarkLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            bookmarkLabel.widthAnchor.constraint(equalToConstant: 24),
            bookmarkLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    @objc private func bookmarkTapped() {
        print("Bookmark tapped!")
        // Implement bookmark toggle logic
    }
    
//    private func setupItemLabel(){
//        itemNameLabel.textColor = UIColor.foundColors.black
//        itemNameLabel.font = .systemFont(ofSize: 14, weight: .bold)
//        itemNameLabel.numberOfLines = 2
//
//        contentView.addSubview(itemNameLabel)
//        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            itemNameLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 8),
//            itemNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            itemNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20)
//        ])
//    }
    
    private func setupItemLabel() {
        contentView.addSubview(itemNameLabel)
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8), // Anchor to contentView
            itemNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            itemNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    private func setupDateLabel(){
        postDateLabel.textColor = UIColor.foundColors.silver
        postDateLabel.font = .systemFont(ofSize: 11, weight: .medium)
        
        contentView.addSubview(postDateLabel)
        postDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            postDateLabel.topAnchor.constraint(equalTo:itemImageView.bottomAnchor, constant: 4),
            postDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postDateLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
        
    }
    
    
}
extension UIColor {
    // YOU MAY EDIT THIS FILE IF YOU ARE ATTEMPTING EXTRA CREDIT
    static let foundColors = FoundColors()
    struct FoundColors {
        let black = UIColor.black
        let offWhite = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        let silver = UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 1)
        let white = UIColor.white
        let yellowOrange = UIColor(red: 255/255, green: 170/255, blue: 51/255, alpha: 1)
    }
}
