//  HistoryCVC.swift
//  Connect4
//
//  Created by Ga Jun Young on 2020/3/23.
//  Copyright © 2020 CS UCD. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "showHistory"

class HistoryCVC: UICollectionViewController {

    private var sessions = [Session]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }

    func fetchData() { // Core Data fetch sessions
        sessions.removeAll()
        
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()

        do {
            let sessions = try PersistenceService.context.fetch(fetchRequest)
            self.sessions = sessions
        } catch {}
        
        self.collectionView.reloadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // segue to replay which is a Connect4VC
        if let indexPath = collectionView.indexPath(for: sender as! UICollectionViewCell) {
            let session = sessions[indexPath.item]
            
            if let destinationVC = segue.destination as? Connect4VC {
                destinationVC.replaySession = session
            }
        }
    }


    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return the number of items
        return sessions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? HistoryCVCell else {
            return UICollectionViewCell()
        }

        // Configure the cell
        cell.moveCount.text = "\(sessions[indexPath.item].move?.moves.count ?? 0)"
        cell.gameOutcome.text = sessions[indexPath.item].outcome
        if let data = sessions[indexPath.item].thumbnail {
            cell.gameImage.image = UIImage(data: data)
        } else {
            cell.gameImage.image = UIImage()
        }
        
        cell.layer.cornerRadius = 8 // cell corner edges
        return cell
    }
}

