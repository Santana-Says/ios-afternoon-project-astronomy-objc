//
//  PhotosCollectionVC.swift
//  Astrnomy-C
//
//  Created by Jeffrey Santana on 10/14/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PhotoCell"

class PhotosCollectionVC: UICollectionViewController {

	// MARK: - IBOutlets
	
	
	// MARK: - Properties
	
	let photosController = PhotosController()
    private var roverInfo: Rover? {
        didSet {
            solDescription = roverInfo?.solDescriptions[55]
        }
    }
    private var solDescription: SolDescription? {
        didSet {
			if let rover = roverInfo,
				let sol = solDescription?.sol {
				photosController.fetchPhotos(from: rover, onSol: NSNumber(value: sol), withCompletion: { (photoRefs) in
					if let photos = photoRefs as? [Photo] {
						self.photoReferences = photos
					} else {
						NSLog("Error fetching photos for \(rover.name) on sol \(sol)")
						return
					}
				})
			}
        }
    }
    private var photoReferences = [Photo]() {
        didSet {
            DispatchQueue.main.async { self.collectionView?.reloadData() }
        }
    }
	
	private var storage = Cache<NSString, NSData>()
	private let photofetchQueue = OperationQueue()
	private var storedFetchOps = [String:FetchOperation]()
	private let cancelQueue = DispatchQueue(label: "MyCancelationOps")
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		photosController.fetchManifest(fromRover: "curiosity") { (results) in
			if results != nil {
				print("Retreived \(self.photosController.photos.count) photos")
				self.roverInfo = results?.first as? Rover
			}
		}
	}
	
	// MARK: - IBActions
	
	
	// MARK: - Helpers
	
    private func loadImage(forCell cell: PhotoCell, forItemAt indexPath: IndexPath) {
		let photoRef = photoReferences[indexPath.item]
		guard let photoUrl = photoRef.imageURL?.usingHTTPS else { return }
		
//		if let photoData = self.storage.value(forKey: photoUrl.absoluteString) {
//			cell.imageView.image =  UIImage(data: photoData)
//			return
//		}
		
		let fetchPhotoOp = FetchOperation(photoRef: photoRef)
		let cacheOp = BlockOperation {
			if let photoData = fetchPhotoOp.imageData {
//				self.storage.cache(value: photoData, for: photoUrl.absoluteString)
			}
		}
		
		let cellCheckOp = BlockOperation {
			if let cellPath = self.collectionView.indexPath(for: cell), cellPath != indexPath {
				return
			}
			if let photoData = fetchPhotoOp.imageData {
				cell.imageView.image =  UIImage(data: photoData)
			}
		}
		
		cacheOp.addDependency(fetchPhotoOp)
		cellCheckOp.addDependency(fetchPhotoOp)
		
		photofetchQueue.addOperations([fetchPhotoOp, cacheOp], waitUntilFinished: false)
		OperationQueue.main.addOperation(cellCheckOp)
		
		storedFetchOps.updateValue(fetchPhotoOp, forKey: photoUrl.absoluteString)
    }

    // MARK: UICollectionViewDataSource
	
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		photosController.photos.count
    }

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotoCell ?? PhotoCell()
        
        loadImage(forCell: cell, forItemAt: indexPath)
        
        return cell
    }
    
    // Make collection view cells fill as much available width as possible
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        var totalUsableWidth = collectionView.frame.width
        let inset = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
        totalUsableWidth -= inset.left + inset.right
        
        let minWidth: CGFloat = 150.0
        let numberOfItemsInOneRow = Int(totalUsableWidth / minWidth)
        totalUsableWidth -= CGFloat(numberOfItemsInOneRow - 1) * flowLayout.minimumInteritemSpacing
        let width = totalUsableWidth / CGFloat(numberOfItemsInOneRow)
        return CGSize(width: width, height: width)
    }
    
    // Add margins to the left and right side
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
    }
	
	override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		guard let photoUrl = photoReferences[indexPath.item].imageURL?.usingHTTPS,
			let fetchOp = storedFetchOps[photoUrl.absoluteString] else { return }
		
		cancelQueue.sync {
			fetchOp.cancel()
		}
	}
}
