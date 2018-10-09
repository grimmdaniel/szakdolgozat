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
        let width = 70
        let height = 40
        return CGSize(width: width, height: height)
    }
}

extension GamePreviewVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parsedGame.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoveNameCell", for: indexPath) as! MoveNameCollectionViewCell
        cell.moveNameLabel.text = parsedGame[indexPath.row]
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
        let text = self.parsedGame[indexPath.item]
        size = text.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0)])
        size.height = 40
        size.width += 10
        return size
    }
}

extension TrainingBaseVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = trainings.index(of: viewController as! TrainingVC)!
        let previousIndex = currentIndex > 0 ? currentIndex - 1 : trainings.count-1
        return trainings[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = trainings.index(of: viewController as! TrainingVC)!
        let nextIndex = abs((currentIndex + 1) % trainings.count)
        return trainings[nextIndex]
    }
    
}

extension TrainingBaseVC: UIPageViewControllerDelegate {
    func pageViewController(_ willTransitionTopageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = trainings.index(of: pendingViewControllers.first! as! TrainingVC)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = pendingIndex
            if let index = currentIndex {
                pageControl.currentPage = index
            }
        }
    }
}
