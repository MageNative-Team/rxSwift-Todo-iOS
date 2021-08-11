//
//  addNewViewController.swift
//  rxswiftTODO
//
//  Created by cedcoss on 10/08/21.
//

import UIKit
import RxSwift

class addNewViewController: UIViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var textfield: UITextField!
    
    let taskSubject = PublishSubject<listing>()
    var taskObserver : Observable<listing>  {
       return taskSubject.asObserver()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.target = self
        saveButton.action = #selector(saveTapped)
    }
    
    @objc func saveTapped(){
        guard let priority = priority(rawValue: self.segment.selectedSegmentIndex),
              let title = self.textfield.text else {return}
        let taskToPass = listing(title: title, priority: priority)
        taskSubject.onNext(taskToPass)
        self.dismiss(animated: true, completion: nil)
    }
}
