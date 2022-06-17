//
//  VlogListTableViewController.swift
//  FoodVlog(MVVM)
//
//  Created by Isiah Parra on 6/15/22.
//

import UIKit

class VlogListTableViewController: UITableViewController {

    var viewModel: VlogListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        viewModel = VlogListViewModel(delegate: self)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.loadData()
        
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.vlogs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "vlogCell", for: indexPath) as? VlogListTableViewCell else {
            return UITableViewCell() }
        let vlog = viewModel.vlogs[indexPath.row]
        cell.configureCell(with: vlog)

        // Configure the cell...

        return cell
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.delete(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? VlogDetailViewController else {return}
        if segue.identifier == "toDetailVC" {
            guard let index = tableView.indexPathForSelectedRow else {return}
            
            let vlog = viewModel.vlogs[index.row]
            
            destination.viewModel = VlogDetailViewModel(vlog: vlog)
            
        } else {
            destination.viewModel = VlogDetailViewModel()
        }
    }
    

}// end of class

extension VlogListTableViewController: VlogListViewModelDelegate {
    func vlogsLoadedSuccessfully() {
        tableView.reloadData()
    }
    
}
