//
//  EditProductViewController.swift
//  TestTeko
//
//  Created by ERT_Macbook_123 on 10/30/22.
//

import UIKit
class EditProductViewController: UIViewController {
    
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var EditProductTableView: UITableView!
    let headerView = StretchyTableHeaderView()
    var colors: [Color] = []
    var productError: ProductError = ProductError()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        setupUI()
        setupTableView()
        print(productError)
    }

    func setupUI(){
        updateButton.layer.cornerRadius = 12
        updateButton.layer.borderWidth = 1
        updateButton.layer.borderColor = UIColor.white.cgColor
        updateButton.layer.masksToBounds = true
    }
    
    func setupTableView() {
        EditProductTableView.register(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelTableViewCell")
        EditProductTableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
        EditProductTableView.register(UINib(nibName: "SelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectionTableViewCell")
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height*300/812)
        EditProductTableView.dataSource = self
        EditProductTableView.delegate = self
        EditProductTableView.tableHeaderView = headerView
        EditProductTableView.separatorStyle = .none
        EditProductTableView.allowsSelection = false
    }

    func loadData(url: URL) {
        let queueImage = DispatchQueue(label: "loading", attributes: .concurrent)
        queueImage.async {
            do {
                let data =  try Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.headerView.imageView.image =  UIImage(data: data)
                }
            }
            catch {
            }
        }
    }

    @IBAction func ontapBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapUpdate(_ sender: Any) {
        view.endEditing(true)
    }
}

// MARK: - UITableViewDataSource

extension EditProductViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            loadData(url: URL(string: productError.image ?? "") ?? URL(fileURLWithPath: ""))
        }
        switch (indexPath.row){
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "LabelTableViewCell", for: indexPath) as? LabelTableViewCell else {
                return UITableViewCell()}
            cell.setValue(title: "Error Description", sub: productError.errorDescription)
                return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "LabelTableViewCell", for: indexPath) as? LabelTableViewCell else {
                return UITableViewCell()}
            cell.setValue(title: "ID", sub: String(productError.id ?? 0))
                return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "TextFieldTableViewCell", for: indexPath) as? TextFieldTableViewCell else {
                return UITableViewCell()}
            cell.setValue(title: "Product Name", placeHolder: productError.name)
                return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "TextFieldTableViewCell", for: indexPath) as? TextFieldTableViewCell else {
                return UITableViewCell()}
            cell.setValue(title: "SKU", placeHolder: productError.sku)
                return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "SelectionTableViewCell", for: indexPath) as? SelectionTableViewCell else {
                return UITableViewCell()}
            cell.colorPicker.delegate = self
            cell.colorPicker.dataSource = self
                return cell
            
        default:
            return UITableViewCell()
        }
    }
}


// MARK: - UITableViewDelegate

extension EditProductViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
    }
}

extension EditProductViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let headerView = self.EditProductTableView.tableHeaderView as? StretchyTableHeaderView else {return  }
        headerView.scrollViewDidScroll(scrollView: scrollView)
    }
}

extension EditProductViewController{
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

// MARK: - UIPickerViewDelegate

extension EditProductViewController: UIPickerViewDelegate{
    
}

// MARK: - UIPickerViewDataSource

extension EditProductViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      
        return colors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colors[row].name
       }
    
}
