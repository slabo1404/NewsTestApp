//
//  SwitcherNode.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 9.02.26.
//

import AsyncDisplayKit

final class SwitcherNode: ASDisplayNode {
    var switcher: UISwitch {
        self.view as! UISwitch
    }

    override init() {
        super.init()

        setViewBlock {
            UISwitch()
        }
    }
}
