//
//  SimpleLabelView.swift
//  MyRides
//
//  Created by Anthony Marasia on 1/19/24.
//

import UIKit

struct SimpleLabelViewModel {
    let attributedText: NSAttributedString
    let padding: UIEdgeInsets
}

class SimpleLabelView: UIView {
    private let label = UILabel()
    private var model: SimpleLabelViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with model: SimpleLabelViewModel) {
        self.model = model
        
        label.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(model.padding.top)
            make.bottom.equalToSuperview().offset(model.padding.bottom)
            make.leading.equalToSuperview().offset(model.padding.left)
            make.trailing.equalToSuperview().offset(model.padding.right)
        }
        
        label.attributedText = model.attributedText
    }
}
