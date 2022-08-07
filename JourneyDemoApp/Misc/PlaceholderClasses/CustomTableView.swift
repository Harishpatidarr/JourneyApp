//
//  CustomTableView.swift
//  Mahakaleshwar Ujjain
//
//  Created by Harish Patidar on 14/06/20.
//  Copyright © 2020 Harry Patel. All rights reserved.
//

import Foundation
import HGPlaceholders

class CustomTableView: TableView {

    override func customSetup() {
        placeholdersProvider = .appCustom
    }
}
