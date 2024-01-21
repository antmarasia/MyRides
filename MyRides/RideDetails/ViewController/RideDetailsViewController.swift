//
//  RideDetailsViewController.swift
//  MyRides
//
//  Created by Anthony Marasia on 1/19/24.
//

import UIKit
import MapKit

class RideDetailsViewController: UIViewController {
    private let trip: Trip
    
    private let rideHeaderView = RideHeaderView()
    private let mapView = MKMapView()
    private var seriesLabel: SimpleLabelView = {
        let label = SimpleLabelView()
        let padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        let attributes = [NSAttributedString.Key.foregroundColor : AppConfiguration.current.theme.greyColor,
                          NSAttributedString.Key.font : UIFont.italicSystemFont(ofSize: AppConfiguration.current.theme.defaultFontSize)]
        let text = NSMutableAttributedString(string: "This trip is part of a series", attributes: attributes)
        label.update(with: SimpleLabelViewModel(attributedText: text, padding: padding))
        return label
    }()
    
    private let pickupAddressListView = AddressListView()
    private let dropoffAddressListView = AddressListView()
    private let tripStatsLabel = SimpleLabelView()
    private let cancelButton = UIButton()
    
    init(trip: Trip) {
        self.trip = trip
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Ride Details"
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        setupRideHeaderView()
        setupMap()
        setupSeriesLabel()
        setupAddressLists()
        setupTripStats()
        setupCancelButton()
    }
    
    private func setupRideHeaderView() {
        view.addSubview(rideHeaderView)
        let section = RideSection(count: 1, startTime: trip.paymentStartsAt, endTime: trip.paymentEndsAt, estimatedEarnings: trip.estimatedEarnings, trips: [trip])
        rideHeaderView.update(with: RideHeaderViewModel(section: section, style: .rideDetails))
        
        rideHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
    }
    
    private func setupMap() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalTo(rideHeaderView.snp.bottom)
            make.height.equalTo(250)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        let startLocation = trip.waypoints.first?.location
        let endLocation = trip.waypoints.count > 1 ? trip.waypoints.last?.location : nil
        
        if let startLocation {
            addPin(location: CLLocationCoordinate2D(latitude: startLocation.lat, longitude: startLocation.lng), isStart: true)
        }
        
        if let endLocation {
            addPin(location: CLLocationCoordinate2D(latitude: endLocation.lat, longitude: endLocation.lng), isStart: false)
        }
        
        // Zoom to show both a pins
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    private func setupSeriesLabel() {
        view.addSubview(seriesLabel)
        
        seriesLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        seriesLabel.isHidden = !(trip.inSeries == true)
    }
    
    private func setupAddressLists() {
        // Pick up view
        view.addSubview(pickupAddressListView)
        
        pickupAddressListView.snp.makeConstraints { make in
            make.top.equalTo(seriesLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        pickupAddressListView.update(with: AddressListViewModel(isAnchor: true, address: trip.waypoints.first?.location.address))
        
        // Drop off view
        view.addSubview(dropoffAddressListView)
        
        dropoffAddressListView.snp.makeConstraints { make in
            make.top.equalTo(pickupAddressListView.snp.bottom).offset(-1)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        dropoffAddressListView.update(with: AddressListViewModel(isAnchor: false, address: trip.waypoints.last?.location.address))
    }
    
    private func setupTripStats() {
        view.addSubview(tripStatsLabel)
        
        tripStatsLabel.snp.makeConstraints { make in
            make.top.equalTo(dropoffAddressListView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
                
        // Convert meters to miles
        let totalDistanceMiles = Double(trip.plannedRoute.totalDistance) * 0.00062137
        let totalDistance = String(format: "%.2f", totalDistanceMiles)
        let attributes = [NSAttributedString.Key.foregroundColor : AppConfiguration.current.theme.greyColor,
                          NSAttributedString.Key.font : UIFont.systemFont(ofSize: AppConfiguration.current.theme.defaultFontSize)]
        let text = NSMutableAttributedString(string: "Trip ID: \(trip.slug) • \(totalDistance) mi • \(trip.plannedRoute.totalTime) min", attributes: attributes)
        let padding = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
        tripStatsLabel.update(with: SimpleLabelViewModel(attributedText: text, padding: padding))
    }
    
    private func setupCancelButton() {
        view.addSubview(cancelButton)
        
        cancelButton.setTitle("Cancel This Trip", for: .normal)
        cancelButton.backgroundColor = .white
        cancelButton.setTitleColor(.red, for: .normal)
        cancelButton.layer.borderWidth = 1.0
        cancelButton.layer.borderColor = AppConfiguration.current.theme.greyColor.cgColor
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(tripStatsLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
    }
    
    private func addPin(location: CLLocationCoordinate2D, isStart: Bool) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = isStart ? "Start" : "End"
        mapView.addAnnotation(annotation)
    }
    
    @objc private func didTapCancelButton() {
        let primaryButtonStyle = ButtonStyle(backgroundColor: AppConfiguration.current.theme.defaultColor,
                                             cornerRadius: 16.0,
                                             textStyle: TextStyle(textColor: .white,
                                                                  font: nil,
                                                                  textAlignment: .center))
        let secondaryButtonStyle = ButtonStyle(backgroundColor: .white,
                                               cornerRadius: 16.0,
                                               textStyle: TextStyle(textColor: AppConfiguration.current.theme.defaultColor,
                                                                    font: nil,
                                                                    textAlignment: .left))
        let model = AlertViewModel(title: "Are you sure?",
                                   titleStyle: TextStyle(textColor: .black, font: nil, textAlignment: .center),
                                   subtitle: "Are you sure you want to cancel this claim? This cannot be undone.",
                                   subtitleStyle: TextStyle(textColor: AppConfiguration.current.theme.greyColor, font: nil, textAlignment: .left),
                                   primaryButtonStyle: primaryButtonStyle,
                                   secondaryButtonStyle: secondaryButtonStyle,
                                   buttons: [AlertButton(text: "Nevermind", isPrimary: true), AlertButton(text: "Yes", isPrimary: false)])
        
        let alertVC = AlertViewController(model: model)
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alertController.setValue(alertVC, forKey: "contentViewController")
        alertController.view.backgroundColor = .white
        alertController.view.layer.cornerRadius = 4.0
        self.present(alertController, animated: true)
    }
}
