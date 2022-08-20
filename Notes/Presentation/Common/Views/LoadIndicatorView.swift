//
//  LoadIndicatorView.swift
//  Notes
//
//  Created by Danylo Safronov on 20.08.2022.
//

import UIKit

final class LoadIndicatorView: UIView {
    private lazy var textLabel = UILabel()
    private lazy var activityIndicatorView = UIActivityIndicatorView()
    private lazy var contentLayoutGuide = UILayoutGuide()
    
    var text: String = "" {
        didSet {
            setupTextLabelText(text)
        }
    }
    
    var loading: Bool = false {
        didSet {
            setupActivityIndicatorViewAnimation(loading)
        }
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupContentLayoutGuide()
        setupActivityIndicatorView()
        setupTextLabel()
    }
    
    private func setupContentLayoutGuide() {
        addLayoutGuide(contentLayoutGuide)
        
        NSLayoutConstraint.activate([
            contentLayoutGuide.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentLayoutGuide.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    private func setupActivityIndicatorView() {
        addSubview(activityIndicatorView)
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicatorView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: contentLayoutGuide.centerXAnchor),
        ])
    }
    
    private func setupTextLabel() {
        addSubview(textLabel)
        
        textLabel.font = .systemFont(ofSize: 18.0, weight: .medium)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: activityIndicatorView.bottomAnchor, constant: 8.0),
            textLabel.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),
            textLabel.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
        ])
    }
    
    private func setupTextLabelText(_ text: String) {
        textLabel.text = text
    }
    
    private func setupActivityIndicatorViewAnimation(_ state: Bool) {
        state ? activityIndicatorView.startAnimating() : activityIndicatorView.stopAnimating()
    }
}
