import UIKit
import SnapKit

class ViewController: UIViewController {

    var tasks = [TodoListTask]() {
        didSet {
            tableView.reloadData()
        }
    }
    let manager = CoreDataManager.shared
    
    lazy var filterbutton: UIButton = {
        let button = UIButton()
        button.setTitle("COMPLETED", for: .normal)
        button.setTitleColor(.brown, for: .normal)
        button.addTarget(self, action: #selector(toggleFilter), for: .touchUpInside)
        return button
    }()
   
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ToDoCell.self, forCellReuseIdentifier: ToDoCell.cellIdentifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var textField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "insert task"
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        return picker
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("ADD TASK", for: .normal)
        button.setTitleColor(.brown, for: .normal)
        button.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        return button
    }()
    
    @objc func toggleFilter() {
            isFilteringCompletedTasks.toggle()
            tableView.reloadData()
        }
    
    @objc func addTask() {
        manager.createTask(name: textField.text!, deadline: datePicker.date)
        textField.text = ""
        getTasks()
    }
    
    
    private func getTasks() {
        self.tasks = manager.getTasks()
        print(tasks)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        getTasks()
    }
    
    private func setUI() {
        view.backgroundColor = .white
        view.addSubview(filterbutton)
        view.addSubview(tableView)
        view.addSubview(button)
        view.addSubview(textField)
        view.addSubview(datePicker)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        filterbutton.snp.makeConstraints { make in
            make.leading.equalTo(button.snp.trailing).offset(10)
            make.centerY.equalTo(datePicker)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(200)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        datePicker.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(textField.snp.bottom).offset(8)
        }
        
        button.snp.makeConstraints { make in
            make.leading.equalTo(datePicker.snp.trailing).offset(10)
            make.centerY.equalTo(datePicker)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(16)
            make.top.equalTo(datePicker.snp.bottom)
        }
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoCell.cellIdentifier, for: indexPath) as? ToDoCell else { return UITableViewCell() }
        cell.configure(tasks[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            self?.deleteTask(at: indexPath)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func deleteTask(at indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        manager.deleteTask(task: task)
        getTasks()
    }
    
}
var isFilteringCompletedTasks = false

func fetchTasks() -> [TodoListTask] {
        if isFilteringCompletedTasks {
            return CoreDataManager.shared.getCompletedTasks()
        } else {
            return CoreDataManager.shared.getTasks()
        }
    }

extension ViewController: TodoCellDelegate {
    func checkTapped(_ task: TodoListTask?) {
        manager.updateTask(task: task!)
        getTasks()
    }
}
