# frozen_string_literal: true

class Student
  attr_accessor :id, :name, :grade

  # @return [Student]
  def self.new_from_db(data)
    student       = new
    student.id    = data[0]
    student.name  = data[1]
    student.grade = data[2]
    student
  end

  # @return [Object]
  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
    SQL

    DB[:conn].execute(sql).map(&method(:new_from_row))
  end

  def self.new_from_row(row)
    new_from_db(row)
  end

  # @return [Object]
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map(&method(:new_from_row)).first
  end

  # @return [Object]
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, name, grade)
  end

  # @return [Object]
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  # @return [Object]
  def self.drop_table
    sql = 'DROP TABLE IF EXISTS students'

    DB[:conn].execute(sql)
  end

  # @return [Object]
  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade < 12
    SQL

    DB[:conn].execute(sql).map(&method(:new_from_row))
  end

  # @return [Object]
  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT COUNT(*)
      FROM students
      WHERE grade = 9;
    SQL

    DB[:conn].execute(sql).map(&method(:new_from_row))
  end

  # @return [Object]
  def self.first_X_students_in_grade_10(number)
    sql = <<-SQL
      SELECT grade
      FROM students
      WHERE grade = 10
      ORDER BY students.id
      LIMIT ?
    SQL

    DB[:conn].execute(sql, number).map(&method(:new_from_row))
  end

  # @return [Object]
  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      ORDER BY students.id LIMIT 1
    SQL

    DB[:conn].execute(sql).map(&method(:new_from_row)).first
  end

  # @return [Object]
  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT grade
      FROM students
      WHERE grade = ?
      ORDER BY students.id
    SQL

    DB[:conn].execute(sql, grade).map(&method(:new_from_row))
  end
end