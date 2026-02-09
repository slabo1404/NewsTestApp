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
        let tableNode = ASTableNode(style: .plain)
        tableNode.view.tableFooterView = UIView()
        tableNode.view.backgroundColor = UIColor.white
        tableNode.view.separatorColor = UIColor.gray.withAlphaComponent(0.8)
        tableNode.alpha = 0
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
    
    private let timerView: TimerView = {
        let timerView = TimerView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 80, height: 32)))
        return timerView
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableNode.frame = view.bounds
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: timerView)
    }
    
    func setupUI() {
        view.addSubnode(tableNode)
        view.addSubview(progressView)
        
        progressView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setupViews() {
        timerView.delegate = self
        
        tableNode.dataSource = tableManager
        tableNode.delegate = tableManager
        tableManager.delegate = self
        
        timerView.startTimer(timeLimit: 10)
    }
}

// MARK: - Bindings

private extension NewsViewController {
    func bindToViewModel() {
        viewModel.articlesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] articles in
                self?.tableManager.updateArticles(articles, displayMode: self?.displayMode ?? .normal)
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
                    self?.tableNode.reloadData()
                    
                    UIView.animate(withDuration: 0.3) {
                        self?.tableNode.alpha = 1
                    }
                }
            }
            .store(in: &cancellable)
        
        viewModel.errorMessagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let message else { return }
                
                self?.showAlertControlelr(with: message)
            }
            .store(in: &cancellable)
        
        viewModel.articleChangesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] changes in
                self?.tableNode.performBatchUpdates {
                    if !changes.insertions.isEmpty {
                        self?.tableNode.insertRows(at: changes.insertions, with: .automatic)
                    }

                    if !changes.removals.isEmpty {
                        self?.tableNode.deleteRows(at: changes.removals, with: .automatic)
                    }
                }
            }
            .store(in: &cancellable)
        
        viewModel.updatedArticleIndexPublisher
            .receive(on: DispatchQueue.main)
            .sink { index in
                let indexPath = IndexPath(row: index, section: 0)
                self.tableNode.reloadRows(at: [indexPath], with: .fade)
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

// MARK: - TimerViewDelegate

extension NewsViewController: TimerViewDelegate {
    func timeIsUp() {
        timerView.startTimer(timeLimit: 10)
        
        Task {
            try await viewModel.fetchArticles()
        }
    }
}

// MARK: - NewsTableManagerDelegate

extension NewsViewController: NewsTableManagerDelegate {
    func didSelect(_ article: Article) {
        guard let url = URL(string: article.link) else { return }
        
        viewModel.updateReadingStatus(article: article)
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}

// MARK: - Show Alert

private extension NewsViewController {
    func showAlertControlelr(with message: String) {
        let alert = UIAlertController(
            title: "",
            message: message,
            preferredStyle: .actionSheet
        )

        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}
