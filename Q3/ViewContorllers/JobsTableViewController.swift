//
//  JobsTableViewController.swift
//  Q3
//
//  Created by Anthony on 23/1/2018.
//  Copyright © 2018 AntmanTech. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift
import SVProgressHUD

extension JobsTableViewContorller: UIScrollViewDelegate {
    func loadMore() {
        api.page = api.page + 1
        SVProgressHUD.show()
        api.request()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset - currentOffset <= Constants.Numbers.loadMoreLimit {
            loadMore()
        }
    }
}

extension JobsTableViewContorller: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let job = objectFor(indexPath) {
            guard let url = URL(string: job.webURL) else { return }
            
//            present(WebViewController(url: url), animated: true, completion: nil)
            self.navigationController?.showDetailViewController(WebViewController(url: url), sender: self)
        }
    }
}

extension JobsTableViewContorller: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobDetails?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.jobDetailsTableViewCell, for: indexPath) as! JobDetailsTableViewCell

        if let job = objectFor(indexPath) {
            cell.objectFor(job)
        }

        return cell
    }

    func objectFor(_ indexPath: IndexPath) -> JobDetails? {
        if let jobDetails = jobDetails {
            return jobDetails[indexPath.row]
        }
        return nil
    }
}

class JobsTableViewContorller: UIViewController {

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: Constants.CellIdentifiers.jobDetailsTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.CellIdentifiers.jobDetailsTableViewCell)
        return tableView
    }()

    var jobDetails: [JobDetails]? = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var api: JobsAPI = {
        let api = JobsAPI()
        api.completionHandler = { response in
            let array = Mapper<JobDetails>().mapArray(JSONObject: response)
            if let array = array {
               self.jobDetails?.append(contentsOf: array)
            }
            SVProgressHUD.dismiss()
        }
        api.failureHandler = { err in
            self.print("err - \(err)")
            SVProgressHUD.showError(withStatus: "\(err)")
        }
        return api
    }()

    var jobCat: Category?

    init(jobCat: Category) {
        self.jobCat = jobCat
        super.init(nibName: nil, bundle: nil)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLayout()

        tableView.delegate = self
        tableView.dataSource = self

        if let jobCat = jobCat {
            title = jobCat.localizedName
            api.categoryId = jobCat.categoryId
            api.request()
        } else {
            SVProgressHUD.dismiss()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setUpLayout() {
        SVProgressHUD.show()
        
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
