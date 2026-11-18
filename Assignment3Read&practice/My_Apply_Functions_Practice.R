# Apply Functions - My Practice
# Class work and practice at home
#
# I am using this file to practise the apply family in R.
# The examples use small datasets so I can follow the results.
#
# Main functions:
# apply(), lapply(), sapply(), vapply(), tapply(), mapply()
# I also included Map() for comparison.

# ==========================================================
# 1. GETTING STARTED
# ==========================================================

# I only need base R for these examples, so no package
# installation is required.

# A quick example of a normal loop:
values <- c(10, 20, 30, 40)

loop_result <- numeric(length(values))

for (i in seq_along(values)) {
  loop_result[i] <- values[i] * 2
}

loop_result

# I can do the same calculation directly with a vector.
values * 2

# The apply family helps me apply a function to data
# without writing a loop for every calculation.


# ==========================================================
# 2. apply()
# ==========================================================

# apply() is mainly used with matrices and arrays.
# Syntax: apply(X, MARGIN, FUN)
#
# X      = matrix or array
# MARGIN = 1 for rows, 2 for columns
# FUN    = function to apply

# I created a small marks matrix for three students.
marks_matrix <- matrix(
  c(70, 80, 90,
    60, 75, 85,
    88, 92, 95),
  nrow = 3,
  byrow = TRUE
)

rownames(marks_matrix) <- c("Student1", "Student2", "Student3")
colnames(marks_matrix) <- c("Math", "English", "Science")

marks_matrix

# Average mark for each student (row).
student_average <- apply(marks_matrix, MARGIN = 1, FUN = mean)
student_average

# Average mark for each subject (column).
subject_average <- apply(marks_matrix, MARGIN = 2, FUN = mean)
subject_average

# Total marks for each student.
student_total <- apply(marks_matrix, 1, sum)
student_total

# Highest mark in each subject.
subject_highest <- apply(marks_matrix, 2, max)
subject_highest

# I can also use a function I define myself.
# This calculates the difference between the highest and
# lowest mark in each row.
student_range <- apply(
  marks_matrix,
  MARGIN = 1,
  FUN = function(x) max(x) - min(x)
)
student_range


# ==========================================================
# 3. lapply()
# ==========================================================

# lapply() applies a function to every element of a list.
# It always returns a list.
#
# Syntax: lapply(X, FUN, ...)

# I made a list with different groups of marks.
marks_list <- list(
  Class_A = c(65, 70, 80, 85),
  Class_B = c(55, 60, 75, 90),
  Class_C = c(72, 78, 82, 88)
)

marks_list

# Find the average mark in each class.
class_averages_list <- lapply(marks_list, mean)
class_averages_list

# Find the highest mark in each class.
class_highest_list <- lapply(marks_list, max)
class_highest_list

# Find how many marks are recorded in each class.
class_counts <- lapply(marks_list, length)
class_counts

# lapply() returns a list, even when each answer is one number.
class_averages_list


# ==========================================================
# 4. sapply()
# ==========================================================

# sapply() works like lapply(), but it tries to simplify
# the result into a vector or matrix when possible.
#
# I use the same list to compare the outputs.

class_averages_vector <- sapply(marks_list, mean)
class_averages_vector

class_highest_vector <- sapply(marks_list, max)
class_highest_vector

# Check the output types.
class(class_averages_list)
class(class_averages_vector)


# ==========================================================
# 5. vapply()
# ==========================================================

# vapply() is similar to sapply(), but I specify the
# expected output type and length.
#
# numeric(1) means I expect one numeric result per list item.
# It is useful when I want R to check the result format.

class_average_checked <- vapply(
  marks_list,
  FUN = mean,
  FUN.VALUE = numeric(1)
)

class_average_checked

# Another example: expected result is one integer per class.
class_size_checked <- vapply(
  marks_list,
  FUN = length,
  FUN.VALUE = integer(1)
)

class_size_checked


# ==========================================================
# 6. tapply()
# ==========================================================

# tapply() applies a function to groups.
# Syntax: tapply(X, INDEX, FUN)
#
# X     = values to calculate
# INDEX = group variable
# FUN   = function to apply

student_data <- data.frame(
  Student = c("Aline", "Eric", "Jean", "Diane",
              "Peter", "Alice", "David", "Maya"),
  Gender = c("Female", "Male", "Male", "Female",
             "Male", "Female", "Male", "Female"),
  Marks = c(75, 60, 88, 45, 92, 81, 69, 95),
  Class = c("A", "A", "B", "A", "B", "B", "A", "B")
)

student_data

# Average marks by gender.
average_by_gender <- tapply(
  student_data$Marks,
  student_data$Gender,
  mean
)
average_by_gender

# Highest mark by class.
highest_by_class <- tapply(
  student_data$Marks,
  student_data$Class,
  max
)
highest_by_class

# Number of students in each class.
students_per_class <- tapply(
  student_data$Student,
  student_data$Class,
  length
)
students_per_class

# I can use more than one grouping variable.
# This calculates average marks by class and gender.
average_by_class_gender <- with(
  student_data,
  tapply(Marks, list(Class, Gender), mean)
)
average_by_class_gender


# ==========================================================
# 7. mapply()
# ==========================================================

# mapply() applies a function to corresponding elements
# of two or more inputs.
# It is useful when I have several arguments changing together.
#
# Example: add the matching values from two vectors.

first_numbers <- c(2, 4, 6, 8)
second_numbers <- c(10, 20, 30, 40)

added_numbers <- mapply(
  FUN = sum,
  first_numbers,
  second_numbers
)
added_numbers

# Another example: calculate the total of two matching
# groups of marks.
class_one <- list(c(10, 20), c(30, 40), c(50, 60))
class_two <- list(c(1, 2), c(3, 4), c(5, 6))

group_totals <- mapply(
  FUN = sum,
  class_one,
  class_two
)
group_totals


# ==========================================================
# 8. Map()
# ==========================================================

# Map() is similar to mapply(), but it always returns a list.
# Its first argument is named f, so I use f = sum below.
# It is useful when I want to apply a function to matching
# elements without simplifying the result.

map_result <- Map(
  f = sum,
  first_numbers,
  second_numbers
)
map_result

# Compare the result type with mapply().
class(map_result)
class(added_numbers)


# ==========================================================
# 9. COMPARING THE FUNCTIONS
# ==========================================================

# I used this section to remember the main differences.
#
# apply()  : rows or columns of a matrix/array
# lapply() : each element of a list; returns a list
# sapply() : like lapply(), tries to simplify the result
# vapply() : like sapply(), but expected output is specified
# tapply() : applies a function to groups
# mapply() : applies a function to multiple inputs
# Map()    : like mapply(), but returns a list

# Compare the average calculation using lapply, sapply
# and vapply.
compare_lapply <- lapply(marks_list, mean)
compare_sapply <- sapply(marks_list, mean)
compare_vapply <- vapply(marks_list, mean, numeric(1))

compare_lapply
compare_sapply
compare_vapply


# ==========================================================
# 10. PRACTICE QUESTIONS
# ==========================================================

# Try these questions before checking the examples above.
#
# 1. Create a 4 by 3 matrix of numbers.
#    Use apply() to calculate the mean of each row.
#
# 2. Use apply() to find the maximum value in each column.
#
# 3. Create a list containing three vectors of test marks.
#    Use lapply() to calculate the total for each vector.
#
# 4. Use sapply() to calculate the average of each vector.
#    Check the class of the result.
#
# 5. Use vapply() to calculate the length of each vector.
#    Set the expected result type correctly.
#
# 6. Create a data frame with Department and Salary columns.
#    Use tapply() to calculate average salary by department.
#
# 7. Use mapply() to add two vectors element by element.
#
# 8. Use Map() to repeat question 7 and compare the result.
#
# 9. Explain the difference between lapply() and sapply().
#
# 10. Explain when you would use apply() instead of tapply().

# End of my apply function practice.
