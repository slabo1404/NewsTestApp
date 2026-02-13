//
//  ChooserViewController.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 9.02.26.
//

import AsyncDisplayKit

final class ChooserViewController: UIViewController {
    // MARK: - Nodes
    
    private let tableNode: ASTableNode = {
        let tableNode = ASTableNode(style: .insetGrouped)
        tableNode.view.tableFooterView = UIView()
        tableNode.view.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        tableNode.view.separatorColor = UIColor.gray.withAlphaComponent(0.3)
        tableNode.view.tableFooterView = UIView()
        return tableNode
    }()
    
    // MARK: - Private properties
    
    private let tableManager: ChooserTableManager
    private var navigationTitle: String
    
    // MARK: - Internal properties
    
    var updatedSelectedValues: (([String]) -> Void)?
    
    // MARK: - Inits
    
    init(values: [String], selectedValues: [String], allowMultipleSelection: Bool, title: String) {
        self.tableManager = ChooserTableManager(
            values: values,
            selectedValues: selectedValues,
            allowMultipleSelection: allowMultipleSelection)
        
        self.navigationTitle = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableNode.frame = view.bounds
    }
}

// MARK: - UI

private extension ChooserViewController {
    func setupUI() {
        navigationItem.title = navigationTitle
        view.backgroundColor = UIColor.white
        view.addSubnode(tableNode)
    }
    
    func setupViews() {
        tableNode.dataSource = tableManager
        tableNode.delegate = tableManager
        tableManager.delegate = self
    }
}

// MARK: - ChooseArticleSourceTableDelegate

extension ChooserViewController: ChooserTableManagerDelegate {
    func updateSelected(_ sources: [String]) {
        updatedSelectedValues?(sources)
        tableNode.reloadData()
    }
}
