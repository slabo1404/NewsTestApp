//
//  SettingsTableManager.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 9.02.26.
//

import AsyncDisplayKit

protocol SettingsTableManagerDelegate: AnyObject {
    func didSelect(_ setting: AppSetting)
    func didChangeSwitcherValue(_ value: Bool, for setting: AppSetting)
}

final class SettingsTableManager: NSObject {
    private var settings = [AppSetting]()
    
    weak var delegate: SettingsTableManagerDelegate?
    
    func updateSettings(_ settings: [AppSetting]) {
        self.settings = settings
    }
}

// MARK: - ASTableDataSource

extension SettingsTableManager: ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        settings.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let setting = settings[indexPath.row]
        
        if setting.action == .select {
            var value: String = ""
            
            if setting.type == .timerIntervar {
                value = setting.value == 0 ? "Выкл" : "\(setting.value) сек"
            }
            
            return {
                return SettingSelectionCellNode(
                    title: setting.title,
                    value: value
                )
            }
        }
        
        return {
            let switcherCell = SettingSwitcherCellNode(
                title: setting.title,
                isOn: setting.value == 1 ? true : false)
            
            switcherCell.changeValue = { [weak self] isOn in
                self?.delegate?.didChangeSwitcherValue(isOn, for: setting)
            }
        
            return switcherCell
        }
    }
}

// MARK: - ASTableDelegate

extension SettingsTableManager: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let setting = settings[indexPath.row]
        
        guard setting.action == .select else { return }
        
        delegate?.didSelect(setting)
    }
    
    func tableNode(_ tableNode: ASTableNode, didHighlightRowAt indexPath: IndexPath) {
        guard settings[indexPath.row].action == .select else { return }
        
        let node = tableNode.nodeForRow(at: indexPath)
        node?.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
    }
    
    func tableNode(_ tableNode: ASTableNode, didUnhighlightRowAt indexPath: IndexPath) {
        guard settings[indexPath.row].action == .select else { return }
        
        let node = tableNode.nodeForRow(at: indexPath)
        node?.backgroundColor = UIColor.white
    }
}
