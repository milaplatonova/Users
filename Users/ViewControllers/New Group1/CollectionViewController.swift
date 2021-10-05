//
//  CollectionViewController.swift
//  Users
//
//  Created by Lyudmila Platonova on 26.05.21.
//

import UIKit

class CollectionViewController: SearchViewController {
    
    @IBOutlet weak var usersCollectionView: UICollectionView!
    
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
        
        let flowLayout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 16
            layout.minimumLineSpacing = 16
            layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            return layout
        }()
        
        view.layer.configureGradientBackground(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.6369693225, green: 0.8708638103, blue: 0.7402992324, alpha: 1), #colorLiteral(red: 0.5733122256, green: 0.8107450601, blue: 0.9764705896, alpha: 1))
        usersCollectionView.backgroundColor = UIColor.clear
        usersCollectionView.delegate = self
        usersCollectionView.dataSource = self
        usersCollectionView.collectionViewLayout = flowLayout
        
        usersCollectionView.register(UINib(nibName: "UsersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UsersCollectionViewCell")
        usersCollectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        
        customizeSearchController(resultSearchController)
        navigationItem.searchController = resultSearchController

        (sections, groupedDictionary) = divideUsersIntoSections(users)
        self.usersCollectionView.reloadData()
        
    }
    override func filterContentForSearchText(_ searchText: String, category: String? = nil) {
        filteredUsers = filterUsers(usersToFilter: users, emptySearchBar: isSearchBarEmpty, searchText: searchText, category: category)
        if isFiltering {
            (sections, groupedDictionary) = divideUsersIntoSections(filteredUsers)
        } else {
            (sections, groupedDictionary) = divideUsersIntoSections(users)
        }
        usersCollectionView.reloadData()
    }

}


