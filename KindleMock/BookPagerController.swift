//
//  BookPagerController.swift
//  KindleMock
//
//  Created by Kevin Molina on 2/17/19.
//  Copyright © 2019 Kevin Molina. All rights reserved.
//

import UIKit

class BookPagerController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var book: Book?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        navigationItem.title = self.book?.title
        
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: "cellId")
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal
        
        layout?.minimumLineSpacing = 0
        collectionView.isPagingEnabled = true
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(handleCloseBook))
    }
    
    @objc func handleCloseBook() {
        dismiss(animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 44 - 20)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return book?.pages.count ?? 0 // another way to unwrap an optional safely (let guard...)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PageCell
        
        let page = book?.pages[indexPath.item] // This is how you render the individual pages
        pageCell.textLabel.text = page?.text // for each book.
        
        
//        cell.backgroundColor = (indexPath.item % 2 == 0) ? .red : .blue
        
        return pageCell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionViewLayout.invalidateLayout()
    }
    
    
    
}
