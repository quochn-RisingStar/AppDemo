//
//  SubmitController.swift
//  TestTeko
//
//  Created by ERT_Macbook_123 on 10/30/22.
//

import UIKit

class SubmitViewController: UIViewController {
  @IBOutlet weak var deviceTableView: UITableView!
    
    var colors: [Color] = []
    var productsError: [ProductError] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        }
    func setupUI(){
    }
    
    func setupTableView(){
        deviceTableView.backgroundColor = UIColor.white
        let nib = UINib(nibName: "DeviceChangeTableViewCell", bundle: nil)
        deviceTableView.register(nib, forCellReuseIdentifier: "DeviceChangeTableViewCell")
        deviceTableView.dataSource = self
        deviceTableView.delegate = self
        deviceTableView.allowsSelection = false
    }
    
    @IBAction func ontapOK(_ sender: Any) {
        print("ontap OK")
    }

    @IBAction func ontapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension SubmitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsError.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "DeviceChangeTableViewCell", for: indexPath) as? DeviceChangeTableViewCell else {
            return UITableViewCell()}
        let color = colors.first(where: {$0.id == productsError[indexPath.row].color})
        cell.setValue(color: color?.name, errorCode: productsError[indexPath.row].errorDescription, nameDevice: productsError[indexPath.row].name, code: productsError[indexPath.row].sku, id: productsError[indexPath.row].id)
        cell.loadData(url: URL(string: productsError[indexPath.row].image ?? "") ?? URL(fileURLWithPath: ""))
        return cell
    }
    
}

extension SubmitViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}
