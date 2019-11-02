//
//  FilterOptionsTableViewDataSource.swift
//  ConcreteApplication
//
//  Created by Bruno Cruz on 02/11/19.
//  Copyright © 2019 Bruno Cruz. All rights reserved.
//

import UIKit

extension FilterOptionsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var parameter = ""
        switch indexPath.row {
        case 0:
            parameter = filter.releaseYear ?? ""
        case 1:
            parameter = filter.genre ?? ""
        default:
            parameter = ""
        }
        
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: FilterTableViewCell.self)
        cell.setupOption(with: filterOptions[indexPath.row].rawValue, parameter: parameter)
        
        return cell
    }
}
