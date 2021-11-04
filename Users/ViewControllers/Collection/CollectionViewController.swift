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


extension CollectionViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader else {
                return UICollectionReusableView()
            }
            sectionHeader.label.text = String(sections[indexPath.section].letter)
            sectionHeader.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 0.5)
             return sectionHeader
        } else { //No footer in this case but can add option for that
             return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UsersCollectionViewCell", for: indexPath) as? UsersCollectionViewCell else {
            return UICollectionViewCell()
        }
        let section = sections[indexPath.section]
        let user = section.users[indexPath.item]
        cell.nameLabel?.text = user.fullName
        cell.addressLabel?.text = user.street + " " + user.building + ", " + user.postcode + " " + user.city + ", " + user.state + ", " + user.country
        cell.telLabel?.text = user.cell
        guard let url = URL(string: user.mediumImage) else { return cell}
        if let data = try? Data(contentsOf: url) {
            cell.userImage.image = UIImage(data: data)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailedViewController", bundle: nil)
        if let vc = storyboard.instantiateViewController(identifier: "DetailedViewController") as? DetailedViewController {
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            let selectedSection = sections[indexPath.section].letter
            guard let selectedUsers = groupedDictionary[selectedSection] else { return }
            vc.selectedUser = selectedUsers[indexPath.item]
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
    
    
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        var numberOfItemsPerRow: CGFloat
        if UIDevice.current.orientation.isLandscape {
            if UIDevice.current.userInterfaceIdiom == .pad {
                numberOfItemsPerRow = 6.0
            } else {
                numberOfItemsPerRow = 4.0
            }
        } else {
            if UIDevice.current.userInterfaceIdiom == .pad {
                numberOfItemsPerRow = 3.0
            } else {
                numberOfItemsPerRow = 2.0
            }
        }
        
        let spacing: CGFloat = 16
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemWidth = floor(availableWidth / numberOfItemsPerRow)
        return CGSize(width: itemWidth, height: itemWidth+105)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16

    }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 16
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        }
    
}
