
class Student
  attr_accessor :name, :grade, :id
  def initialize(name=nil, grade=nil, id = nil)
    @name = name
    @grade = grade
    @id = id
  end 
  
  def self.create_table
    sql_create = "CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade INTEGER)"
    DB[:conn].execute(sql_create)
  end
  
  def self.drop_table
    sql_delete = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql_delete)
  end 
  
  def save
    sql_insert = "INSERT INTO students (name, grade) VALUES (?,?)"
    DB[:conn].execute(sql_insert, @name, @grade)
  end
  
  def self.create(student_hash) 
    new_student = Student.new
    student_hash.each do |attr, value|
      new_student.send("#{attr}=", value)
    end
    new_student.save
    new_student
  end
  
  def self.new_from_db(row)
    new_student = self.new(row[1], row[2], row[0])
    new_student.save
    new_student
  end
  
  def self.all
    all = []
    sql_all = "SELECT * FROM students"
    all_students = DB[:conn].execute(sql_all)
    all_students.each do |student|
      new_student = Student.new_from_db(student)
      all << new_student
    end
    all
  end
  
  def self.find_by_name(name)
    found = self.all.find{|student| student.name = name}
  end
  
  def self.all_students_in_grade_9
    grade_9_students = self.all.select{|student| student.grade == 9}
  end 
  
  def self.students_below_12th_grade
    not_seniors = self.all.select{|student| student.grade < 12}
  end
  
  def self.first_X_students_in_grade_10(x)
    students = self.all.select{|student| student.grade == 10}[0..x-1]
  end
  
  def self.first_student_in_grade_10 
    sql = "SELECT * FROM students WHERE grade = 10 ORDER BY id LIMIT 1"
    student_info = DB[:conn].execute(sql)
    first_student = self.new_from_db(student_info.flatten)
    first_student
  end
  
  def self.all_students_in_grade_X(x)
    students = self.all.select{|student| student.grade == x}
  end
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  
end

