//
//  FilterOptionsTableViewDelegate.swift.swift
//  ConcreteApplication
//
//  Created by Bruno Cruz on 02/11/19.
//  Copyright © 2019 Bruno Cruz. All rights reserved.
//

import UIKit

extension FilterOptionsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.05
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let filterParameters = FilterParametersTableViewController(parameters: self.releasedYearsParameters, option: filterOptions[indexPath.row], style: .grouped, delegate: self, selectedParameter: filter.releaseYear ?? "")
            self.navigationController?.pushViewController(filterParameters, animated: true)
        case 1:
            let filterParameters = FilterParametersTableViewController(parameters: self.genresParameters, option: filterOptions[indexPath.row] , style: .grouped, delegate: self, selectedParameter: filter.genre ?? "")
            self.navigationController?.pushViewController(filterParameters, animated: true)
        default:
            break
        }
    }
}
