
---

### **File 2: INTERVIEW_GUIDE.md** (Complete Interview Q&A)
```markdown name=INTERVIEW_GUIDE.md
# Core Data Interview Guide - Complete Q&A

## Table of Contents
1. [Basic Questions](#basic-questions)
2. [Practical Questions](#practical-questions)
3. [Advanced Questions](#advanced-questions)
4. [Code Examples](#code-examples)

---

## Basic Questions

### Q1: What is Core Data? How is it different from SQLite or Realm?

**Answer:**
Core Data is Apple's **object graph management and persistence framework** for iOS, macOS, watchOS, and tvOS. It's not a database but rather an abstraction layer that manages model objects in your application.

**Key Differences:**

| Feature | Core Data | SQLite | Realm |
|---------|-----------|--------|-------|
| **Type** | Object Graph Manager | Relational Database | Document Database |
| **Apple Integration** | Deep, native integration | Basic | Third-party |
| **Relationship Handling** | Built-in, automatic | Manual queries | Built-in |
| **Data Validation** | Automatic | Manual | Manual |
| **Learning Curve** | Steeper | Moderate | Moderate |
| **Performance** | Optimized for iOS | Fast | Very fast |

**When to use Core Data:**
- iOS/macOS specific apps
- Need tight integration with Apple frameworks
- Complex relationships and object graphs
- Want automatic change tracking

---

### Q2: Explain the Core Data Stack and its main components

**Answer:**
The Core Data stack consists of 4 main components that work together:

#### 1. **NSManagedObjectModel**
- Describes your data model (entities, attributes, relationships)
- Loaded from `.xcdatamodeld` file
- Created at startup

```swift
guard let modelURL = Bundle.main.url(forResource: "SampleModel", withExtension: "momd"),
      let model = NSManagedObjectModel(contentsOf: modelURL) else {
    fatalError("Could not load data model")
}
