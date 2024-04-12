import Foundation
import CoreData

class CoreDataManager {

    static let shared = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "CoreDataLessonN1")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
        
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func createTask(name: String, deadline: Date) {
        let context = persistentContainer.viewContext
        let task = TodoListTask(context: context)
        task.deadline = deadline
        task.name = name
        task.isDone = false
        saveContext()
    }
    func getCompletedTasks() -> [TodoListTask] {
            let context = persistentContainer.viewContext
            let request: NSFetchRequest<TodoListTask> = TodoListTask.fetchRequest()
            request.predicate = NSPredicate(format: "isDone == %@", true as CVarArg)
            do {
                let completedTasks = try context.fetch(request)
                return completedTasks
            } catch {
                print("\(error)")
                return []
            }
        }
    
    
    func getTasks() -> [TodoListTask] {
        let context = persistentContainer.viewContext
        let request = TodoListTask.fetchRequest()
        do {
            let tasks = try context.fetch(request)
            return tasks
        } catch {
            print("\(error)")
            return []
        }
    }
    
    func updateTask(task: TodoListTask) {
        task.isDone.toggle()
        saveContext()
    }
    
    func deleteTask(task: TodoListTask) {
        let context = persistentContainer.viewContext
        context.delete(task)
        saveContext()
    }

}
