//
//  NewsViewController.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 6.02.26.
//

import AsyncDisplayKit
import Combine
import SafariServices
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
    
    private lazy var footerView: UIView = {
        let view = UIView(
            frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 280)
        )
        view.backgroundColor = UIColor.white
        
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.text = "Хороших новостей пока нет"
        
        view.addSubview(label)
        label.frame = view.bounds
        
        return view
    }()
    
    private let timerView: TimerView = {
        let timerView = TimerView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 80, height: 32)))
        return timerView
    }()
    
    private lazy var leftBarTimerView: UIBarButtonItem = {
        return UIBarButtonItem(customView: timerView)
    }()
    
    // MARK: - Private properties
    
    private let viewModel: INewsViewModel
    private let tableManager = NewsTableManager()
    private var cancellable = Set<AnyCancellable>()
    
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
        addUpdateNewsObserver()
        startTimerIfNeeded()
        
        Task {
            try await viewModel.fetchArticles()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableNode.frame = view.bounds
        progressView.center = view.center
    }
}

// MARK: - UI

private extension NewsViewController {
    func setupNavigationBar() {
        navigationItem.title = "Новости"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "inset.filled.topthird.middlethird.bottomthird.rectangle"),
            style: .plain,
            target: self,
            action: #selector(changeLayout))
    }
    
    func setupUI() {
        view.addSubnode(tableNode)
        view.addSubview(progressView)
    }
    
    func setupViews() {
        timerView.delegate = self
        
        tableNode.dataSource = tableManager
        tableNode.delegate = tableManager
        tableManager.delegate = self
    }
    
    func startTimerIfNeeded() {
        let timerInterval = SharedPreferences.timerInterval
        
        guard timerInterval > 0 else {
            navigationItem.leftBarButtonItem = nil
            timerView.stopTimer()
            return
        }
        
        if navigationItem.leftBarButtonItem == nil {
            navigationItem.leftBarButtonItem = leftBarTimerView
        }
        
        timerView.startTimer(timeLimit: TimeInterval(timerInterval))
    }
    
    func addUpdateNewsObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUpdateNews(notification:)),
            name: .updateNews,
            object: nil
        )
    }
}

// MARK: - Bindings

private extension NewsViewController {
    func bindToViewModel() {
        viewModel.articlesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] articles in
                self?.tableNode.view.tableFooterView = articles.isEmpty ? self?.footerView : nil
                
                self?.tableManager.updateArticles(
                    articles,
                    showDescription: SharedPreferences.showDescription,
                    useImageCache: SharedPreferences.usеImageCache
                )
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
                
                self?.showAlertController(with: message)
            }
            .store(in: &cancellable)
        
        viewModel.articleChangesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] changes in
                self?.tableNode.performBatchUpdates {
                    if !changes.insertions.isEmpty {
                        self?.tableNode.insertRows(at: changes.insertions, with: .fade)
                    }
                    
                    if !changes.removals.isEmpty {
                        self?.tableNode.deleteRows(at: changes.removals, with: .fade)
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
    @objc func handleUpdateNews(notification: Notification) {
        let showDescription = SharedPreferences.showDescription
        let usеImageCache = SharedPreferences.usеImageCache
        
        tableManager.updateShowDesription(showDescription)
        tableManager.updateUseImagecache(usеImageCache)
        tableNode.reloadData()
        
        Task {
            try await viewModel.fetchArticles()
        }
        
        startTimerIfNeeded()
    }
    
    @objc func changeLayout() {
        let showDescription = SharedPreferences.showDescription
        
        SharedPreferences.showDescription = !showDescription
        tableManager.updateShowDesription(!showDescription)
        tableNode.reloadData()
    }
}

// MARK: - TimerViewDelegate

extension NewsViewController: TimerViewDelegate {
    func timeIsUp() {
        Task {
            try await viewModel.fetchArticles()
        }
        
        startTimerIfNeeded()
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
    func showAlertController(with message: String) {
        let alert = UIAlertController(
            title: "",
            message: message,
            preferredStyle: .actionSheet
        )
        
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okAction)
        
        safePresent(alert, animated: true)
    }
}
