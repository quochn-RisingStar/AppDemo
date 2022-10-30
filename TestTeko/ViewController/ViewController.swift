//
//  ViewController.swift
//  TestTeko
//
//  Created by ERT_Macbook_123 on 10/29/22.
//

import UIKit

class ViewController: UIViewController {
  
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var deviceTableView: UITableView!
    var colors: [Color] = []
    private var isFetchColorSuccess = false
    var productsError: [ProductError] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        fetchColor{_ in }
        fetchProductError{[weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    self.deviceTableView.reloadData()
                }

            case let .failure(error):
                DispatchQueue.main.async {
                    print("Error : \(error)")
                }
            }
        }
    }
    
    func setupUI(){
        submitButton.layer.cornerRadius = 12
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor.white.cgColor
        submitButton.layer.masksToBounds = true
    }
    
    func setupTableView(){
        deviceTableView.backgroundColor = UIColor.white
        let nib = UINib(nibName: "DeviceTableViewCell", bundle: nil)
        deviceTableView.register(nib, forCellReuseIdentifier: "DeviceTableViewCell")
        deviceTableView.dataSource = self
        deviceTableView.delegate = self
        deviceTableView.allowsSelection = false
    }

    @IBAction func onTapSubmit(_ sender: Any) {
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsError.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "DeviceTableViewCell", for: indexPath) as? DeviceTableViewCell else {
            return UITableViewCell()}
        let color = colors.first(where: {$0.id == productsError[indexPath.row].color})
        cell.setValue(color: color?.name, errorCode: productsError[indexPath.row].errorDescription, nameDevice: productsError[indexPath.row].name, code: productsError[indexPath.row].sku, id: productsError[indexPath.row].id)
        cell.loadData(url: URL(string: productsError[indexPath.row].image ?? "") ?? URL(fileURLWithPath: ""))
        cell.didSelectChangeButton = self
        return cell
    }
    
}

extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

extension ViewController {
    func fetchProductError(completion: @escaping (Result<Void, Error>) -> Void) {
        let address = "https://hiring-test.stag.tekoapis.net/api/products"
        if let url = URL(string: address) {
            URLSession.shared.dataTask(with: url) { [weak self] data, responds, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let responds = responds as? HTTPURLResponse, let data = data {
                    print("Status Code : \(responds.statusCode)")
                    do { let decoder = JSONDecoder()
                        let productErrors =  try decoder.decode([ProductError].self, from: data)
                        self?.productsError = productErrors
                        completion(.success(()))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
    
    func fetchColor(completion: @escaping (Result<Void, Error>) -> Void) {
        let address = "https://hiring-test.stag.tekoapis.net/api/colors"
        if let url = URL(string: address) {
            URLSession.shared.dataTask(with: url) { [weak self] data, responds, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let responds = responds as? HTTPURLResponse, let data = data {
                    print("Status Code : \(responds.statusCode)")
                    print(data as Any)
                    do { let decoder = JSONDecoder()
                        let colors =  try decoder.decode([Color].self, from: data)
                        self?.colors = colors
                        print(colors.description)
                        completion(.success(()))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
    
}

extension ViewController: UITableViewCellDelegate{
    func didSelectItem(id: Int, url:URL) {
        let nextView = storyboard?.instantiateViewController(
            withIdentifier: "EditProductViewController") as? EditProductViewController
            nextView?.modalPresentationStyle = .fullScreen
        self.present(nextView!, animated:true, completion: nil)
        nextView?.productError = productsError.first(where: {$0.id == id}) ?? ProductError()
        nextView?.colors = colors
        
    }
}
