//
//  DashboardViewConrtroller.swift
//  TaskTracker
//
//  Created by Harsha on 11/01/21.
//

import Foundation
import UIKit

class DashboardViewContrtoller: UIViewController {
    var dashboardViewModel = DashboardViewModel()
    var hideFirstSection = false
    var hideSecondSection = false
    @IBOutlet weak var openTableView: UITableView!
    var sections = ["Open Tasks", "Closed Tasks"]
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        getTableData()
        openTableView.delegate = self
        openTableView.dataSource = self
        openTableView.tableFooterView = UIView()
    }
    
    func updateUI() {
        CustomActivityIndicator.instance.showLoaderView()
        let logOutBtn = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.done, target: self, action: #selector(logOut))
        let addTaskBtn = UIBarButtonItem(title: "Add Task", style: UIBarButtonItem.Style.plain, target: self, action: #selector(DashboardViewContrtoller.addTask))
        
        navigationItem.leftBarButtonItem = logOutBtn
        navigationItem.rightBarButtonItem = addTaskBtn
        self.navigationController?.navigationBar.setItems([navigationItem], animated: false)
    }
    
    func getTableData() {
        dashboardViewModel.getTasksList { (isSuccess, data) in
            CustomActivityIndicator.instance.hideLoaderView()
            if isSuccess {
                DispatchQueue.main.async {
                    self.openTableView.reloadData()
                }
            }
        }
    }
    
    @objc func logOut() {
        CustomActivityIndicator.instance.showLoaderView()
        dashboardViewModel.logOut { (isSuccess, data) in
            CustomActivityIndicator.instance.hideLoaderView()
            if isSuccess {
                self.navigationController?.popViewController(animated: true)
            } else {
                Utils().showAlert(title: "Error", description: "Error Logging Out!, Try again", buttonTitle:"OK", sender: self)
            }
        }
    }
    
    @objc func addTask() { }
    
    @objc
    private func hideSection(sender: UIButton) {
        if sender.tag == 0 {
            hideFirstSection = !hideFirstSection
            openTableView.reloadSections([0], with: UITableView.RowAnimation.automatic)
        } else {
            hideSecondSection = !hideSecondSection
            openTableView.reloadSections([1], with: UITableView.RowAnimation.automatic)
        }
    }
    
    private func editTasks(){
        
    }
    
    
    deinit {
        print("Deinit: DashBoardMainViewController")
    }
}

extension DashboardViewContrtoller: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return hideFirstSection ? 0 : dashboardViewModel.openTaskData.count
        } else {
            return hideSecondSection ? 0 : dashboardViewModel.completedTaskData.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.section == 0{
            cell.textLabel?.text = dashboardViewModel.openTaskData[indexPath.row].datumDescription
        } else {cell.textLabel?.text = dashboardViewModel.completedTaskData[indexPath.row].datumDescription}
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionButton = UIButton()
        sectionButton.setTitle(sections[section],
                               for: .normal)
        sectionButton.backgroundColor = .lightGray
        sectionButton.tag = section
        sectionButton.addTarget(self,
                                action: #selector(self.hideSection(sender:)),for: .touchUpInside)
        return sectionButton
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteItem = UIContextualAction(style: .destructive, title: "DELETE") {[weak self] (contextualAction, view, boolValue) in
            CustomActivityIndicator.instance.showLoaderView()
            var taskID = ""
            if indexPath.section == 0 {
                taskID = self?.dashboardViewModel.openTaskData[indexPath.row].id ?? ""
            } else {
                taskID = self?.dashboardViewModel.completedTaskData[indexPath.row].id ?? ""
            }
            self?.dashboardViewModel.deletetTask(taskId: taskID) { (isUpdated, errorMessage) in
                if isUpdated{
                    self?.getTableData()
                } else {
                    Utils().showAlert(title: "Error", description: "Error Updating task status", buttonTitle:"OK", sender: self!)
                }
            }
        }
        deleteItem.backgroundColor = UIColor.red
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteItem])
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0 {
            let markAsdoneItem = UIContextualAction(style: .destructive, title: "Mark as Done") {[weak self] (contextualAction, view, boolValue) in
                CustomActivityIndicator.instance.showLoaderView()
                self?.dashboardViewModel.editTask(completed: true, taskId: self?.dashboardViewModel.openTaskData[indexPath.row].id ?? "") { (isUpdated, errorMessage) in
                    if isUpdated{
                        self?.getTableData()
                    } else {
                        Utils().showAlert(title: "Error", description: "Error Updating task status", buttonTitle:"OK", sender: self!)
                    }
                }
            }
            markAsdoneItem.backgroundColor = UIColor.green
            let swipeActions = UISwipeActionsConfiguration(actions: [markAsdoneItem])
            return swipeActions
        } else {
            let markAsdoneItem = UIContextualAction(style: .destructive, title: "Mark as Open") {[weak self] (contextualAction, view, boolValue) in
                CustomActivityIndicator.instance.showLoaderView()
                self?.dashboardViewModel.editTask(completed: false, taskId: self?.dashboardViewModel.completedTaskData[indexPath.row].id ?? "") { (isUpdated, errorMessage) in
                    if isUpdated{
                        self?.getTableData()
                    } else {
                        Utils().showAlert(title: "Error", description: "Error Updating task status", buttonTitle:"OK", sender: self!)
                    }
                }
            }
            markAsdoneItem.backgroundColor = UIColor.brown
            let swipeActions = UISwipeActionsConfiguration(actions: [markAsdoneItem])
            return swipeActions
        }
    }
}
