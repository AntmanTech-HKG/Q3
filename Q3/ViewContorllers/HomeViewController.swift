//
//  HomeViewController.swift
//  Q3
//
//  Created by Anthony on 22/1/2018.
//  Copyright © 2018 AntmanTech. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift
import SVProgressHUD

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let categoriesList = categoriesList {
            let cat = categoriesList[indexPath.row]
            self.navigationController?.pushViewController(JobsTableViewContorller(jobCat: cat), animated: true)
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.basicTableViewCell, for: indexPath)
        cell.accessoryType = .disclosureIndicator

        if let categoriesList = categoriesList {
            let job = categoriesList[indexPath.row]
            cell.textLabel?.text = "\(job.localizedName.depthIndicator(job.depth, withPad: "+"))"
        }
        
        return cell
    }
}

class HomeViewController: UIViewController {

    var cat: Category?

    var categoriesList: Results<Category>? {
        didSet {
            tableView.reloadData()
        }
    }

    lazy var api: CategoriesAPI = {
        SVProgressHUD.show()
        let api = CategoriesAPI()
        api.completionHandler = { response in
            self.print("CategoriesAPI - \(response)")

            self.cat = Mapper<Category>().map(JSONObject: response)
            CategoryHandler.deletaAll()

            if let cat = self.cat {
//                self.print("setUpTableContents - \(cat)")
                CategoryHandler.save(cat)
                self.categoriesList = CategoryHandler.realm.objects(Category.self)
            }
            
            // old
            // should be an recursive function to handle it
//            if let count = self.categoriesList?.first?.children.count {
//                    let datum = self.categoriesList![0]
//                    CategoryHandler.realm.beginWrite()
//                    datum.depth = 0
//                    try! CategoryHandler.realm.commitWrite()
//
//                    for j in 0..<datum.children.count {
//                        let child = datum.children[j]
//                        CategoryHandler.realm.beginWrite()
//                        child.depth = 1
//                        try! CategoryHandler.realm.commitWrite()
//                        self.print("datum - \(child)")
//                        for k in 0..<child.children.count {
//                            let grand = child.children[k]
//                            CategoryHandler.realm.beginWrite()
//                            grand.depth = 2
//                            try! CategoryHandler.realm.commitWrite()
//                            self.print("datum - \(grand)")
//
//                        }
//                }
//            }
            // new
            CategoryHandler.depthRunner()
            
            SVProgressHUD.dismiss()
        }
        api.failureHandler = { err in
//            self.print("err - \(err)")
            SVProgressHUD.showError(withStatus: "\(err)")
        }
        return api
    }()

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.CellIdentifiers.basicTableViewCell)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLayout()

        tableView.delegate = self
        tableView.dataSource = self
        api.request()
    }

    func setUpLayout() {

        title = Constants.Titles.HomeView

        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

}

