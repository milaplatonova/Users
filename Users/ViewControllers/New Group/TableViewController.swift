//
//  TableViewController.swift
//  Users
//
//  Created by Lyudmila Platonova on 26.05.21.
//

import UIKit
import Alamofire

class TableViewController: SearchViewController {
    
    @IBOutlet weak var usersTableView: UITableView!
    
    let users: [User] = Singleton.instance.users.sorted { $0.fullName < $1.fullName }
    lazy var filteredUsers: [User] = []
    var sections: [Section] = []
    var groupedDictionary: [String : [User]] = [:]
    
    // NIL - for using the same view for searching and for displaying the results; DIFFERENT VIEW CONTROLLER - the search controller will display the results in that view controller instead:
    var resultSearchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
      return resultSearchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        let searchBarScopeIsFiltering = resultSearchController.searchBar.selectedScopeButtonIndex != 0
        return resultSearchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.configureGradientBackground(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.6369693225, green: 0.8708638103, blue: 0.7402992324, alpha: 1), #colorLiteral(red: 0.5733122256, green: 0.8107450601, blue: 0.9764705896, alpha: 1))
        usersTableView.dataSource = self
        usersTableView.delegate = self
        usersTableView.rowHeight = UITableView.automaticDimension
        usersTableView.register(UINib(nibName: "UsersTableViewCell", bundle: nil), forCellReuseIdentifier: "UsersTableViewCell")

        customizeSearchController(resultSearchController)
        // In iOS 11, integrate search controller into navigation bar
        if #available(iOS 11.0, *) {
          self.navigationItem.searchController = resultSearchController
          // Search bar is always visible
          self.navigationItem.hidesSearchBarWhenScrolling = false
        } else {
          usersTableView.tableHeaderView = resultSearchController.searchBar
        }

        (sections, groupedDictionary) = divideUsersIntoSections(users)
        self.usersTableView.reloadData()
    }
    
    override func filterContentForSearchText(_ searchText: String,
                                    category: String? = nil) {
        filteredUsers = filterUsers(usersToFilter: users, emptySearchBar: isSearchBarEmpty, searchText: searchText, category: category)
        if isFiltering {
            (sections, groupedDictionary) = divideUsersIntoSections(filteredUsers)
        } else {
            (sections, groupedDictionary) = divideUsersIntoSections(users)
        }
        usersTableView.reloadData()
    }
    
    
}
