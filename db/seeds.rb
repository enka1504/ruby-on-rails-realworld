User.create([
  { username: "John", email: "john@email.com", password: "secret" },
  { username: "Steve", email: "steve@email.com", password: "secret" },
  { username: "Jenna", email: "jenna@email.com", password: "secret" }
])
Todo.destroy_all

# Create sample todos
todos = [
  {
    title: "Setup project repository",
    description: "Initialize Git repository and push to GitHub",
    status: "completed",
    priority: 3,
    due_date: 2.days.ago
  },
  {
    title: "Design database schema",
    description: "Create ERD and plan database tables",
    status: "in_progress",
    priority: 4,
    due_date: 1.day.from_now
  },
  {
    title: "Implement user authentication",
    description: "Add Devise or similar gem for user management",
    status: "pending",
    priority: 5,
    due_date: 3.days.from_now
  },
  {
    title: "Write API documentation",
    description: "Document endpoints using Swagger/OpenAPI",
    status: "pending",
    priority: 2,
    due_date: 5.days.from_now
  },
  {
    title: "Deploy to production",
    description: "Setup Heroku/Railway deployment pipeline",
    status: "pending",
    priority: 4,
    due_date: 7.days.from_now
  },
  {
    title: "Write unit tests",
    description: "Add RSpec tests for models and controllers",
    status: "pending",
    priority: 3,
    due_date: 4.days.from_now
  },
  {
    title: "Code review",
    description: "Review pull requests from team members",
    status: "pending",
    priority: 3,
    due_date: Time.current
  },
  {
    title: "Update README",
    description: "Add project documentation and setup instructions",
    status: "completed",
    priority: 1,
    due_date: 1.day.ago
  }
]

todos.each do |todo_attrs|
  Todo.create!(todo_attrs)
end

puts "Created #{Todo.count} sample todos"