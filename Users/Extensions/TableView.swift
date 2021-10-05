//
//  TableView.swift
//  Users
//
//  Created by Lyudmila Platonova on 24.08.21.
//

import UIKit

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
