//
//  NewsListController.swift
//  TucanNews
//
//  Created by Illia Wezarino on 13.09.2022.
//

import UIKit

final class NewsListController: UIViewController {
    
    private var dictionaryImageCache: Dictionary<String, UIImage> = [String:UIImage]()
    private let tableView = UITableView()
    private var newsList: NewsResponseObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        setupNavbar()
        
        getData()
    }
    
}

private extension NewsListController {
    
    private func setupNavbar() {
        let navBar = self.navigationController?.navigationBar
        navBar?.barStyle = .black
        navBar?.tintColor = .white
        navBar?.isTranslucent = false
        navBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white ]
        title = "Туканные Новости"
    }
    
    
    private func setupSubviews() {
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewsListCell.self, forCellReuseIdentifier: "cell")
        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

extension NewsListController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let newsList = newsList else {return}
        let vc = NewsDetailsController(with: (image: newsList.news[indexPath.row].image, title: newsList.news[indexPath.row].title, date: newsList.news[indexPath.row].date, teaser: newsList.news[indexPath.row].teaser, text: newsList.news[indexPath.row].text))
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList?.news.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        (cell as? NewsListCell)?.setData(title: newsList?.news[indexPath.row].title ?? "", date: newsList?.news[indexPath.row].date ?? "", teaser: newsList?.news[indexPath.row].teaser ?? "", image: newsList?.news[indexPath.row].image ?? "")
        
        return cell
    }
    
    private func getData() {
        Request.NetworkManager.fire { [weak self] newsList in
            self?.newsList = newsList
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
    }
    
}

// MARK: - NewsListCell Controller

final class NewsListCell: UITableViewCell {
    
    private let cellImageView = CustomImageView()
    private let cellTitleLabel = UILabel()
    private let cellDateLabel = UILabel()
    private let cellTeaserLabel = UILabel()
    private let viewElements = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupSubviews() {
        contentView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        
        viewElements.backgroundColor = .white
        viewElements.layer.shadowColor = UIColor.black.cgColor
        viewElements.layer.shadowOpacity = 0.2
        viewElements.layer.shadowOffset = .zero
        viewElements.layer.shadowRadius = 4
        contentView.addSubview(viewElements)
        
        cellImageView.contentMode = .scaleAspectFill
        cellImageView.clipsToBounds = true
        contentView.addSubview(cellImageView)
        
        cellTitleLabel.numberOfLines = 0
        cellTitleLabel.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        cellTitleLabel.textColor = .black
        contentView.addSubview(cellTitleLabel)
        
        cellDateLabel.numberOfLines = 1
        cellDateLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        cellDateLabel.textColor = UIColor.black.withAlphaComponent(0.4)
        contentView.addSubview(cellDateLabel)
        
        cellTeaserLabel.numberOfLines = 0
        cellTeaserLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        cellTeaserLabel.textColor = UIColor.black.withAlphaComponent(0.7)
        contentView.addSubview(cellTeaserLabel)
        
        contentView.subviews.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setData(title: String, date: String, teaser: String, image: String) {
        cellTitleLabel.text = title
        cellDateLabel.text = date
        cellTeaserLabel.text = teaser
        cellImageView.downloadImageFrom(urlString: image, imageMode: .scaleAspectFill)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) { selectionStyle = .none }
    
    func addConstraints() {
        NSLayoutConstraint.activate([ viewElements.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
                                      viewElements.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
                                      viewElements.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
                                      viewElements.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
                                      
                                      cellImageView.topAnchor.constraint(equalTo: viewElements.topAnchor, constant: 0),
                                      cellImageView.leadingAnchor.constraint(equalTo: viewElements.leadingAnchor, constant: 0),
                                      cellImageView.heightAnchor.constraint(equalToConstant: 190),
                                      cellImageView.trailingAnchor.constraint(equalTo: viewElements.trailingAnchor, constant: 0),
                                      
                                      cellTitleLabel.topAnchor.constraint(equalTo: cellImageView.bottomAnchor, constant: 14),
                                      cellTitleLabel.leadingAnchor.constraint(equalTo: viewElements.leadingAnchor, constant: 20),
                                      cellTitleLabel.trailingAnchor.constraint(equalTo: viewElements.trailingAnchor, constant: -20),
                                      
                                      cellDateLabel.topAnchor.constraint(equalTo: cellTitleLabel.bottomAnchor, constant: 8),
                                      cellDateLabel.leadingAnchor.constraint(equalTo: viewElements.leadingAnchor, constant: 20),
                                      cellDateLabel.trailingAnchor.constraint(equalTo: viewElements.trailingAnchor, constant: -20),
                                      
                                      cellTeaserLabel.topAnchor.constraint(equalTo: cellDateLabel.bottomAnchor, constant: 8),
                                      cellTeaserLabel.leadingAnchor.constraint(equalTo: viewElements.leadingAnchor, constant: 20),
                                      cellTeaserLabel.bottomAnchor.constraint(equalTo: viewElements.bottomAnchor, constant: -20),
                                      cellTeaserLabel.trailingAnchor.constraint(equalTo: viewElements.trailingAnchor, constant: -20)
                                      
                                    ])
    }
    
}
