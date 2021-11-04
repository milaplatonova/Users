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


extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].users.count
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.tintColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        header.alpha = 0.5
        header.textLabel?.tintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        header.textLabel?.font = .boldSystemFont(ofSize: 16)
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections.map{$0.letter}
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].letter
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UsersTableViewCell") as? UsersTableViewCell else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.selectionStyle = .none
            return cell
        }
        // to make the TableView transparent:
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.accessoryType = .disclosureIndicator
        let section = sections[indexPath.section]
        let user = section.users[indexPath.row]
        cell.nameLabe?.text = user.fullName
        cell.addressLabel?.text = user.street + " " + user.building + ", " + user.postcode + " " + user.city + ", " + user.state + ", " + user.country
        cell.telLabel?.text = user.cell
        guard let url = URL(string: user.thumbnailImage) else { return cell}
        if let data = try? Data(contentsOf: url) {
            cell.userImage.image = UIImage(data: data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailedViewController", bundle: nil)
        if let vc = storyboard.instantiateViewController(identifier: "DetailedViewController") as? DetailedViewController {
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            let selectedSection = sections[indexPath.section].letter
            guard let selectedUsers = groupedDictionary[selectedSection] else { return }
            vc.selectedUser = selectedUsers[indexPath.row]
            self.navigationController!.pushViewController(vc, animated: true)
        }
        
    }
}
