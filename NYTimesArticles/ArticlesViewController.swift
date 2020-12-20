//
//  ArticlesViewController.swift
//  NYTimesArticles
//
//  Created by Burhanuddin Sunelwala on 19/12/20.
//

import UIKit
import MBProgressHUD

class ArticlesViewController: UITableViewController {

    private var articles = [Article]()
    private var filteredArticles = [Article]()

    private var isSearchBarEmpty: Bool { searchController.searchBar.text?.isEmpty ?? true }
    private var isFiltering: Bool { searchController.isActive && !isSearchBarEmpty }

    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Articles"
        navigationItem.searchController = searchController
        definesPresentationContext = true

        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(loadArticles), for: .valueChanged)

        loadArticles()
    }

    @objc private func loadArticles() {
        MBProgressHUD.showAdded(to: view, animated: true)
        Network.shared.getMostViewedArticles(for: "all-sections", period: 7) { [weak self] result in
            guard let strongSelf = self else { return }
            MBProgressHUD.hide(for: strongSelf.view, animated: true)
            strongSelf.tableView.refreshControl?.endRefreshing()

            result.ifSuccess {

                strongSelf.articles = result.value!
                strongSelf.tableView.reloadData()
            }

            result.ifFailure {

                let alert = UIAlertController(title: "Error", message: result.error!.localizedDescription, preferredStyle: .alert)
                strongSelf.present(alert, animated: true)
            }
        }
    }

    private func filterContentForSearchText(_ searchText: String) {
      filteredArticles = articles.filter { article in
        guard let title = article.title else { return false }

        let searchText = searchText.lowercased()
        return title.lowercased().contains(searchText) ||
            (article.adxKeywords ?? "").lowercased().contains(searchText) ||
            (article.section ?? "").lowercased().contains(searchText) ||
            (article.subsection ?? "").lowercased().contains(searchText) 
      }

      tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch segue.identifier {
        case "segueToArticleDetail":
            let webViewController = segue.destination as? WebViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let article = articles[indexPath.row]
            webViewController?.url = article.url
            webViewController?.title = [article.section, article.subsection].compactMap({ $0 }).joined(separator: " > ")
        default: break
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? filteredArticles.count : articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        cell.article = isFiltering ? filteredArticles[indexPath.row] : articles[indexPath.row]

        return cell
    }
}

extension ArticlesViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
