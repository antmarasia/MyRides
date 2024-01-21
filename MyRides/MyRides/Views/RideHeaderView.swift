//
//  RideHeaderView.swift
//  MyRides
//
//  Created by Anthony Marasia on 1/18/24.
//

import UIKit

enum RideHeaderViewStyle {
    case myRides
    case rideDetails
}

struct RideHeaderViewModel {
    let startTime: Date
    let endTime: Date
    let estimatedEarnings: Int
    let style: RideHeaderViewStyle
    let timeZoneIdentifier: String?
    
    var day: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E M/d"
        return formatter.string(from: startTime)
    }
    
    var startTimeFormatted: String {
        DateFormatter.hmma(startTime, timeZoneIdentifier: timeZoneIdentifier)
    }
    
    var endTimeFormatted: String {
        DateFormatter.hmma(endTime, timeZoneIdentifier: timeZoneIdentifier)
    }
    
    init(section: RideSection, style: RideHeaderViewStyle = .myRides) {
        startTime = section.startTime
        endTime = section.endTime
        estimatedEarnings = section.estimatedEarnings
        timeZoneIdentifier = section.trips.first?.timeZoneName
        self.style = style
    }
}

class RideHeaderView: UICollectionReusableView {
    private let earningsStackView = UIStackView()
    private let label = UILabel()
    private let estimatedEarningsLabel = UILabel()
    private let estimatedEarningsAmountLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with model: RideHeaderViewModel) {
        setupLabel(with: model)
        setupEarnings(with: model)
    }
    
    private func setupViews() {
        addSubview(label)
        addSubview(earningsStackView)
        
        earningsStackView.addArrangedSubview(estimatedEarningsLabel)
        earningsStackView.addArrangedSubview(estimatedEarningsAmountLabel)
        
        earningsStackView.axis = .vertical
        earningsStackView.distribution = .fillEqually
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 2.0
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
            make.trailing.equalTo(earningsStackView.snp.leading)
        }
        
        earningsStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(8)
        }
    }
    
    private func setupLabel(with model: RideHeaderViewModel) {
        // Day
        let attributes = [NSAttributedString.Key.foregroundColor : AppConfiguration.current.theme.defaultColor,
                          NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: AppConfiguration.current.theme.defaultFontSize)]
        let text = NSMutableAttributedString(string: "\(model.day)", attributes: attributes)
        
        let timeFontSize = model.style == .myRides ? AppConfiguration.current.theme.smallerFontSize : AppConfiguration.current.theme.defaultFontSize
        
        // Start Time
        let attributesStartTime = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: timeFontSize)]
        text.append(NSMutableAttributedString(string: " • \(model.startTimeFormatted)", attributes: attributesStartTime))
        
        // End Time
        let attributesEndTime = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: timeFontSize)]
        text.append(NSMutableAttributedString(string: " - \(model.endTimeFormatted)", attributes: attributesEndTime))
        
        label.attributedText = text
    }
    
    private func setupEarnings(with model: RideHeaderViewModel) {
        // Static label
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        
        let attributesEstimated = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: AppConfiguration.current.theme.smallerFontSize),
                                   NSAttributedString.Key.paragraphStyle : paragraphStyle]
        let estimatedEarningsAmountLabelText = NSMutableAttributedString(string: "ESTIMATED", attributes: attributesEstimated)
        estimatedEarningsLabel.attributedText = estimatedEarningsAmountLabelText
        
        // Earnings amount
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        let formattedEarnings = formatter.string(from: model.estimatedEarnings as NSNumber) ?? ""
        
        let fontColor = model.style == .myRides ? AppConfiguration.current.theme.defaultColor : .white
        let font = model.style == .myRides ? UIFont.systemFont(ofSize: AppConfiguration.current.theme.defaultFontSize) : UIFont.boldSystemFont(ofSize: AppConfiguration.current.theme.defaultFontSize)
        let attributesAmount = [NSAttributedString.Key.foregroundColor : fontColor,
                                NSAttributedString.Key.font : font,
                                NSAttributedString.Key.paragraphStyle : paragraphStyle]
        let amountText = NSMutableAttributedString(string: " \(formattedEarnings) ", attributes: attributesAmount)
        
        estimatedEarningsAmountLabel.attributedText = amountText
        
        if model.style == .rideDetails {
            // Setup pill shape
            estimatedEarningsAmountLabel.backgroundColor = AppConfiguration.current.theme.lightBlueColor
            estimatedEarningsAmountLabel.clipsToBounds = true
            estimatedEarningsAmountLabel.layer.masksToBounds = true
            estimatedEarningsAmountLabel.layer.cornerRadius = 10.0
        }
    }
}
