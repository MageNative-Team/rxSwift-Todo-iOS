//
//  listingViewController.swift
//  rxswiftTODO
//
//  Created by cedcoss on 10/08/21.
//

import UIKit
import RxSwift
import RxCocoa

class listingViewController: UIViewController {

    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var listTable: UITableView!
    
    var listArray = BehaviorRelay<[listing]>(value: [])
    var disposeBag = DisposeBag()
    var filteredListing = [listing]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segment.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nc = segue.destination as? UINavigationController
        if let vc = nc?.viewControllers.first as? addNewViewController{
            vc.taskObserver.subscribe(onNext:{ listing in
                print(listing)
                //append doesnt work with behaviour relay/ use variable in case of appending
                    //listArray.value.append(listing)
                // to append new items we use accept, since it overrides previously existing values so append safely by storing previous data in new vaiable
                var prevData = self.listArray.value
                prevData.append(listing)
                self.listArray.accept(prevData)
                print(self.listArray.value)
                let priorityToPass = priority(rawValue: self.segment.selectedSegmentIndex-1)
                self.filterListing(with: priorityToPass)
               
            }).disposed(by: disposeBag)
        }
    }
    func filterListing(with Priority: priority?){
        print(Priority)
        if let priorityRecieved = Priority{
            self.listArray.map { task in
                return task.filter{ $0.priority == priorityRecieved}
            }.subscribe(onNext:{ array in
                self.filteredListing = array
            }).disposed(by: disposeBag)
        }else{
            self.filteredListing = self.listArray.value
        }
        DispatchQueue.main.async {
            self.listTable.dataSource = self
            self.listTable.delegate = self
            self.listTable.reloadData()
        }
        print(self.filteredListing)
    }
    @objc func segmentedControlValueChanged(_ sender:UISegmentedControl){
        let priorityValue = priority(rawValue: sender.selectedSegmentIndex - 1)
        self.filterListing(with: priorityValue)
    }
}
extension listingViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.filteredListing.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listTableViewCell", for: indexPath) as! listTableViewCell
        cell.listName.text = filteredListing[indexPath.row].title
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
