//
//  ViewController.swift
//  TestTableDataCD
//
//  Created by Ospite on 14/06/17.
//  Copyright © 2017 Ospite. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var btnTest: UIButton!
    var people:[NSManagedObject] = []
    
    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnTest.myColor()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else
    {
        return
    }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do
        {
            people = try managedContext.fetch(fetchRequest)
        }
        catch let error as NSError
        {
            print("Errore")
        }
        
    }

    @IBAction func btnAdd(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Nuovo Contatto", message:"Inserire il nuovo Contatto",preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: "Salva", style: UIAlertActionStyle.default){
            action in guard let textField = alert.textFields?.first,let nameToSave = textField.text else {
        
            return
        }
        
        self.save(name: nameToSave)
        self.myTableView.reloadData()
        
    }
    
    let cancelAction = UIAlertAction(title:"Annulla", style:UIAlertActionStyle.default)
    
    alert.addTextField()
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert,animated:true)
    }
    
    func save(name: String)
    {
        // 1 step AppDelegate exists
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else
        {
        return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        person.setValue(name, forKey: "name")
        
        do
        {
            try managedContext.save()
            people.append(person)
        }
        catch let error as NSError
        {
            print("Impossibile salvare")
        }
        
    }

}

extension UIButton
{
    func myColor()
    {
        print("Test")
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil )
        
        let person = people[indexPath.row]
        cell.textLabel?.text = person.value(forKey: "name") as? String
        
        return cell
    }
}

