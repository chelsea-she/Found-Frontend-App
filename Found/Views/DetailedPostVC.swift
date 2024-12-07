//
//  DetailedPostVC.swift
//  Found
//
//  Created by Ryan Ye on 12/6/24.
//

import UIKit
//
class DetailedPostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    //MARK: properties
    private let post: Post
    private weak var updateBookmarkDelegate: UpdateBookmarkDelegate?
    
    //MARK: views
    private var itemNameLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var postDateLabel = UILabel()
    private var locationFoundLabel = UILabel()
    private var dropLocationLabel = UILabel()
    private var userIdLabel = UILabel()
    private let itemImageView = UIImageView()
    
    private var itemImages: [String] = []
    private var imageViews: [UIImageView] = []
    private var backButton = UIBarButtonItem()
    private var bookmarkButton = UIBarButtonItem()
    
    //MARK: viewDidLoad and init
    
    init(post: Post, delegate: UpdateBookmarkDelegate){
        self.post = post
        self.updateBookmarkDelegate = delegate
        
        self.itemImages = post.image.components(separatedBy: ", ").filter { !$0.isEmpty }
        
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        
        backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backVC)
        )
        backButton.tintColor = UIColor.detailColors.black
        
        bookmarkButton = UIBarButtonItem(
            image: UIImage(systemName: "bookmark"),
            style: .plain,
            target: self,
            action: #selector(bookmarkButtonTapped)
        )
        bookmarkButton.tintColor = UIColor.detailColors.black
        
        let bookmarked = UserDefaults.standard.array(forKey: "bookmarkedPosts") as? [Int] ?? []
        if bookmarked.contains(post.id){
            bookmarkButton.image = UIImage(systemName: "bookmark.fill")
        } else{
            bookmarkButton.image = UIImage(systemName: "bookmark")
        }
        
        self.navigationItem.rightBarButtonItem = bookmarkButton
        self.navigationItem.leftBarButtonItem = backButton
        setupImageView()
        setupItemNameLabel()
        setupDescriptionLabel()
    }
    
    //MARK: setup views
    
    private var imageCollectionView: UICollectionView!
    private func setupImageView() {
        // Initialize layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width - 64, height: view.frame.width - 64)
        layout.minimumLineSpacing = 16
        // Initialize collection view
        imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        imageCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        imageCollectionView.isPagingEnabled = true
        imageCollectionView.showsHorizontalScrollIndicator = false
        imageCollectionView.backgroundColor = .clear
        // Add collection view to the view hierarchy
        view.addSubview(imageCollectionView)
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        // Set constraints
        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            imageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            imageCollectionView.heightAnchor.constraint(equalToConstant: view.frame.width - 64)
        ])
    }
    
    private func setupItemNameLabel() {
        itemNameLabel.text = post.itemName
        itemNameLabel.textColor = UIColor.detailColors.black
        itemNameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        itemNameLabel.numberOfLines = 0
        
        view.addSubview(itemNameLabel)
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            itemNameLabel.leftAnchor.constraint(equalTo:view.leftAnchor, constant:32),
            itemNameLabel.rightAnchor.constraint(equalTo:view.rightAnchor, constant:-32),
            itemNameLabel.topAnchor.constraint(equalTo:imageCollectionView.bottomAnchor, constant:16),
            
            
        ])
        
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.text = post.description
        descriptionLabel.textColor = UIColor.detailColors.silver
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        descriptionLabel.numberOfLines = 0
        
        view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionLabel.leftAnchor.constraint(equalTo:view.leftAnchor, constant:32),
            descriptionLabel.rightAnchor.constraint(equalTo:view.rightAnchor, constant:-32),
            descriptionLabel.topAnchor.constraint(equalTo:itemNameLabel.bottomAnchor, constant:16),
            
            
        ])
    }
    
    private func setupDateLabel(){
        postDateLabel.textColor = UIColor.foundColors.silver
        postDateLabel.font = .systemFont(ofSize: 11, weight: .medium)
        
        view.addSubview(postDateLabel)
        postDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            postDateLabel.topAnchor.constraint(equalTo:descriptionLabel.bottomAnchor, constant: 4),
            postDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postDateLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
    }
    
    //MARK: Pop
    @objc private func backVC(){
        navigationController?.popViewController(animated: true)
        updateBookmarkDelegate?.updateBookmarks()
    }
    
    @objc private func bookmarkButtonTapped(){
        var bookmarked = UserDefaults.standard.array(forKey: "bookmarkedPosts") as? [Int] ?? []
        if bookmarked.contains(post.id){
            bookmarked.removeAll{ name in
                name == post.id
            }
        } else{
            bookmarked.append(post.id)
        }
        if bookmarked.contains(post.id){
            bookmarkButton.image = UIImage(systemName: "bookmark.fill")
        } else{
            bookmarkButton.image = UIImage(systemName: "bookmark")
        }
        
        UserDefaults.standard.setValue(bookmarked, forKey: "bookmarkedRecipes")
    }
}
extension UIColor {
    // YOU MAY EDIT THIS FILE IF YOU ARE ATTEMPTING EXTRA CREDIT
    static let detailColors = DetailColors()
    struct DetailColors {
        let black = UIColor.black
        let offWhite = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        let silver = UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 1)
        let white = UIColor.white
        let yellowOrange = UIColor(red: 255/255, green: 170/255, blue: 51/255, alpha: 1)
    }
}
class ImageCell: UICollectionViewCell {
    static let reuseIdentifier = "ImageCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with url: URL) {
        imageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
    }
}
extension DetailedPostViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }
        if let url = URL(string: itemImages[indexPath.row]) {
            cell.configure(with: url)
        }
        return cell
    }
}
