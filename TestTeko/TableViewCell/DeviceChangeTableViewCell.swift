//
//  DeviceChangeTableViewCell.swift
//  TestTeko
//
//  Created by ERT_Macbook_123 on 10/30/22.
//

import UIKit

class DeviceChangeTableViewCell: UITableViewCell {
    @IBOutlet private weak var deviceImage: UIImageView!
    @IBOutlet private weak var colorLabel: UILabel!
    @IBOutlet private weak var codeLabel: UILabel!
    @IBOutlet private weak var errorCodeLabel: UILabel!
    @IBOutlet private weak var nameDeviceLabel: UILabel!
    private var iD = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        backgroundColor = .clear // very important
        layer.masksToBounds = false
        layer.shadowOpacity = 0.23
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.black.cgColor

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
    }
    
    func setValue(color: String?, errorCode: String?, nameDevice: String?, code: String?, id: Int? ) {
        colorLabel.text = color ?? "Unknow"
        errorCodeLabel.text = errorCode ?? "Error Code"
        nameDeviceLabel.text = nameDevice ?? "Name Device"
        codeLabel.text = code ?? "000000"
        iD = id ?? 0
    }
    
    func loadData(url: URL) {
        let queueImage = DispatchQueue(label: "loadImage", attributes: .concurrent)
        queueImage.async {
            do {
                let data =  try Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.deviceImage.image = UIImage(data: data)
                }
            } catch {
                print("load data Fail")
            }
        }
    }
    
}
