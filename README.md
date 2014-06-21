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
Currently there are two options to create a matrix.
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

The second option is to create a matrix of NSNumbers from a .txt file:
```Objective-C
/*Text file
2 3 4 5
1 2 3 4
6 7 8 9
*/

/* Create matrix based on text file at location @"filepath" */
/* WARNING: MUST USE FULL FILE PATH e.g. /Users/davidcox95/XcodeProjects/MatR/MatR/matrix.txt*/
Matrix* matrix = [[Matrix alloc] initWithContentsFromFile:filepath];

/*matrix now contains the same matrix defined in the text file*/
```

###Supported Matrix Operations:
####Scalar Addition, Subtraction, Multiplication, and Division:
```Objective-C
Matrix* matrix = [[Matrix alloc] initWithValue:[NSNumber numberWithDouble:3] andRows:4 byColumns:3];
NSNumber *scalar = [NSNumber numberWithDouble:2];

/*Addition*/
Matrix *result = [matrix addScalar:scalar];
/*Result:
5 5 5
5 5 5
5 5 5
5 5 5
*/

/*Subtraction*/
scalar = [NSNumber numberWithDouble:2];
result = [matrix subtractScalar:scalar];
/*Result:
1 1 1
1 1 1
1 1 1
1 1 1
*/ 

/*Multiplication*/
scalar = [NSNumber numberWithDouble:2];
result = [matrix multiplyScalar:scalar];
/*Result:
6 6 6
6 6 6
6 6 6
6 6 6
*/

/*Division*/
scalar = [NSNumber numberWithDouble:2];
result = [matrix divideScalar:scalar];
/*Result:
1.5 1.5 1.5
1.5 1.5 1.5
1.5 1.5 1.5
1.5 1.5 1.5
*/
``` 
####Matrix Addition, Subtraction, and Multiplication:
```Objective-C
Matrix *m4 = [[Matrix alloc] initWithValue:[NSNumber numberWithDouble:4] andRows:3 byColumns:3];
Matrix *m2 = [[Matrix alloc] initWithValue:[NSNumber numberWithDouble:2] andRows:3 byColumns:3];

/*Addition*/
Matrix *result = [m4 addMatrix:m2];
/*Result:
6 6 6
6 6 6
6 6 6
*/

/*Subtraction*/
result = [m4 subtractMatrix:m2];
/*Result:
2 2 2
2 2 2
2 2 2
*/

/*Multiplication*/
result = [m4 multiplyMatrix:m2];
/*Result:
24 24 24
24 24 24
24 24 24
*/
```

####Matrix Transposition:
```Objective-C
Matrix *matrix = [[Matrix alloc] initWithContentsFromFile:@"yourPathToFile"];
/*Before:
5 6 7 8
3 4 5 6
1 2 3 4
*/

Matrix *result = [matrix transpose];
/*Result:
5 3 1
6 4 2
7 5 3
8 6 4
*/
```

