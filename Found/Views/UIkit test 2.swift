//
//  UIkit test.swift
//  Found
//
//  Created by Ryan Ye on 12/2/24.
//
import UIKit
class ViewLostQueries: UIViewController {
    private var postCollectionView: UICollectionView
    
    private var posts:[Post]
    var success:Bool
    
    init(success: Bool, posts:[Post], nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.posts = posts
        self.success = success
        let postCollectionViewLayout = UICollectionViewFlowLayout()
        postCollectionViewLayout.scrollDirection = .vertical
        postCollectionViewLayout.minimumLineSpacing = 16
        postCollectionViewLayout.minimumInteritemSpacing = 16
        self.postCollectionView = UICollectionView(frame: .zero, collectionViewLayout: postCollectionViewLayout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(success: Bool, posts: [Post]){
        self.posts = posts
        self.success = success
        
        //MARK: write something to display if theres nothign to display
        if posts.isEmpty{
            var label = UILabel()
            view.backgroundColor = .systemBackground
            label.text = "no content!"
            label.textColor = .black
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }else{
            view.backgroundColor = .systemBackground
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.hidesBackButton = true
            title = "Current Found Items"
            postCollectionView.reloadData()
            //MARK: update whatever you need to in here after view is loaded, basically treat like an init?
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
//        if(success){
//            successView()
//        }
//        else{
//            unsuccessView()
//
//        }
    }
    
    func successView(){
        //view controller goes here
        
    }
    
//    func unsuccessView() {
//        view.backgroundColor = .systemRed
//
//        let label = UILabel()
//        label.text = "Unsuccessful, try again"
//        label.textColor = .white
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(label)
//
//        NSLayoutConstraint.activate([
//            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
    
    private func setupCollectionView() {
        postCollectionView.register(FoundPostViewCell.self, forCellWithReuseIdentifier: FoundPostViewCell.reuse)
        postCollectionView.dataSource = self
        postCollectionView.delegate = self
        postCollectionView.alwaysBounceVertical = true
        
        view.addSubview(postCollectionView)
        postCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            postCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            postCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            postCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            postCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
extension ViewLostQueries:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == postCollectionView{
            guard indexPath.row < posts.count else {
                        print("Index out of range: \(indexPath.row), posts count: \(posts.count)")
                        return
                    }
                    let selectedPost = posts[indexPath.row]
            
            let detailedPostVC = DetailedPostViewController(post: selectedPost, delegate: self)
            navigationController?.pushViewController(detailedPostVC, animated: true)
                    // Push detailed view controller or perform other actions
                }
//            let detailedPostVC = DetailedPostViewController(post: selectedPost, delegate: self)
//            navigationController?.pushViewController(detailedPostVC, animated: true)
    }
}
extension ViewLostQueries:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell =
                    collectionView.dequeueReusableCell(withReuseIdentifier: FoundPostViewCell.reuse, for: indexPath) as? FoundPostViewCell else {
                return UICollectionViewCell()
            }
            let bookmarked = UserDefaults.standard.array(forKey: "bookmarkedPosts") as? [Int] ?? []
            cell.configure(post: posts[indexPath.row], bookmarked: bookmarked.contains(posts[indexPath.row].id))
            return cell
        }
}
extension ViewLostQueries:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/2 - 16
        return CGSize(width: width, height: 216)
        
    }
}
//MARK: delegate
extension ViewLostQueries:UpdateBookmarkDelegate{
    func updateBookmarks() {
        self.postCollectionView.reloadData()
    }
}
protocol UpdateBookmarkDelegate:AnyObject{
    func updateBookmarks()
}
