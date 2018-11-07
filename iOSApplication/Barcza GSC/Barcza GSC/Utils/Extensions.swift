//
//  Extensions.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 08. 06..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import Foundation

extension ChessBoardVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moves.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoveNameCell", for: indexPath) as! MoveNameCollectionViewCell
        cell.moveNameLabel.text = moves[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize.zero
        let text = moves[indexPath.row]
        size = text.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0)])
        size.height = 40
        size.width += 15
        return size
    }
}

extension GamePreviewVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moves.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoveNameCell", for: indexPath) as! MoveNameCollectionViewCell
        if indexPath.row % 2 == 0{
            cell.moveNameLabel.text = "\(indexPath.row / 2 + 1)." + moves[indexPath.row]
        }else{
            cell.moveNameLabel.text = moves[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize.zero
        var text = ""
        if indexPath.row % 2 == 0{
            text = "\(indexPath.row / 2 + 1)." + moves[indexPath.row]
        }else{
            text = moves[indexPath.row]
        }
        
        size = text.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0)])
        size.height = 40
        size.width += 15
        return size
    }
}
