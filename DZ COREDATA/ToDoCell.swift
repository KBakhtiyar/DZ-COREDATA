import UIKit

class ToDoCell: UITableViewCell {

    static let cellIdentifier = "ToDoCell"
    var delegate: TodoCellDelegate?
    var task: TodoListTask?
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    lazy var checkImage: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(systemName: "checkmark.square")
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        image.isUserInteractionEnabled = true
        return image
    }()
    
    @objc func imageTapped() {
        delegate?.checkTapped(task)
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private func setupViews() {
        self.selectionStyle = .none
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(checkImage)
        
        nameLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(8)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.bottom.equalToSuperview().inset(8)
        }
        
        checkImage.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview().inset(8)
            make.width.height.equalTo(20)
        }
    }
    
    func configure(_ task: TodoListTask) {
        dateLabel.text = task.deadline?.formatted()
        nameLabel.text = task.name
        let imageName = task.isDone ? "checkmark.square" : "square"
        checkImage.image = UIImage(systemName: imageName)
        self.task = task
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


protocol TodoCellDelegate {
    func checkTapped(_ task: TodoListTask?)
}
