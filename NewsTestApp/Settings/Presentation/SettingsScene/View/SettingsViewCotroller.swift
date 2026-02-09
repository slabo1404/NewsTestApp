//
//  SettingsViewCotroller.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 9.02.26.
//

import AsyncDisplayKit
import Combine
import SafariServices
import UIKit

final class SettingsViewCotroller: UIViewController {
    // MARK: - Nodes
    
    private let tableNode: ASTableNode = {
        let tableNode = ASTableNode(style: .insetGrouped)
        tableNode.view.tableFooterView = UIView()
        tableNode.view.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        tableNode.view.separatorColor = UIColor.gray.withAlphaComponent(0.3)
        return tableNode
    }()
    
    // MARK: - Private properties
    
    private let viewModel: ISettingsViewModel
    private let tableManager = SettingsTableManager()
    private var cancellable = Set<AnyCancellable>()
    
    init(viewModel: ISettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifesycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupViews()
        bindToViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableNode.frame = view.bounds
    }
}

// MARK: - UI

private extension SettingsViewCotroller {
    func setupUI() {
        navigationItem.title = "Настройки"
        view.addSubnode(tableNode)
    }
    
    func setupViews() {
        tableNode.dataSource = tableManager
        tableNode.delegate = tableManager
        tableManager.delegate = self
    }
}

// MARK: - Bindings

private extension SettingsViewCotroller {
    func bindToViewModel() {
        viewModel.settingsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] settings in
                self?.tableManager.updateSettings(settings)
                self?.tableNode.reloadData()
            }
            .store(in: &cancellable)
    }
}

// MARK: - NewsTableManagerDelegate

extension SettingsViewCotroller: SettingsTableManagerDelegate {
    func didSelect(_ setting: AppSetting) {
        if setting.type == .timerIntervar {
            showChooserViewController(
                values: viewModel.defaultTimeIntervals,
                selectedValues: ["\(SharedPreferences.timerInterval)"],
                allowMultipleSelection: false,
                title: "Выберите новостной источник") { [weak self] values in
                    let selectedValue = values.first.orEmpty
                    
                    if let intValue = Int(selectedValue) {
                        SharedPreferences.timerInterval = intValue
                        self?.viewModel.updateTimerInterval(value: intValue)
                    } else {
                        SharedPreferences.timerInterval = 0
                        self?.viewModel.updateTimerInterval(value: 0)
                    }
                }
            
        } else if setting.type == .newsSource {
            showChooserViewController(
                values: ArticleSource.allCases.map { $0.rawValue },
                selectedValues: SharedPreferences.selectedSources,
                allowMultipleSelection: true,
                title: "Выберите интервал обновления") {
                    SharedPreferences.selectedSources = $0
                }
        }
    }
    
    func didChangeSwitcherValue(_ value: Bool, for setting: AppSetting) {
        if setting.type == .useImageCache {
            viewModel.updateUseImageCache(value: value)
        } else if setting.type == .showDescription {
            viewModel.updateShowDescription(value: value)
        }
    }
}

// MARK: - Show Chooser scene

private extension SettingsViewCotroller {
    func showChooserViewController(values: [String], selectedValues: [String], allowMultipleSelection: Bool, title: String, updatedValues: @escaping (([String]) -> Void)) {
        
        let chooserViewController = ChooserViewController(
            values: values,
            selectedValues: selectedValues,
            allowMultipleSelection: allowMultipleSelection,
            title: title
        )
        
        chooserViewController.updatedSelectedValues = {
            updatedValues($0)
        }
        
        navigationController?.pushViewController(chooserViewController, animated: true)
    }
}
