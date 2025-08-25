//
//  Untitled.swift
//  SomuYadavDemo
//
//  Created by Somendra Yadav on 25/08/25.
//

import UIKit

class TagLabelView: UIView {
    
    // MARK: - Properties
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 8)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        layer.cornerRadius = 4
        clipsToBounds = true
        
        addSubview(textLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }
    
    // MARK: - Public Methods
    
    func setText(_ text: String) {
        textLabel.text = text
    }
}

#if DEBUG
extension TagLabelView {
    var testHooks: TestHooks { TestHooks(target: self) }
    struct TestHooks {
        private let target: TagLabelView
        fileprivate init(target: TagLabelView) { self.target = target }
        func set(text: String) { target.setText(text) }
    }
}
#endif
