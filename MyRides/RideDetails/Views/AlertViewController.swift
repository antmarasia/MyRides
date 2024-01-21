//
//  AlertViewController.swift
//  MyRides
//
//  Created by Anthony Marasia on 1/20/24.
//

import UIKit

struct AlertViewModel {
    let title: String
    let titleStyle: TextStyle
    let subtitle: String
    let subtitleStyle: TextStyle
    let primaryButtonStyle: ButtonStyle
    let secondaryButtonStyle: ButtonStyle
    // Not limiting the number of buttons but if you add more than can fit on screen
    // then you should rethink if an alert dialog is right view for the job
    let buttons: [AlertButton]
}

struct TextStyle {
    let textColor: UIColor
    let font: UIFont?
    let textAlignment: NSTextAlignment?
}

struct ButtonStyle {
    let backgroundColor: UIColor
    let cornerRadius: CGFloat?
    let textStyle: TextStyle
}

struct AlertButton {
    let text: String
    let isPrimary: Bool
}

class AlertViewController: UIViewController {
    let model: AlertViewModel
    
    private let buttonStackView = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let closeButton = UIButton()
    
    init(model: AlertViewModel) {
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCloseButton()
        setupTitleLabels()
        setupActionButtons()
    }
    
    private func setupCloseButton() {
        view.addSubview(closeButton)
        
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.tintColor = .black
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.width.equalTo(48)
        }
    }
    
    private func setupTitleLabels() {
        view.addSubview(titleLabel)
        style(label: titleLabel, with: model.titleStyle)
        titleLabel.text = model.title
        
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).inset(16)
            make.leading.equalToSuperview().inset(32)
            make.trailing.equalToSuperview().inset(32)
        }
        
        view.addSubview(subtitleLabel)
        style(label: subtitleLabel, with: model.subtitleStyle)
        subtitleLabel.text = model.subtitle
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-16)
            make.leading.equalToSuperview().inset(32)
            make.trailing.equalToSuperview().inset(32)
        }
    }
    
    private func setupActionButtons() {
        view.addSubview(buttonStackView)
        buttonStackView.axis = .vertical
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).inset(-16)
            make.leading.equalToSuperview().inset(32)
            make.trailing.equalToSuperview().inset(32)
            make.bottom.equalToSuperview().inset(32)
        }
        
        for alertButton in model.buttons {
            let button = UIButton()
            button.setTitle(alertButton.text, for: .normal)
            button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
            style(button: button, with: alertButton.isPrimary ? model.primaryButtonStyle : model.secondaryButtonStyle)
            
            buttonStackView.addArrangedSubview(button)
            
            button.snp.makeConstraints { make in
                make.height.equalTo(48)
            }
        }
    }
    
    private func style(button: UIButton, with style: ButtonStyle) {
        button.backgroundColor = style.backgroundColor
        
        button.setTitleColor(style.textStyle.textColor, for: .normal)
        
        if let label = button.titleLabel {
            self.style(label: label, with: style.textStyle)
        }
        
        if let cornerRadius = style.cornerRadius {
            button.layer.cornerRadius = cornerRadius
        }
    }
    
    private func style(label: UILabel, with style: TextStyle) {
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = style.textColor
        
        if let textAlignment = style.textAlignment {
            label.textAlignment = textAlignment
        }
        
        if let font = style.font {
            label.font = font
        }
    }
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true)
    }
}
