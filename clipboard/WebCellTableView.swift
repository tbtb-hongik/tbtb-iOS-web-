import UIKit

protocol WebCellTableViewCell: class {
    func webCell(_ cell: WebCellTableViewCell, didTapwebBttn button: UIButton)
    func webCell(_ cell: WebCellTableViewCell, didTapselectBttn button: UIButton)
}

class WebCellTableViewCell: UITableViewCell {
    weak var delegate: WebCellTableViewCell.Delegate?
    @IBOutlet weak var WebImageView: UIImageView!
    @IBOutlet weak var webBttn: UIButton!
    @IBOutlet weak var webLabel: UILabel!
    @IBOutlet weak var selectBttn: UIButton!
      
    override func prepareForReuse() {
        super.prepareForReuse()
        WebImageView.image = nil
        webBttn.setTitle(nil, for: .normal)
        webLabel.text = nil
        selectBttn.setTitle(nil, for: .normal)
        selectBttn.setImage(nil, for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
        layer.borderWidth = 2
        layer.borderColor = CGColor.init(srgbRed: 255, green: 255, blue: 255, alpha: 100)
        webBttn.addTarget(self, action: #selector(webBttnDidTap(_:)), for: .touchUpInside)
        selectBttn.addTarget(self, action: #selector(selectBttnDidTap(_:)), for: .touchUpInside)
    }
    
    func configure(with model: WebCellModel, tag: Int, isSelected: Bool) {
        let selectedBttnImg = isSelected ? UIImage(named: "btnSelectActive") : UIImage(named: "btnSelect")
        selectBttn.setImage(selectedBttnImg, for: .normal)
        webBttn.setTitle(model.name, for: .normal)
        ImageFetcher.image(for: URL(string: model.image)!) { result in
            switch result {
            case let .success(image):
                DispatchQueue.main.async {
                    self.webImgView.image = image
                }
            case let .failure(error):
                print("error")
            }
        }
        webBttn.tag = tag
        selectBttn.tag = tag
    }
    
    @objc private func webBttnDidTap(_ sender: UIButton) {
        delegate?.WebCell(self, didTapwebBttn: sender)
    }
    
    @objc private func selectBttnDidTap(_ sender: UIButton) {
        delegate?.WebCell(self, didTapselectBttn: sender)
    }
}
