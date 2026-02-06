//
//  NewsViewController.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 6.02.26.
//


import AsyncDisplayKit
import Combine
import SafariServices
import SnapKit
import UIKit


final class NewsViewController: UIViewController {
    // MARK: - Nodes
    
    private let tableNode: ASTableNode = {
        let tableNode = ASTableNode(style: .grouped)
        tableNode.view.tableFooterView = UIView()
        tableNode.view.backgroundColor = UIColor.white
        tableNode.view.separatorColor = UIColor.gray
        tableNode.alpha = 0
        tableNode.view.register(
            TitleHeaderView.self,
            forHeaderFooterViewReuseIdentifier: TitleHeaderView.identifier
        )
        
        return tableNode
    }()
    
    // MARK: - Views
    
    private let progressView: UIActivityIndicatorView = {
        let progressView = UIActivityIndicatorView()
        progressView.style = .medium
        progressView.color = UIColor.black
        progressView.hidesWhenStopped = true
        return progressView
    }()
    
    // MARK: - Private properties
    
    private let viewModel: INewsViewModel
    private let tableManager = NewsTableManager()
    private var cancellable = Set<AnyCancellable>()
    private var displayMode: DisplayMode = .normal
    
    init(viewModel: INewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifesycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupUI()
        setupViews()
        bindToViewModel()
        
        Task {
            try await viewModel.fetchArticles()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableNode.frame = CGRect(origin: CGPoint.zero, size: view.frame.size)
    }
}

// MARK: - UI

private extension NewsViewController {
    func setupNavigationBar() {
        navigationItem.title = "Новости"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.clockwise"),
            style: .plain,
            target: self,
            action: #selector(didChangeLayout))
    }
    
    func setupUI() {
        view.addSubnode(tableNode)
        view.addSubview(progressView)
        
        progressView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setupViews() {
        tableNode.dataSource = tableManager
        tableNode.delegate = tableManager
        tableManager.delegate = self
    }
}

// MARK: - Bindings

private extension NewsViewController {
    func bindToViewModel() {
        viewModel.articlesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] articles in
                self?.tableManager.updateArticles(articles, displayMode: self?.displayMode ?? .normal)
                self?.tableNode.reloadData()
            }
            .store(in: &cancellable)
        
        viewModel.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.progressView.startAnimating()
                    self?.tableNode.alpha = 0
                } else {
                    self?.progressView.stopAnimating()
                    
                    UIView.animate(withDuration: 0.3) {
                        self?.tableNode.alpha = 1
                    }
                }
            }
            .store(in: &cancellable)
    }
}

// MARK: - Events

private extension NewsViewController {
    @objc func didChangeLayout() {
        displayMode = displayMode == .normal ? DisplayMode.expanded : DisplayMode.normal
        tableManager.updateDisplayMode(displayMode)
        tableNode.reloadData()
    }
}

// MARK: - NewsTableManagerDelegate

extension NewsViewController: NewsTableManagerDelegate {
    func didSelect(_ article: Article) {
        guard let url = URL(string: article.link) else { return }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}
