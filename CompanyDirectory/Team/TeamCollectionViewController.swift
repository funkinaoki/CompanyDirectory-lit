//
//  TeamCollectionViewController.swift
//  CompanyDirectory
//
//  Created by 大林拓実 on 2021/02/17.
//

import UIKit

class TeamCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
}

class TeamCollectionViewController: UIViewController {
    
    @IBOutlet private var collectionView: UICollectionView!

    var database: Database?
    var detailTeam: Team?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        database = Database()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTeamDetail" {
            let vc = segue.destination as! TeamDetailViewController
            vc.team = detailTeam
        }
        if segue.identifier == "toAddTeam" {
            let vc = segue.destination as! AddTeamViewController
            vc.delegate = self
        }
    }
    
}

extension TeamCollectionViewController: AddTeamProtocol {
    func viewDidDismiss() {
        database = Database()
        collectionView.reloadData()
    }
    
}

extension TeamCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        database!.teams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TeamCollectionViewCell
        cell.imageView.image = UIImage(systemName: "person.circle")
        cell.nameLabel.text = database!.teams[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        detailTeam = database!.teams[indexPath.row]
        performSegue(withIdentifier: "toTeamDetail", sender: nil)

    }
}

