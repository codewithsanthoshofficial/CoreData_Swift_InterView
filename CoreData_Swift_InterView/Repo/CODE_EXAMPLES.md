# CoreDataSwift - interview Code examples 




#2. CRUD Operations

Create (Add Employee)
-----------------------

func addEmployee(id: Int64, name: String, email: String, department: String) {
    let employee = Employee(context: context)
    employee.id = id
    employee.name = name
    employee.email = email
    employee.department = department
    
    do {
        try context.save()
        print("✅ Employee added successfully")
    } catch {
        print("❌ Failed to save: \(error)")
    }
}


Read (Fetch Employees)
----------------------
func fetchEmployees() -> [Employee] {
    let request: NSFetchRequest<Employee> = Employee.fetchRequest()
    
    do {
        return try context.fetch(request)
    } catch {
        print("❌ Fetch failed: \(error)")
        return []
    }
}


Update Employee
----------------

func updateEmployee(employee: Employee, newName: String, newEmail: String) {
    employee.name = newName
    employee.email = newEmail
    
    do {
        try context.save()
        print("✅ Employee updated successfully")
    } catch {
        print("❌ Update failed: \(error)")
    }
}


Delete Employee
-------------------

func deleteEmployee(employee: Employee) {
    context.delete(employee)
    
    do {
        try context.save()
        print("✅ Employee deleted successfully")
    } catch {
        print("❌ Delete failed: \(error)")
    }
}




#2. NSPersistentStoreCoordinator
* Manages communication between contexts and persistent store
* Coordinates multiple persistent stores if needed
* Handles locking and thread safety

let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
let store = try coordinator.addPersistentStore(
    ofType: NSSQLiteStoreType,
    configurationName: nil,
    at: storeURL,
    options: nil
)


#3. NSManagedObjectContext
*The "scratch pad" where all work happens
*Tracks changes to objects
*Handles save/fetch operations
*Should be accessed from its designated thread only

let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
context.persistentStoreCoordinator = coordinator


# 4. NSPersistentContainer (Modern Approach)

*Encapsulates all above components
*Simplifies initialization
*Recommended approach for iOS 10+

let container = NSPersistentContainer(name: "SampleModel")
container.loadPersistentStores { _, error in
    if let error = error {
        fatalError("Could not load Core Data stack: \(error)")
    }
}
let context = container.viewContext

#Stack Diagram:
┌─────────────────────────────────────┐
│     NSManagedObjectContext          │
│   (Main/Background Thread)          │
└────────────────┬────────────────────┘
                 │
┌────────────────▼────────────────────┐
│  NSPersistentStoreCoordinator       │
│   (Manages Store Communication)     │
└────────────────┬────────────────────┘
                 │
┌────────────────▼────────────────────┐
│   Persistent Store (SQLite File)    │
└─────────────────────────────────────┘


#Q3: What is NSManagedObject and NSManagedObjectContext?
--------------------------------------------------------------------

NSManagedObject:
-------------
Base class for all Core Data entities
Represents a single record in your database
Tracks changes automatically
Can be created as NSManagedObject subclass or used directly

class Employee: NSManagedObject {
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var department: String?
}


NSManagedObjectContext:
------------------
*Works like a "transaction" or "scratch pad"
*Tracks all changes made to managed objects
*Changes are not permanent until saved
*Each context has its own thread


let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

// Create a new employee
let employee = NSEntityDescription.insertNewObject(
    forEntityName: "Employee",
    into: context
) as! Employee

employee.name = "John Doe"
employee.email = "john@example.com"

// Changes are tracked but not saved to disk yet
// Save to persist changes
try? context.save()


#Practical Questions

Q4: How do you fetch data from Core Data? What is NSPredicate?
----------------------------------------------

Answer: Fetching uses NSFetchRequest with optional filtering via NSPredicate.

Basic Fetch (All Records):
---
let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()

do {
    let employees = try context.fetch(fetchRequest)
    print("Fetched \(employees.count) employees")
} catch {
    print("Fetch error: \(error)")
}

Fetch with Predicate (Filtering):
----
// Filter: Find employees in "Engineering" department
let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
fetchRequest.predicate = NSPredicate(format: "department == %@", "Engineering")

let engineeringEmployees = try? context.fetch(fetchRequest)


Predicate Examples:
----

// String comparison
NSPredicate(format: "name == %@", "John Doe")

// Contains (case-insensitive)
NSPredicate(format: "name CONTAINS[cd] %@", "john")

// Number comparison
NSPredicate(format: "id > %d", 5)

// Between range
NSPredicate(format: "id BETWEEN {1, 100}")

// Multiple conditions (AND)
NSPredicate(format: "department == %@ AND name CONTAINS[cd] %@", "Engineering", "john")

// OR condition
NSPredicate(format: "department == %@ OR department == %@", "Engineering", "Sales")

// NOT condition
NSPredicate(format: "NOT (department == %@)", "HR")




Fetch with Sorting:
----

let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()

// Sort by name ascending
let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
fetchRequest.sortDescriptors = [sortDescriptor]

// Multiple sort criteria
fetchRequest.sortDescriptors = [
    NSSortDescriptor(key: "department", ascending: true),
    NSSortDescriptor(key: "name", ascending: true)
]

let sorted = try? context.fetch(fetchRequest)



Fetch with Limit and Offset:
----
let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
fetchRequest.fetchLimit = 10      // Get first 10
fetchRequest.fetchOffset = 20     // Skip first 20

let paginated = try? context.fetch(fetchRequest)


Advanced: Fetch with Result Count Only:
----
let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
fetchRequest.returnsObjectsAsFaults = false
fetchRequest.fetchLimit = 1  // Just check if exists

let count = try? context.count(for: fetchRequest)
print("Total employees: \(count ?? 0)")


Q5: How do you save, update, and delete objects in Core Data?
-----------------------------------
Save:
---

let employee = Employee(context: context)
employee.name = "Jane Doe"
employee.email = "jane@example.com"

do {
    try context.save()
    print("✅ Saved successfully")
} catch {
    print("❌ Save failed: \(error)")
}


Update:
---
// Fetch the object first
let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
fetchRequest.predicate = NSPredicate(format: "id == %d", 1)

if let employee = try? context.fetch(fetchRequest).first {
    employee.name = "Updated Name"
    try? context.save()
    print("✅ Updated successfully")
}

Delete:
---

// Fetch and delete
let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
fetchRequest.predicate = NSPredicate(format: "id == %d", 1)

if let employee = try? context.fetch(fetchRequest).first {
    context.delete(employee)
    try? context.save()
    print("✅ Deleted successfully")
}

Batch Delete (Efficient for many records):
----

let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Employee")
fetchRequest.predicate = NSPredicate(format: "department == %@", "Terminated")

let batchDelete = NSBatchDeleteRequest(fetchRequest: fetchRequest)
batchDelete.resultType = .resultTypeCount

do {
    let result = try context.execute(batchDelete) as? NSBatchDeleteResult
    print("Deleted \(result?.result ?? 0) records")
} catch {
    print("Batch delete failed: \(error)")
}


Q6: What is NSFetchedResultsController? When would you use it?
----------------------------------------------------------
Answer: NSFetchedResultsController is a controller that manages fetch results for UITableView and UICollectionView. It automatically monitors Core Data changes and notifies the view controller for UI updates.

Key Benefits:

✅ Automatic UITableView/UICollectionView synchronization
✅ Efficient memory management (fault handling)
✅ Change notifications (insert, delete, update, move)
✅ Section grouping support
✅ Built-in caching

class EmployeeViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController<Employee>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
    }
    
    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "department", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataManager.shared.context,
            sectionNameKeyPath: "department",  // Group by department
            cacheName: "employeeCache"
        )
        
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("Fetch failed: \(error)")
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                   didChange anObject: Any,
                   at indexPath: IndexPath?,
                   for type: NSFetchedResultsChangeType,
                   newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                tableView.moveRow(at: indexPath, to: newIndexPath)
            }
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell", for: indexPath)
        
        if let employee = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = employee.name
            cell.detailTextLabel?.text = employee.email
        }
        
        return cell
    }
}



#Advanced Questions

Q7: How do you handle relationships in Core Data?
-------------------------------------------
Answer: Core Data supports three types of relationships:
1. One-to-One Relationship
---
Example: Each Employee has one Manager

// In data model: Employee.manager (To-One) <--> Manager.subordinates (To-Many)

class Employee: NSManagedObject {
    @NSManaged public var name: String?
    @NSManaged public var manager: Employee?  // One-to-one
}

class Manager: NSManagedObject {
    @NSManaged public var name: String?
    @NSManaged public var subordinates: NSSet?  // One-to-many (inverse)
}



2.One-to-Many Relationship
---
Example: Each Department has many Employees

class Department: NSManagedObject {
    @NSManaged public var name: String?
    @NSManaged public var employees: NSSet?  // One-to-many
}

class Employee: NSManagedObject {
    @NSManaged public var name: String?
    @NSManaged public var department: Department?  // Many-to-one (inverse)
}

// Usage:
let department = ...
let employee = Employee(context: context)
employee.name = "John"
employee.department = department  // Set relationship

// Or using helper method
department.addToEmployees(employee)


3. Many-to-Many Relationship
---
Best Practices:

*Always define inverse relationships in the data model
*Use NSSet for to-many relationships
*Use NSOrderedSet if order matters
*Delete rules: None, Cascade, Deny, Nullify



Example: Employees can belong to multiple Projects

class Employee: NSManagedObject {
    @NSManaged public var name: String?
    @NSManaged public var projects: NSSet?  // Many-to-many
}

class Project: NSManagedObject {
    @NSManaged public var title: String?
    @NSManaged public var employees: NSSet?  // Many-to-many (inverse)
}

// Usage:
let employee = ...
let project = ...

// Add employee to project
project.addToEmployees(employee)
// Automatically adds project to employee's projects

// Remove
project.removeFromEmployees(employee)


Q8: Describe Core Data migration. What are lightweight and heavyweight migrations?
------------------------------------------
Answer: When your data model changes (add property, change type), you need to migrate existing data.

Lightweight Migration
--
*Automatic
*Works for simple changes: add/remove attribute, change optional/required, add entity
*Cannot: change attribute types, rename attributes (need mapping model)

Setup (NSPersistentContainer):
---
let container = NSPersistentContainer(name: "SampleModel")

let description = NSPersistentStoreDescription()
description.url = storeURL
description.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
description.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)

container.persistentStoreDescriptions = [description]

container.loadPersistentStores { _, error in
    if let error = error {
        fatalError("Lightweight migration failed: \(error)")
    }
}


Heavyweight Migration

*Manual process
*For complex changes: rename attribute, change type, custom transformation logic
*Requires creating a mapping model

Steps:

*Keep old model version (.xcdatamodel)
*Create new model version (File → Add Files → New Data Model Version)
*Make changes to new version
*Create Mapping Model (File → New → Mapping Model)
*Select source and destination models
*Configure attribute mappings
*Add custom migration code if needed:

code
--
let mapping = NSEntityMapping()
mapping.name = "EmployeeToEmployeeV2"
mapping.sourceEntityName = "Employee"
mapping.destinationEntityName = "Employee"

// Custom transformation
mapping.attributeMappings = [
    "oldAttribute": NSPropertyDescription(),
    // Map old to new with transformation
]

let migrationPolicy = NSEntityMigrationPolicy()
// Override methods for custom logic
mapping.entityMigrationPolicyClassName = String(describing: type(of: migrationPolicy))

let model = NSMappingModel(from: [Bundle.main], forSourceModel: sourceModel, destinationModel: destinationModel)
model?.entityMappings = [mapping]

let migrationManager = NSMigrationManager(sourceModel: sourceModel, destinationModel: destinationModel)
try migrationManager.migrateStore(from: sourceURL, sourceType: NSSQLiteStoreType, options: nil, with: model, toDestinationURL: destinationURL, destinationType: NSSQLiteStoreType, destinationOptions: nil)




Q9: How does Core Data handle concurrency?
----------------
Answer: Core Data is not thread-safe. Each NSManagedObjectContext must be accessed only from its designated thread/queue.


Concurrency Types:
--
// Main Queue (UI thread)
let mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

// Private Queue (background thread)
let backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

// Confinement (no queue, manual threading)
let confinementContext = NSManagedObjectContext(concurrencyType: .confinementConcurrencyType)


Safe Access Using perform/performAndWait:
--
// Asynchronous
backgroundContext.perform {
    let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
    if let employees = try? backgroundContext.fetch(fetchRequest) {
        print("Fetched: \(employees.count)")
    }
}

// Synchronous (blocks until complete)
var result: [Employee]?
backgroundContext.performAndWait {
    let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
    result = try? backgroundContext.fetch(fetchRequest)
}

Parent-Child Context Pattern:
---
let container = NSPersistentContainer(name: "SampleModel")
container.loadPersistentStores { _, _ in }

// Main context (UI)
let mainContext = container.viewContext

// Background context (child of main)
let backgroundContext = container.newBackgroundContext()
backgroundContext.parent = mainContext

// Long-running operation on background
backgroundContext.perform {
    // Fetch/modify on background
    let employee = Employee(context: backgroundContext)
    employee.name = "New Employee"
    
    try? backgroundContext.save()  // Save to parent (main context)
    
    // Update UI on main thread
    DispatchQueue.main.async {
        // UI updates here
    }
}


Never Pass NSManagedObject Across Contexts:
---

// ❌ WRONG - Object from one context passed to another
let employee = fetchedFromContext1  // From mainContext
try backgroundContext.save()        // Won't work correctly

// ✅ RIGHT - Pass objectID instead
let employeeID = employee.objectID
backgroundContext.perform {
    let employee = backgroundContext.object(with: employeeID)
    // Use employee in backgroundContext
}


Q10: What is "faulting" in Core Data?
-----------
Answer: Faulting is a mechanism where Core Data represents an object with only its objectID and relationships loaded, deferring property data until accessed.

Benefits:

*Saves memory (don't load all data for all objects)
*Faster initial fetch
*Automatic loading when needed


// After fetch
let employee = employees.first  // This is a fault initially

print(employee.name)  // Fault fires here - Core Data fetches the name


Controlling Faults:
---
// Don't return faults - load all data
let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
fetchRequest.returnsObjectsAsFaults = false

// Fire faults manually
let employee = ...
context.refresh(employee, mergeChanges: true)

// Check if object is fault
if employee.isFault {
    print("Object is a fault - data not loaded yet")
}



#Code Examples

Complete CoreDataManager Class
