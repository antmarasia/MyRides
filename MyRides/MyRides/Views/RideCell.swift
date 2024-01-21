//
//  RideCell.swift
//  MyRides
//
//  Created by Anthony Marasia on 1/17/24.
//

import UIKit

struct RideCellModel {
    let startTime: Date
    let endTime: Date
    let riderCount: Int
    let boosterCount: Int
    let estimatedEarnings: String
    let locations: [String]
    let timeZoneIdentifier: String
    
    var startTimeFormatted: String {
        DateFormatter.hmma(startTime, timeZoneIdentifier: timeZoneIdentifier)
    }
    
    var endTimeFormatted: String {
        DateFormatter.hmma(endTime, timeZoneIdentifier: timeZoneIdentifier)
    }
    
    var riderText: String {
        riderCount > 1 ? "riders" : "rider"
    }
    
    var boosterText: String {
        boosterCount > 1 ? "boosters" : "booster"
    }
    
    var hasBoosterSeat: Bool {
        boosterCount > 0
    }
    
    init(trip: Trip) {
        startTime = trip.paymentStartsAt
        endTime = trip.paymentEndsAt
        riderCount = trip.passengers.count
        boosterCount = trip.passengers.map { $0.boosterSeat }.filter { $0 }.count
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        estimatedEarnings = formatter.string(from: trip.estimatedEarnings as NSNumber) ?? ""
        
        var locations = [String]()
        
        for (index, waypoint) in trip.waypoints.enumerated() {
            locations.append("\(index + 1). \(waypoint.location.address)")
        }
        self.locations = locations
        timeZoneIdentifier = trip.timeZoneName
    }
}

class RideCell: UICollectionViewCell {
    private static let sidePadding: CGFloat = 8
    
    private let timeLabel = UILabel()
    private let estimatePaymentLabel = UILabel()
    private let labelStackView = UIStackView()
    private let locationStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
        layer.borderWidth = 1.0
        layer.cornerRadius = 4.0
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(labelStackView)
        contentView.addSubview(locationStackView)
        
        locationStackView.axis = .vertical
        locationStackView.spacing = 4
        
        timeLabel.lineBreakMode = .byWordWrapping
        timeLabel.numberOfLines = 0
        estimatePaymentLabel.textAlignment = .left
        estimatePaymentLabel.lineBreakMode = .byWordWrapping
        estimatePaymentLabel.numberOfLines = 0
        estimatePaymentLabel.textAlignment = .right
        
        labelStackView.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(RideCell.sidePadding)
            make.leading.equalToSuperview().inset(RideCell.sidePadding)
            make.trailing.equalToSuperview().inset(RideCell.sidePadding)
            make.bottom.equalTo(locationStackView.snp.top).offset(-RideCell.sidePadding)
        }
        
        locationStackView.snp.remakeConstraints { make in
            make.leading.equalToSuperview().inset(RideCell.sidePadding)
            make.trailing.equalToSuperview().inset(RideCell.sidePadding)
            make.bottom.equalToSuperview().inset(RideCell.sidePadding)
        }
        
        labelStackView.axis = .horizontal
        labelStackView.distribution = .fill
        labelStackView.addArrangedSubview(timeLabel)
        labelStackView.addArrangedSubview(estimatePaymentLabel)
    }
    
    private func getTextForTimeLabel(model: RideCellModel) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: AppConfiguration.current.theme.defaultFontSize)]
        let text = NSMutableAttributedString(string: model.startTimeFormatted, attributes: attributes)
        
        let attributesForEndTime = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: AppConfiguration.current.theme.defaultFontSize)]
        text.append(NSMutableAttributedString(string: " — \(model.endTimeFormatted)", attributes: attributesForEndTime))
        
        let attributesForRiders = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: AppConfiguration.current.theme.smallerFontSize)]

        let boosterText = model.hasBoosterSeat ? " • \(model.boosterCount) \(model.boosterText)" : ""
        let part2 = NSAttributedString(string: " (\(model.riderCount) \(model.riderText)\(boosterText))", attributes: attributesForRiders)
        text.append(part2)
        return text
    }
    
    private func getTextForEstimatePaymentLabel(model: RideCellModel) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.foregroundColor : AppConfiguration.current.theme.defaultColor,
                          NSAttributedString.Key.font : UIFont.systemFont(ofSize: AppConfiguration.current.theme.smallerFontSize)]
        let text = NSMutableAttributedString(string: "est. ", attributes: attributes)
        
        let attributesForCurrency = [NSAttributedString.Key.foregroundColor : AppConfiguration.current.theme.defaultColor,
                                     NSAttributedString.Key.font : UIFont.systemFont(ofSize: AppConfiguration.current.theme.defaultFontSize)]
        let part2 = NSAttributedString(string: "\(model.estimatedEarnings)", attributes: attributesForCurrency)
        text.append(part2)
        return text
    }
    
    func update(with model: RideCellModel) {
        timeLabel.attributedText = getTextForTimeLabel(model: model)
        estimatePaymentLabel.attributedText = getTextForEstimatePaymentLabel(model: model)
        
        model.locations.forEach {
            locationStackView.addArrangedSubview(locationLabel(text: $0))
        }
    }
    
    private func locationLabel(text: String) -> UILabel {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.text = text
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }
}
