//
//  ViewController.swift
//  KindleMock
//
//  Created by Kevin Molina on 2/11/19.
//  Copyright © 2019 Kevin Molina. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var books: [Book]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarStyles()
        setupNavBarButtons()
        
        tableView.register(BookCell.self, forCellReuseIdentifier: "cellId")
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(white: 1, alpha: 0.3)
        tableView.separatorColor = UIColor(white: 1, alpha: 0.2)
        
        
        navigationItem.title = "Kindle"
        
        fetchBooks()
    
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
//        footerView.translatesAutoresizingMaskIntoConstraints = false
//        footerView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        
        let segmentedControl = UISegmentedControl(items: ["Cloud", "Device"])
        segmentedControl.tintColor = .white
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        footerView.addSubview(segmentedControl)
        
        segmentedControl.widthAnchor.constraint(equalToConstant: 200).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        segmentedControl.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        
        let gridButton = UIButton(type: .system)
        gridButton.setImage(#imageLiteral(resourceName: "grid").withRenderingMode(.alwaysOriginal), for: .normal)
        gridButton.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(gridButton)
        
        gridButton.leftAnchor.constraint(equalTo: footerView.leftAnchor, constant: 8).isActive = true
        gridButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        gridButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        gridButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        
        let sortButton = UIButton(type: .system)
        sortButton.setImage(#imageLiteral(resourceName: "sort").withRenderingMode(.alwaysOriginal), for: .normal)
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(sortButton)
        
        sortButton.rightAnchor.constraint(equalTo: footerView.rightAnchor, constant: -8).isActive = true
        sortButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        sortButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        gridButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func setupNavBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuPress))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "amazon_icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAmazonStorePress))
    }
    
    @objc func handleAmazonStorePress() {
        print("amazon store pressed")
    }
    
    @objc func handleMenuPress() {
        print("Menu pressed")
    }
 
    func setupNavigationBarStyles() {
        print("setting up nav bar styles")
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] // Title bar color adjustment
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    // if using storyboard
    
    func fetchBooks() {
        print("Fetching books...")
        if let url = URL(string: "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/kindle.json") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in // completion handler block
                if let err = error {
                    print("Failed to fetch external json books: ", err)
                    return
                }

                guard let data = data else {return} // unwrap the optional
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    guard let bookDictionaries = json as? [[String: Any]] else { return } // unwrap the json and cast it as an array of dictionaries.
                    
                    self.books = []
                    for bookDictionary in bookDictionaries { // if you want to access the individual values
                        // this is how you do so...
                        let book = Book(dictionary: bookDictionary)
                        self.books?.append(book)
                    }
                    DispatchQueue.main.async { // use async so that you can avoid below problem.
                        self.tableView.reloadData() // executing this on the main thread is dangerous
                    }
                    
                } catch let jsonError {
                    print("Failed to parse JSON properly: ", jsonError)
                }
                
            }.resume()
        
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedBook = self.books?[indexPath.row]

        let layout = UICollectionViewFlowLayout()
        let bookPagerController = BookPagerController(collectionViewLayout: layout)
        
        bookPagerController.book = selectedBook
        
        
        let navController = UINavigationController(rootViewController: bookPagerController)
        present(navController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! BookCell
        
        let book = books?[indexPath.row]
        
        cell.book = book
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = books?.count {
            return count
        }
        
        return 0
        
    }
    
//    func setupBooks() {
//        let page1 = Page(number: 1, text: "Text for the first page")
//        let page2 = Page(number: 2, text: "Text for second page")
//
//        // array of pages
//        let pages = [page1, page2]
//
//        let book = Book(title: "Steve Jobs", author: "Walter Isaacson", image: #imageLiteral(resourceName: "steve_jobs"), pages: pages)
//
//
//        let book2 = Book(title: "Bill Gates: A Biography", author: "Michael Becraft", image: #imageLiteral(resourceName: "bill_gates"), pages: [
//            Page(number: 1, text: "Text for page 1"),
//            Page(number: 2, text: "Text for page 2"),
//            Page(number: 3, text: "Text for page 3"),
//            Page(number: 4, text: "Text for page 4")])
//
//        self.books = [book, book2]
//
//    }


}

