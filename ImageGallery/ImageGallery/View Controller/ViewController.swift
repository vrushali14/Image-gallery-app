//
//  ViewController.swift
//  ImageGallery
//
//  Created by Jadhav, V. A. on 25/09/2020.
//  Copyright © 2020 Vrushali. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, ImageDownloadedTaskDelegate {

    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var messageLabel : UILabel!
    @IBOutlet weak var indicator : UIActivityIndicatorView!
    
    
    var photosArray : [PhotoModel]? = []
    var photoSizeArray : [PhotoSize] = []
    var biggerImageURLs : [String] = []
    var selectedImageURL : String!
    var imageTasks = [Int: ImageDownloadTask]()
    
    var page : Int = 1
    var searchText : String = ""
    var isWaiting : Bool = false
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = true
        }
        
    }

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! DisplayImageViewController
        destination.imageURL = self.selectedImageURL
    }
    
    // MARK:-
    private func clearData() {
        self.photoSizeArray.removeAll()
        self.biggerImageURLs.removeAll()
        imageTasks.removeAll()
    }
    
    //MARK:- Activity Indicator methods
    private func startIndicator() {
        self.indicator.startAnimating()
        self.indicator.isHidden = false
    }
  
    private func stopIndicator() {
        self.indicator.stopAnimating()
        self.indicator.isHidden = true
    }
    
    //MARK:- API Call
    private func fetchImages () {
        
        let imageAPI = ImageFetchAPI()
        imageAPI.searchImageByTag(tag: self.searchText, page: self.page) { (response, err) in
            
            if err == nil {
                //fetch image urls from ids
                self.fetchImageURLs(photosArray: response.data?.photosArray ?? [])
            } else {
                self.messageLabel.isHidden = false
                self.stopIndicator()
                self.collectionView.reloadData()
            }
        }
    }
    
    private func fetchImageURLs(photosArray : [PhotoModel]) {
        
        var idArray : [String] = []
        
        for photo in photosArray {
            idArray.append(photo.uniqueId!)
        }
        //print(idArray)
        let imageAPI = ImageFetchAPI()
        imageAPI.callAsyncRequests(photoIdArray: idArray) { (sizeDataArray) in
            
            let startIndex = self.photoSizeArray.count
            
            for data in sizeDataArray {
                let sizeArray = data.photoSizes
                if let obj = sizeArray?.first(where: {$0.label == "Large Square"}) {
                    self.photoSizeArray.append(obj)
                    
                    //Get image URL for full view
                    if let medObj = sizeArray?.first(where: {$0.label == "Large"}) {
                        self.biggerImageURLs.append(medObj.source ?? "")
                    } else {
                        //print(data)
                        self.biggerImageURLs.append(obj.source ?? "")
                    }
                }
                
            }
            
            //set up image downloading tasks
            self.setupImageTasks(totalImages: self.photoSizeArray.count, startIndex:startIndex)
            
            DispatchQueue.main.async {
                if self.photoSizeArray.count == 0 {
                    self.messageLabel.isHidden = false
                } else {
                    self.messageLabel.isHidden = true
                }
                
                self.stopIndicator()
                self.collectionView.reloadData()
            }
        }
    }
    
    //MARK:- Image downloading
    private func setupImageTasks(totalImages: Int, startIndex: Int) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        for i in startIndex..<totalImages {
            let image = photoSizeArray[i]
            let url = URL(string: image.source ?? "")!
            //Creat image download tasks, store them in imageTasks dictionary
            let task = ImageDownloadTask(index: i, url: url, session: session, delegate: self)
            imageTasks[i] = task
        }
    }
    
    func imageDownloaded(index: Int) {
        self.collectionView?.reloadItems(at: [IndexPath(row: index, section: 0)])
    }
    
    //Load more pages
    private func loadMoreData() {
        self.page += 1
        self.fetchImages()
        self.isWaiting = false
    }
    
    
    //MARK:- Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.photoSizeArray.count
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        imageTasks[indexPath.row]?.resume()
        
        //Load more data
        if indexPath.row == self.photoSizeArray.count - 1 && !isWaiting {
            self.isWaiting = true
            self.loadMoreData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        imageTasks[indexPath.row]?.pause()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let imageViewCell: ImageViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageViewCell", for: indexPath) as! ImageViewCell
        
        let image = imageTasks[indexPath.row]?.image
        imageViewCell.setCellImage(image: image)
        
        return imageViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        self.selectedImageURL = self.biggerImageURLs[indexPath.row]
        self.performSegue(withIdentifier: "ShowImageSegue", sender: self)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width / 2 - 20
        return CGSize(width: width, height: width)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 10)
    }

    //MARK:- Search
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
     
        let searchView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchBarView", for: indexPath)
        return searchView
    }
     
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
             
        self.searchText = searchBar.text!
        self.page = 1
        self.clearData()
        
        if (searchBar.text!.isEmpty) {
            self.messageLabel.isHidden = false
            self.collectionView.reloadData()
        } else {
            
            self.startIndicator()
            self.messageLabel.isHidden = true
            self.fetchImages()
        }
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        //clear search bar
        searchBar.text = ""
        self.searchText = ""
        searchBar.endEditing(true)
        
        //Reset screen
        self.page = 1
        self.messageLabel.isHidden = false
        self.clearData()
        self.collectionView.reloadData()
    }
    
}

