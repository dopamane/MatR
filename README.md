#MatR
##A Matrix Library for Objective-C
###MatR (pronounced like "matter") is a library of matrix operations written in Objective-C.
####Current operations supported include:
* Scalar Addition
* Scalar Subtraction
* Scalar Multiplication
* Scalar Division
* Matrix Addition
* Matrix Subtraction
* Matrix Multiplication
* Matrix Transposition

####Other capabilities include:
* Matrix Print (Correctly prints a matrix to the console with timestamps)
* Column Retrieval
* Row Retrieval
* Sub-Matrix Retrieval
* Row Summation
* Column Summation
* Single-Element Retrieval
* Single-Element Replacement

###Getting Started:
1. Download or Clone the git repository
2. Move the Matrix.m and Matrix.h files into your project
3. Import the Matrix.h header file into your code

####Creating a Matrix in MatR:
Currently there are three options to create a matrix.
The first option is to create a matrix of NSNumbers of the same value:
```Objective-C
/*Create a 3x4 Matrix of the value 5*/
Matrix *matrix = [[Matrix alloc] initWithValue:[NSNumber numberWithDouble:5] andRows:3 byColumns:4];

/* Results in:
5 5 5 5
5 5 5 5
5 5 5 5
*/
```
