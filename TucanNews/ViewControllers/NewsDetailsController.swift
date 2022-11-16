//
//  NewsDetailsController.swift
//  TucanNews
//
//  Created by Illia Wezarino on 13.09.2022.
//

import UIKit

final class NewsDetailsController: UIViewController {
    
    private var object: (image: String, title: String, date: String, teaser: String, text: String)?
    
    private let backgroundImageView = CustomImageView()
    private let backgroundBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private let topBarBlurView = UIVisualEffectView(effect: nil)
    private let imageView = CustomImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let textLabel = UILabel()
    private let scrollView = UIScrollView()
    private let viewElem = UIView()
    
    private var shouldAnimateTopbarAppearance = true
    private var viewDidAppearOnScreen = false
    
    init(with object: (image: String, title: String, date: String, teaser: String, text: String)) {
        super.init(nibName: nil, bundle: nil)
        self.object = object
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        object = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addConstraints()
        setupNavbarOnShow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setupNavbarOnHide()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidAppearOnScreen = true
    }
    
}

private extension NewsDetailsController {
    
    private func setupNavbarOnShow() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        title = "Интересная Новость"
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupNavbarOnHide() {
        let navBar = self.navigationController?.navigationBar
        navBar?.tintColor = UIColor.white
        navBar?.isTranslucent = false
        navBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navBar?.barStyle = .black
    }
    
    private func setupSubviews() {
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.downloadImageFrom(urlString: object?.image ?? "", imageMode: .scaleAspectFill)
        backgroundImageView.clipsToBounds = true
        view.addSubview(backgroundImageView)
        view.addSubview(topBarBlurView)
        view.addSubview(backgroundBlurView)
        
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        view.addSubview(viewElem)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.2
        imageView.layer.shadowOffset = .zero
        imageView.layer.shadowRadius = 4
        imageView.downloadImageFrom(urlString: object?.image ?? "", imageMode: .scaleAspectFill)
        viewElem.addSubview(imageView)
        
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.text = object?.title
        viewElem.addSubview(titleLabel)
        
        dateLabel.numberOfLines = 1
        dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        dateLabel.textColor = UIColor.white.withAlphaComponent(0.4)
        dateLabel.text = (object?.date ?? "Без даты").uppercased()
        viewElem.addSubview(dateLabel)
        
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        textLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        textLabel.text = object?.text
        
        viewElem.addSubview(textLabel)
        
        view.subviews.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        viewElem.subviews.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func showTopBar() {
        if shouldAnimateTopbarAppearance && viewDidAppearOnScreen {
            UIView.animate(withDuration: 0.25) {
                self.shouldAnimateTopbarAppearance = false
                self.topBarBlurView.effect = UIBlurEffect(style: .dark)
                self.view.layoutIfNeeded()
            } completion: { completed in
                if completed {
                    self.shouldAnimateTopbarAppearance = true
                }
            }
        }
    }
    
    private func hideTopBar() {
        if shouldAnimateTopbarAppearance && viewDidAppearOnScreen {
            UIView.animate(withDuration: 0.25) {
                self.shouldAnimateTopbarAppearance = false
                self.topBarBlurView.effect = nil
                self.view.layoutIfNeeded()
            } completion: { completed in
                if completed {
                    self.shouldAnimateTopbarAppearance = true
                }
            }
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                                     backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                                     backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
                                     backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
                                     
                                     backgroundBlurView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                                     backgroundBlurView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                                     backgroundBlurView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
                                     backgroundBlurView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
                                     
                                     scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                                     scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
                                     scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
                                     scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
                                     
                                     viewElem.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
                                     viewElem.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 14),
                                     viewElem.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
                                     viewElem.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -14),
                                     
                                     imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     imageView.leadingAnchor.constraint(equalTo: viewElem.leadingAnchor, constant: -14),
                                     imageView.trailingAnchor.constraint(equalTo: viewElem.trailingAnchor, constant: 14),
                                     imageView.heightAnchor.constraint(equalToConstant: 250),
                                     
                                     titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 14),
                                     titleLabel.leadingAnchor.constraint(equalTo: viewElem.leadingAnchor, constant: 0),
                                     titleLabel.trailingAnchor.constraint(equalTo: viewElem.trailingAnchor, constant: 0),
                                     
                                     dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
                                     dateLabel.leadingAnchor.constraint(equalTo: viewElem.leadingAnchor, constant: 0),
                                     dateLabel.trailingAnchor.constraint(equalTo: viewElem.trailingAnchor, constant: 0),
                                     
                                     textLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
                                     textLabel.leadingAnchor.constraint(equalTo: viewElem.leadingAnchor, constant: 0),
                                     textLabel.trailingAnchor.constraint(equalTo: viewElem.trailingAnchor, constant: 0),
                                     
                                     topBarBlurView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                                     topBarBlurView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                                     topBarBlurView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
                                     topBarBlurView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
                                    ])
    }
}
