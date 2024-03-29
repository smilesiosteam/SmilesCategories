//
//  CuisinesTableViewCell.swift
//  House
//
//  Created by Shahroze Zaheer on 10/26/22.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import UIKit
import SkeletonView

public enum CusineCases: Int {
    case topBrand = 0
    case cuisines = 1
}

public class CuisinesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    public var collectionsDataCuisine: [GetCuisinesResponseModel.CuisineDO]?{
        didSet{
            self.collectionView?.reloadData()
        }
    }
    var callBack: ((GetCuisinesResponseModel.CuisineDO) -> ())?
    public static let module = Bundle.module
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.register(UINib(nibName: String(describing: CuisinesCollectionViewCell.self), bundle: .module), forCellWithReuseIdentifier: String(describing: CuisinesCollectionViewCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = setupCollectionViewLayout()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    public override func layoutSubviews() {
        setCollectionViewLayout()
    }
    
    private func setupCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let inset: CGFloat = 16
        let collectionViewHeight: CGFloat
        
        let itemHeight: NSCollectionLayoutDimension = .fractionalHeight(1)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: itemHeight)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(104), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets.leading = inset
        section.contentInsets.trailing = inset
        
        collectionViewHeight = 126
        
        self.collectionViewHeightConstraint.constant = collectionViewHeight
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func setCollectionViewLayout() {
        self.collectionView.collectionViewLayout = setupCollectionViewLayout()
    }
    
    func setBackGroundColor(color: UIColor) {
        mainView.backgroundColor = color
    }
}

extension CuisinesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionsDataCuisine?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cuisine = collectionsDataCuisine?[safe: indexPath.row]{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CuisinesCollectionViewCell", for: indexPath) as? CuisinesCollectionViewCell else {return UICollectionViewCell()}
            
            cell.configureCell(with: cuisine)
            cell.hideSkeleton()
            return cell
        }
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let data = collectionsDataCuisine?[indexPath.row] {
            callBack?(data)
        }
    }
}
