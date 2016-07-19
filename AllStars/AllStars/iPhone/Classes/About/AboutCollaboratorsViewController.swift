//
//  AboutCollaboratorsViewController.swift
//  AllStars
//
//  Created by Ricardo Hernan Herrera Valle on 7/14/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import Foundation

class  AboutCollaboratorsViewController: UIViewController, UICollectionViewDataSource {
    
    
    @IBOutlet weak var collaboratorsCollectionView: UICollectionView!
    
    lazy var collaborators: [NSDictionary] = {
        
        let collaboratorsPath: NSURL! = NSBundle.mainBundle().URLForResource("Collaborators", withExtension: "plist")
        
        let collaboratorsPlist: NSDictionary! = NSDictionary(contentsOfURL: collaboratorsPath)
        
        let array = collaboratorsPlist["Collaborators"] as! [NSDictionary]
        
        return array
    }()
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collaborators.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let collaborator = collaborators[indexPath.row]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollaboratorCell", forIndexPath: indexPath) as! CollaboratorCell
        
        cell.userName.text = collaborator["Name"] as? String
        cell.userImage.image = UIImage(named: collaborator["Pic"] as! String)
        
        return cell
    }
}

class CollaboratorCell: UICollectionViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
}