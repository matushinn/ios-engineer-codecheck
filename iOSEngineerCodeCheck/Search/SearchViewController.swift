//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import SVProgressHUD


class SearchViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet {
            searchBar.placeholder = "リポジトリを検索できるよ！"
            searchBar.delegate = self
        }
    }
    private var repositories: [Repository] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let nib = UINib(nibName: RepositoryCell.cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: RepositoryCell.cellIdentifier)
        
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func errorAlert(title: String, message: String = "") -> UIAlertController {
        let alert: UIAlertController = UIAlertController(title: title, message : message, preferredStyle: UIAlertController.Style.alert)
        let defaultAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(defaultAction)
        return alert
    }
    
    private func wrongError() -> UIAlertController {
        return errorAlert(title: "不正なワードの入力", message: "検索ワードの確認を行ってください")
    }
    
    private func networkError() -> UIAlertController {
        return errorAlert(title: "インターネットの非接続", message: "接続状況の確認を行ってください")
    }
    
    private func parseError() -> UIAlertController {
        return errorAlert(title: "データの解析に失敗しました")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.cellIdentifier, for: indexPath) as! RepositoryCell
        let repository = repositories[indexPath.row]
        cell.setData(repository: repository)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: String(describing: DetailViewController.self), bundle: nil)
        let detailVC = storyboard.instantiateInitialViewController { coder in
            DetailViewController(coder: coder, repository: self.repositories[indexPath.row])
        }
        self.navigationController?.pushViewController(detailVC!, animated: true)
    }
    
}

//MARK: - UISearchBarDelegate
extension SearchViewController:UISearchBarDelegate{
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        GitHubAPI.taskCancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard !(searchBar.text?.isEmpty ?? true) else { return }
        searchBar.resignFirstResponder()
        
        if let word = searchBar.text{
            GitHubAPI.fetchRepository(text: word) { result in
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
                
                switch result {
                case .success(let items):
                    self.repositories = items
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        switch error {
                        case .wrong :
                            let alert = self.wrongError()
                            self.present(alert, animated: true, completion: nil)
                            return
                        case .network:
                            let alert = self.networkError()
                            self.present(alert, animated: true, completion: nil)
                            return
                        case .parse:
                            let alert = self.parseError()
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                    }
                }
            }
            return
        }
    }
}
