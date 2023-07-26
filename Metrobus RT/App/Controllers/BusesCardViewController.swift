//
//  BusesCardViewController.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/4/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import UIKit

class BusesCardViewController: UICollectionViewController {
    private let reuseIdentifier = "BusCardViewCell"
    
    private var busesApproachingList : [BusCardViewCell.ViewModel] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let cellSize = CGSize(width: UIScreen.main.bounds.width-80, height: 100)
    private let numberOfSections = 1
    
    required init() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.estimatedItemSize = cellSize
        self.busesApproachingList = []
        
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "BusCardViewCell", bundle: .main), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .clear
    }
    
    func updateWith(busList list: [Bus]) {
        self.busesApproachingList = list.map({ BusCardViewCell.ViewModel.init(bus: $0) })
    }
}

extension BusesCardViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return busesApproachingList.count
    }
}

// MARK - View delegate layout

extension BusesCardViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
