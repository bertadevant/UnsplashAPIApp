//
//  SearchBarView.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 20/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import UIKit

protocol SearchDelegate: class {
    func searchQuery(_ query: String)
}

class SearchBarView: UIView {
    weak var delegate: SearchDelegate?
    
    private var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.barStyle = .default
        bar.barTintColor = Color.darkGray
        bar.tintColor = Color.lightGray
        bar.backgroundImage = UIImage()
        bar.textField?.backgroundColor = Color.lightGray
        bar.textField?.textColor = Color.darkGray
        return bar
    }()
    
    private var stackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        view.axis = .horizontal
        view.spacing = 8
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This view is not designed to be used with xib or storyboard files")
    }
    
    func setSearchBar(with categories: [SearchCategory]) {
        for category in categories {
            let button = UIButton()
            button.setTitle(category.name, for: .normal)
            button.setTitleColor(Color.darkGray, for: .normal)
            button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc func categoryButtonTapped(_ sender: UIButton) {
        guard let searchText = sender.currentTitle else {
            return
        }
        delegate?.searchQuery(searchText)
    }
    
    private func setup() {
        backgroundColor = .clear
        searchBar.delegate = self
        addSubview(searchBar)
        addSubview(stackView)
        setupLayout()
        stackView.setShadowForView()
        searchBar.setBorder()
        self.setBorder()
    }
    
    private func setupLayout() {
        searchBar.pinToSuperview(edges: [.top, .left, .right], constant: 8)
        stackView.pinToSuperview(edges: [.left, .right], constant: 8)
        stackView.pinToSuperviewBottom(constant: 8)
        stackView.pin(edge: .top, to: .bottom, of: searchBar, constant: 8)
    }
}

extension SearchBarView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        delegate?.searchQuery(searchText)
    }
}

private extension UIView {
    func setShadowForView() {
        self.layer.shadowColor = Color.darkGray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func setBorder() {
        self.layer.borderColor = Color.lightGray.cgColor
        self.layer.borderWidth = 0.2
    }
}

private extension UISearchBar {
    var textField: UITextField? {
        return subviews.first?.subviews.first(where: { $0.isKind(of: UITextField.self) }) as? UITextField
    }
}
