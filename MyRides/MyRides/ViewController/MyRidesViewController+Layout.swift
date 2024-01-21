//
//  MyRidesViewController+Layout.swift
//  MyRides
//
//  Created by Anthony Marasia on 1/18/24.
//

import UIKit

extension MyRidesViewController {
    func assignLayout(to collectionView: UICollectionView) {
        let section = defaultBackgroundLayoutSection()
        section.interGroupSpacing = 8
        
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(48))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        collectionView.collectionViewLayout = layout
        
        // Register cells
        collectionView.register(RideCell.self, forCellWithReuseIdentifier: RideCell.reuseIdentifier)
        collectionView.register(RideHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RideHeaderView.reuseIdentifier)
    }
    
    private func defaultBackgroundLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        section.interGroupSpacing = 8
        return section
    }
}
