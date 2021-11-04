//
//  SearchViewController.swift
//  Users
//
//  Created by Lyudmila Platonova on 31.08.21.
//

import UIKit

protocol SearchingProtocol {
    func filterContentForSearchText(_ searchText: String, category: String?)
}

extension SearchingProtocol {
    
    func filterUsers (usersToFilter: [User], emptySearchBar: Bool, searchText: String, category: String?) -> [User] {
        let filteredUsers = usersToFilter.filter { (user: User) -> Bool in
            if emptySearchBar {
                return true
            } else {
                switch category {
                case "All":
                    return user.fullName.lowercased().contains(searchText.lowercased()) || user.city.lowercased().contains(searchText.lowercased()) || user.country
                        .lowercased().contains(searchText.lowercased())
                case "Name":
                    return user.name.lowercased().contains(searchText.lowercased())
                case "Surname":
                    return user.surname.lowercased().contains(searchText.lowercased())
                case "City":
                    return user.city.lowercased().contains(searchText.lowercased())
                case "Country":
                    return user.country.lowercased().contains(searchText.lowercased())
                default:
                    return true
                }
            }
        }
        return filteredUsers
    }
    
    func divideUsersIntoSections (_ usersArray: [User]) -> ([Section], [String : [User]]) {
        // group the array to dictionary
        let dictionary = Dictionary(grouping: usersArray, by: {String ($0.fullName.prefix(1))})
        // get the keys and sort them
        let keys = dictionary.keys.sorted()
        // map the sorted keys to a struct
        let sections = keys.map{Section(letter: $0, users: dictionary[$0]!.sorted(by: <)) }
        return (sections, dictionary)
    }
    
}

class SearchViewController: UIViewController, SearchingProtocol {
    
    // to keep track of the pending work item as a property:
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    func customizeSearchController (_ controller: UISearchController) {
        //  for informing the class of any text changes within the UISearchBar:
//        controller.searchResultsUpdater = self
        // FALSE - if the current view was setted to show the results, TRUE (default) - when another view controller is used for the searchResultsController:
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search by name, city or country"
        controller.searchBar.sizeToFit()
        controller.searchBar.scopeButtonTitles = ["All", "Name", "Surname", "City", "Country"]
        controller.searchBar.delegate = self
        // Sets this view controller as presenting view controller for the search interface:
        definesPresentationContext = true
    }
    
    func filterContentForSearchText(_ searchText: String, category: String?) { }
    
}

//extension SearchViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//     let searchBar = searchController.searchBar
//     let category = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
//     filterContentForSearchText(searchBar.text!, category: category)
//   }
// }

 extension SearchViewController: UISearchBarDelegate {
   
     func searchBar(_ searchBar: UISearchBar,
                    selectedScopeButtonIndexDidChange selectedScope: Int) {
         let category = searchBar.scopeButtonTitles![selectedScope]
         filterContentForSearchText(searchBar.text!, category: category)
     }
     
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         // Cancel the currently pending item:
         pendingRequestWorkItem?.cancel()
         // Wrap the request in a work item:
         let category = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
         let requestWorkItem = DispatchWorkItem { [weak self] in
             self?.filterContentForSearchText(searchText, category: category)
         }
         // Save the new work item and execute it after 250 ms
         pendingRequestWorkItem = requestWorkItem
         DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: requestWorkItem)
     }

 }

