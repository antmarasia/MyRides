//
//  MyRidesViewController.swift
//  MyRides
//
//  Created by Anthony Marasia on 1/17/24.
//

import UIKit
import SnapKit

class MyRidesViewController: UIViewController {
    
    private var myRides: MyRides?
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 8.0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Rides"
        view.backgroundColor = .white
        
        setupCollectionView()
        fetchTrips()
    }
    
    private func fetchTrips() {
        Task {
            do {
                let trips = try await APIClient.shared.fetchTrips()
                self.myRides = MyRides(trips: trips)
                collectionView.reloadData()
            }
            catch {
                print("Unable to fetch trips \(error)")
            }
        }
    }
}

extension MyRidesViewController {
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        assignLayout(to: collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDelegate

extension MyRidesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        myRides?.sections.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let myRides else { return 0 }
        return myRides.sections[section].trips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RideCell.reuseIdentifier, for: indexPath) as? RideCell, let myRides else {
            fatalError("Unknown cell")
        }
        let trip = myRides.sections[indexPath.section].trips[indexPath.row]
        cell.update(with: RideCellModel(trip: trip))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RideHeaderView.reuseIdentifier, for: indexPath) as? RideHeaderView, let myRides else {
            fatalError("Unknown UICollectionReusableView")
        }
        let section = myRides.sections[indexPath.section]
        view.update(with: RideHeaderViewModel(section: section))
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let trip = myRides?.sections[indexPath.section].trips[indexPath.row] else { return }
        navigationController?.pushViewController(RideDetailsViewController(trip: trip), animated: true)
    }
    
}
