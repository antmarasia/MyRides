//
//  AddressListView.swift
//  MyRides
//
//  Created by Anthony Marasia on 1/20/24.
//

import UIKit

struct AddressListViewModel {
    let isAnchor: Bool
    let address: String?
}

class AddressListView: UIView {
    private let iconImageView = UIImageView()
    private let addressLabel = UILabel()
    private let typeLabel = UILabel()
    private let labelStackView = UIStackView()
    private var model: AddressListViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(iconImageView)
        addSubview(labelStackView)
        
        labelStackView.axis = .vertical
        labelStackView.addArrangedSubview(typeLabel)
        labelStackView.addArrangedSubview(addressLabel)
        
        addressLabel.lineBreakMode = .byWordWrapping
        addressLabel.numberOfLines = 0
        
        iconImageView.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(8)
            make.trailing.equalTo(labelStackView.snp.leading).offset(-8)
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
        
        labelStackView.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.trailing.equalToSuperview()
        }
        
        layer.borderWidth = 1.0
        layer.borderColor = AppConfiguration.current.theme.greyColor.cgColor
    }
    
    func update(with model: AddressListViewModel) {
        self.model = model
        
        // Icon ImageView
        let imageName = model.isAnchor ? "suit.diamond.fill" : "circle.fill"
        iconImageView.image = UIImage(systemName: imageName)
        iconImageView.tintColor = AppConfiguration.current.theme.lightBlueColor
        
        // Type label
        typeLabel.text = model.isAnchor ? "Pickup" : "Drop-off"
        typeLabel.font = UIFont.boldSystemFont(ofSize: AppConfiguration.current.theme.defaultFontSize)
        typeLabel.textColor = AppConfiguration.current.theme.greyColor
        
        // Address label
        addressLabel.text = model.address
        addressLabel.font = UIFont.systemFont(ofSize: AppConfiguration.current.theme.defaultFontSize)
        addressLabel.textColor = AppConfiguration.current.theme.greyColor
    }
}
