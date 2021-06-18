class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    self.new.tap do |student|
      student.id = row[0]
      student.name = row[1]
      student.grade = row[2]
    end
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students;
    SQL
    DB[:conn].execute(sql)
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
      WHERE students.name = ?
      LIMIT 1;
    SQL
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
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

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students
      WHERE students.grade = 9;
    SQL

    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students
      WHERE students.grade < 12;
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.all
    sql = "SELECT * FROM students"
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_X_students_in_grade_10(input)
    sql = <<-SQL
      SELECT * FROM students
      WHERE students.grade = 10
      LIMIT ?;
    SQL
    DB[:conn].execute(sql, input).map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students
      WHERE students.grade = 10
      LIMIT 1;
    SQL
    self.new_from_db(DB[:conn].execute(sql)[0])
  end

  def self.all_students_in_grade_X(input)
    sql = <<-SQL
      SELECT * FROM students
      WHERE students.grade = ?;
    SQL
    DB[:conn].execute(sql, input).map do |row|
      self.new_from_db(row)
    end
  end

end

# .all_students_in_grade_9
#   returns an array of all students in grades 9 (FAILED - 1)
# .students_below_12th_grade
#   returns an array of all students in grades 11 or below (FAILED - 2)
# .all
#   returns all student instances from the db (FAILED - 3)
# .first_X_students_in_grade_10
#   returns an array of the first X students in grade 10 (FAILED - 4)
# .first_student_in_grade_10
#   returns the first student in grade 10 (FAILED - 5)
# .all_students_in_grade_X
#   returns an array of all students in a given grade X (FAILED - 6)
