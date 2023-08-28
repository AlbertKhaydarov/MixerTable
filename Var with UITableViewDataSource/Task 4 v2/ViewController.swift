//
//  ViewController.swift
//  Task 4 v2
//
//  Created by Admin on 11.07.2023.
//

import UIKit
struct Item {
    let num : Int
    var isSelected : Bool
}
class ViewController: UIViewController {
    private lazy var data: [Item] = {
        data = (0...30).map{Item(num: $0, isSelected: false)}
        return data
    }()
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationItem.title = "Task 4"
        
        createBackBarButton(forNavigationItem:  self.navigationItem)
        self.view.addSubview(self.tableView)
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.updateLayout(with: self.view.frame.size)
        
        tableView.isMultipleTouchEnabled = true
        tableView.allowsMultipleSelection = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            self.updateLayout(with: size)
        }, completion: nil)
    }
    
    func createBackBarButton(forNavigationItem navigationItem:UINavigationItem){
        
        let rightBarButtonItem = UIBarButtonItem(
            title: "Shuffle",
            style: .plain,
            target: self,
            action: #selector(shuffleButtonTapped)
        )
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        rightBarButtonItem.tintColor = .systemBlue
    }
    
    @objc func shuffleButtonTapped(){
        data.shuffle()
        animateTableView()
    }
    
    private func updateLayout(with size: CGSize) {
        self.tableView.frame = CGRect(origin: .zero, size: size)
    }
    
    private func animateTableView() {
        tableView.reloadData()
        var delay = 0.01
        let cells = tableView.visibleCells
        
        func makeList(_ n: [UITableViewCell]) -> [UITableViewCell] {
            return cells.shuffled() }
        
        let cellshufled = makeList(cells)
        
        for cell in cellshufled {
            
            let degree: Double = 90
            let rotationAngle = CGFloat(degree * Double.pi / 180)
            let rotationTransform = CATransform3DMakeRotation(rotationAngle, 1, 0, 0)
            cell.layer.transform = rotationTransform
            UIView.animate(withDuration: 0.1, delay: 0.03 * Double(delay), options: .curveEaseInOut) {
                cell.layer.transform  =  CATransform3DIdentity
            }
            delay += 0.4
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tableView:
            return self.data.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        var content = cell.defaultContentConfiguration()
        let item = data[indexPath.row]
        content.text = String(item.num)
        cell.contentConfiguration = content
        cell.accessoryType = item.isSelected ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            data[indexPath.row].isSelected = false
            
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            data[indexPath.row].isSelected = true
            let element = data[indexPath.row]
            self.data.remove(at: indexPath.row)
            self.data.insert(element, at: 0)
            
            tableView.beginUpdates()
            tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
            tableView.deselectRow(at: indexPath, animated: true)
            
            tableView.endUpdates()
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
        
        
    }
}

class TableViewCell: UITableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryType = .none
    }
}

