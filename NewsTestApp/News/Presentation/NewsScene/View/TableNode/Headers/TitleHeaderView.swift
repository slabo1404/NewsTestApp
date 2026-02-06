//
//  TitleHeaderView.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 6.02.26.
//

import SnapKit
import UIKit

final class TitleHeaderView: UITableViewHeaderFooterView {
    // MARK: - Properties

    static let identifier: String = String(describing: TitleHeaderView.self)

    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = UIColor.black
        return label
    }()

    var title = "" {
        didSet {
            headerTitleLabel.text = title
        }
    }

    // MARK: - Overridden

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Config

    private func setupUI() {
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(headerTitleLabel)

        headerTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
}
