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
    private var searchCategories: [SearchCategory] = []
    
    private var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.barStyle = .default
        bar.barTintColor = Colors.darkGray
        bar.tintColor = Colors.darkGray
        bar.backgroundImage = UIImage()
        bar.textField?.backgroundColor = Colors.lightGray
        bar.textField?.textColor = Colors.darkGray
        return bar
    }()
    
    private var categoryView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private var categoryScrollView: UIScrollView = {
        let view = UIScrollView()
        return view
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
        self.searchCategories = categories
        for category in categories {
            let button = UIButton()
            button.setTitle(category.name, for: .normal)
            button.setTitleColor(Colors.darkGray, for: .normal)
            button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc func categoryButtonTapped(_ sender: UIButton) {
        guard let searchText = sender.currentTitle else {
            return
        }
        let categories = searchCategories.filter{ $0.name == searchText }
        guard let category = categories.first else {
            return
        }
        delegate?.searchQuery(category.query)
    }
    
    private func setup() {
        backgroundColor = .clear
        searchBar.delegate = self
        addSubview(searchBar)
        categoryScrollView.addSubview(stackView)
        categoryView.addSubview(categoryScrollView)
        addSubview(categoryView)
        setupLayout()
        categoryScrollView.setBorder()
        searchBar.setBorder()
    }
    
    private func setupLayout() {
        searchBar.pinToSuperview(edges: [.top, .left, .right], constant: 8)
        stackView.pinToSuperviewEdges()
        categoryScrollView.pinToSuperviewEdges(constant: 8)
        categoryView.pinToSuperview(edges: [.left, .right])
        categoryView.pinToSuperviewBottom()
        let estimatedHeight = "testText".estimateHeightForText(width: 50)
        categoryView.addHeightConstraint(with: estimatedHeight + 16)
        categoryView.pin(edge: .top, to: .bottom, of: searchBar, constant: 8)
    }
}

extension SearchBarView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        searchBar.endEditing(true)
        delegate?.searchQuery(searchText)
    }
}

private extension UIView {
    func setShadowForView() {
        self.layer.shadowColor = Colors.darkGray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func setBorder() {
        self.layer.borderColor = Colors.lightGray.cgColor
        self.layer.borderWidth = 0.2
    }
}

private extension UISearchBar {
    var textField: UITextField? {
        return subviews.first?.subviews.first(where: { $0.isKind(of: UITextField.self) }) as? UITextField
    }
}

private extension String {
    func estimateHeightForText(width: CGFloat, font: UIFont = Fonts.regular) -> CGFloat {
        let height: CGFloat = 50
        let size = CGSize(width: width, height: height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        return NSString(string: self).boundingRect(with: size, options: options, attributes: attributes, context: nil).height
    }

}

