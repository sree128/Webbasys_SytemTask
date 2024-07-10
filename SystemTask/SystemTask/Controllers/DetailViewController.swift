//
//  DetailViewController.swift
//  SystemTask
//
//  Created by Kanchireddy sreelatha on 08/07/24.
//

import UIKit

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    

    @IBOutlet weak var cv: UICollectionView!
    
    var token = ""
    var posts = [Post]()
    var isLoading = false
    var page = 1
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
               layout.scrollDirection = .vertical
               layout.minimumLineSpacing = 0
               layout.minimumInteritemSpacing = 0
               layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
               
               cv.collectionViewLayout = layout
       
        self.cv.delegate = self
        self.cv.dataSource = self
        cv.register(UINib(nibName: ProductCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        cv.isPagingEnabled = true
        getUserData(authtoken: token)
        // Do any additional setup after loading the view.
    }
    
    func getUserData(authtoken:String){
        //MARK: - get user data
        ApiManager.instance.netWorkCall(baseUrl: ApiManager.url.pets, parameters: nil, methodType: .get, token: authtoken,page:nil) { data, response, err in
            do {
                if let _data = data{
                    let response = try JSONDecoder().decode(UserModel.self, from: _data)
                    
                    self.getPetsData()
                    
                }
                
            } catch {
                print(error)
            }
            
        }
    }

    func getPetsData(page:Int = 1) {
        //MARK: - get posts data
        ApiManager.instance.netWorkCall(baseUrl: ApiManager.url.product, parameters: nil, methodType: .get,token:self.token, page: page) { data, response, error in
            
            do {
                if let _data = data{
                    let response = try JSONDecoder().decode(SalesModel.self, from: _data)
                    DispatchQueue.main.async {
                        self.isLoading = false
                        if let res = response.data?.posts {
                            for post in res {
                                
                                self.posts.append(post)
                                
                                
                            }
                        }
                        print(self.posts.count,"postcount")
                        self.cv.reloadData()
                    }
                }
                
            } catch {
                print(error)
            }
        }
        
    }
    
    //MARK: - collection view Delegate dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.reuseIdentifier, for: indexPath) as! ProductCell
        cell.videoPlayerView.frame = cell.bounds
        cell.playerLayer?.frame = cell.bounds
        cell.videoPlayerView.layoutIfNeeded()
        cell.configure(with: self.posts[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let videoCell = cell as? ProductCell else{ return }
//            videoCell.playerLayer?.player?.play()
        
        let visibleCells = cv.visibleCells.compactMap { $0 as? ProductCell }
              // visibleCells.forEach { cell in
                   if let indexPath = collectionView.indexPath(for: cell) {
                       let rect = collectionView.layoutAttributesForItem(at: indexPath)?.frame
                       let fullyVisible = collectionView.bounds.contains(rect ?? .zero)
                       if fullyVisible {
                           videoCell.playerLayer?.player?.play()
                       } else {
                           videoCell.playerLayer?.player?.pause()
                       }
                   }
               //}
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: videoCell.playerLayer!.player?.currentItem, queue: .main) { [weak videoCell]_ in
            guard let _ = videoCell else{ return }
            let indexcell = indexPath.row + 1
            if  indexcell < self.posts.count{
                self.cv.scrollToItem(at: IndexPath(row: indexcell, section: 0), at: .bottom, animated: true) //.scrollToRow(at: IndexPath(row: indexcell, section: 0), at: .bottom, animated: true)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let videoCell = cell as? ProductCell else{ return }
        videoCell.playerLayer?.player?.pause()
    }
    //MARK: - collection view scrolling pagination api call
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let offsetY = scrollView.contentOffset.y
           let contentHeight = scrollView.contentSize.height
           
           if offsetY > contentHeight - scrollView.frame.height * 4 && isLoading == false {
               isLoading = true
               self.page += 1
               getPetsData(page: self.page)
           }
       
        let visibleCells = cv.visibleCells.compactMap { $0 as? ProductCell }
                visibleCells.forEach { cell in
                    if let indexPath = cv.indexPath(for: cell) {
                        let rect = cv.layoutAttributesForItem(at: indexPath)?.frame
                        let fullyVisible = cv.bounds.contains(rect ?? .zero)
                        if fullyVisible {
                            cell.player?.play()
                        } else {
                            cell.player?.pause()
                        }
                    }
                }
       }
    
}
