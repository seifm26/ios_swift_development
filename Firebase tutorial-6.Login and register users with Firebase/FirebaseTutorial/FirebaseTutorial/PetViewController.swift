//
//  PetViewController.swift
//  FirebaseTutorial
//
//  Created by Nguyen Duc Hoang on 4/25/17.
//  Copyright © 2017 Nguyen Duc Hoang. All rights reserved.
//

import UIKit

class PetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView:UITableView?
    var pets: [Pet] = [Pet]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: tableView ?? UITableView(), attribute: .top,
                                              relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: tableView ?? UITableView(), attribute: .right,
                                              relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: tableView ?? UITableView(), attribute: .bottom,
                                              relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: tableView ?? UITableView(), attribute: .left,
                                              relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0))
        tableView?.register(UINib(nibName: "PetTableViewCell", bundle: nil), forCellReuseIdentifier: "PetTableViewCell")
        // Do any additional setup after loading the view.
        (UIApplication.shared.delegate as! AppDelegate).fireBaseRef.observe(.value, with: { snapshot in
            let dictRoot = snapshot.value as? [String : AnyObject] ?? [:]
            let dictPets = dictRoot["pets"] as? [String: AnyObject] ?? [:]
            self.pets = [Pet]()
            for key in Array(dictPets.keys).sorted().reversed() {
                self.pets.append(Pet(dictionary: dictPets[key] as! [String: AnyObject], key: key))
            }
            self.tableView?.reloadData()
            print(dictPets)
        })

        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = false
        self.customizeNavigationBar()
    }
    func customizeNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 68 / 255, green: 169 / 255, blue: 128 / 255, alpha: 1)
        //        navigationController?.navigationBar.tintColor = UIColor.white
        self.title = "Pets list"
        navigationController?.navigationBar.isTranslucent = false;
        let btnAdd = UIButton(type: .custom)
        btnAdd.setImage(#imageLiteral(resourceName: "icon_add"), for: .normal)
        btnAdd.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnAdd.addTarget(self, action: #selector(btnAdd(sender:)), for: .touchUpInside)
        let rightButton = UIBarButtonItem(customView: btnAdd)
        navigationItem.setRightBarButton(rightButton, animated: true)
    }
    
    @IBAction func btnAdd(sender: AnyObject) {
        print("press btnAdd")
        var txtPetName: UITextField?
        var txtPetAge: UITextField?
        let actionSheetController: UIAlertController = UIAlertController(title: "Add Pet",
                                                                         message: "Input Pet's information:",
                                                                         preferredStyle: .alert)
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Do some stuff
        }
        actionSheetController.addAction(cancelAction)
        let saveAction: UIAlertAction = UIAlertAction(title: "Save", style: .default) { action -> Void in
            //Do some other stuff
            if(txtPetName?.text == nil || txtPetName?.text == "") {
                return
            }
            
            (UIApplication.shared.delegate as! AppDelegate).fireBaseRef.child("pets").child(txtPetName!.text ?? "")
                .setValue(["name": txtPetName?.text ?? "",
                           "age": txtPetAge?.text ?? ""])
        }
        actionSheetController.addAction(saveAction)
        //Add a text field
        actionSheetController.addTextField { (textField) in
            textField.placeholder = "Enter pet's name"
            txtPetName = textField
        }
        //Add a text field
        actionSheetController.addTextField { (textField) in
            textField.placeholder = "Enter pet's age"
            txtPetAge = textField
        }
        //Present the AlertController
        self.present(actionSheetController, animated: true) {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetTableViewCell", for: indexPath) as! PetTableViewCell
        let eachPet = pets[indexPath.row]
        cell.lblPetName.text = eachPet.name
        cell.lblPetAge.text = "\(eachPet.age)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if(editingStyle == .delete) {
//            let deletingPet = self.pets[indexPath.row]
//            (UIApplication.shared.delegate as! AppDelegate).fireBaseRef.child("pets").child(deletingPet.name).removeValue()
//        }
//    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default,
                                                title: "Delete",
                                                handler: { (action, indexPath) in
                                                    print("Delete cell")
                                                    let deletingPet = self.pets[indexPath.row]
                                                    (UIApplication.shared.delegate as! AppDelegate).fireBaseRef.child("pets").child(deletingPet.name).removeValue()
        })
        deleteAction.backgroundColor = UIColor.red
        let editAction = UITableViewRowAction(style: .default,
                                              title: "Edit",
                                              handler: { (action, indexPath) in
                                                print("press Edit")
                                                var txtPetName: UITextField?
                                                let editingPet:Pet = self.pets[indexPath.row]
                                                let actionSheetController: UIAlertController = UIAlertController(title: "Update",
                                                                                                                 message: "Update pet's name",
                                                                                                                 preferredStyle: .alert)
                                                //Create and add the Cancel action
                                                let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                                                    //Do some stuff
                                                }
                                                let saveAction: UIAlertAction = UIAlertAction(title: "Save", style: .default) { action -> Void in
                                                    if(txtPetName?.text == nil || txtPetName?.text == "") {
                                                        return
                                                    }
                                                    //delete first
                                                    (UIApplication.shared.delegate as! AppDelegate).fireBaseRef.child("pets").child(editingPet.name).removeValue()
                                                    //...Then insert
                                                    (UIApplication.shared.delegate as! AppDelegate).fireBaseRef.child("pets").child(txtPetName!.text ?? "")
                                                        .setValue(["name": txtPetName?.text ?? "",
                                                                   "age": "\(editingPet.age)"])
                                                }
                                                actionSheetController.addAction(saveAction)
                                                actionSheetController.addAction(cancelAction)
                                                actionSheetController.addTextField { (textField) in
                                                    textField.text = editingPet.name
                                                    textField.placeholder = "Enter pet's name"
                                                    txtPetName = textField
                                                }
                                                self.present(actionSheetController, animated: true) {
                                                    
                                                }
                                                
        })
        editAction.backgroundColor = UIColor.blue
        return[deleteAction, editAction]
    }


}
