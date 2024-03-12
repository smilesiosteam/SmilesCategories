//
//  ItemCategoriesTableViewCell.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 28/11/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import UIKit

class ItemCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainVuHgt: NSLayoutConstraint?
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionsData: [HomeItemCategoryDetails]? {
        didSet {
            collectionView?.reloadData()
            layoutIfNeeded()
            mainVuHgt?.constant = verticalLayouting ? collectionView.collectionViewLayout.collectionViewContentSize.height : 250.0
        }
    }
    
    var callBack: ((HomeItemCategoryDetails) -> ())?
    var verticalLayouting = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.register(UINib(nibName: String(describing: ItemCategoryCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ItemCategoryCollectionViewCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = setupCollectionViewLayout()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupCollectionViewLayout() ->  UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            if self.verticalLayouting {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.25), heightDimension: .estimated(130)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(300)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
                return section
            }else{
                let inset: CGFloat = 4
                
                let smallItemSize = NSCollectionLayoutSize(widthDimension: .absolute(90.0), heightDimension: .fractionalHeight(0.5))
                let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
                smallItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: inset, bottom: 0, trailing: inset)
                
                let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
                let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: nestedGroupSize, subitems: [smallItem])
                
                let outerGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(90.0), heightDimension: .fractionalHeight(1))
                let outerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: outerGroupSize, subitems: [nestedGroup])
                
                let section = NSCollectionLayoutSection(group: outerGroup)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)
                section.orthogonalScrollingBehavior = .continuous
                
                let config = UICollectionViewCompositionalLayoutConfiguration()
                config.scrollDirection = .vertical
                return section
            }
        }
    }
    
    func setBackGroundColor(color: UIColor) {
        mainView.backgroundColor = color
    }
}

extension ItemCategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionsData?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let data = collectionsData?[indexPath.row] {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCategoryCollectionViewCell", for: indexPath) as? ItemCategoryCollectionViewCell else { return UICollectionViewCell() }
            cell.configureCellWithData(category: data)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let data = collectionsData?[indexPath.row] {
            callBack?(data)
        }
    }
}
