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
        bar.backgroundImage = UIImage()
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
            button.tintColor = Color.darkGray
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
        searchBar.delegate = self
        searchBar.barTintColor = Color.lightGray
        addSubview(searchBar)
        addSubview(stackView)
        setupLayout()
    }
    
    private func setupLayout() {
        searchBar.pinToSuperview(edges: [.top, .left, .right])
        stackView.pinToSuperview(edges: [ .bottom, .left, .right])
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
