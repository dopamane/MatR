//
//  main.m
//  MatR
//
//  Created by David Cox on 6/11/14.
//  Copyright (c) 2014 David Cox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Matrix.h"

int main(int argc, const char * argv[])
{
    
    @autoreleasepool {
        
        int rows = 5, cols = 4;
        NSMutableArray *m1 = [[ NSMutableArray alloc] initWithCapacity: rows];
        NSMutableArray *row1 = [[NSMutableArray alloc] initWithCapacity: cols];
        
        for (int c = 0; c < cols; c++)
            [row1 addObject: [NSNumber numberWithInt: c+1]];
        
        for (int i = 0; i < rows; i++)
            [m1 addObject: row1];
        
        //Matrix *matrix1 = [[Matrix alloc] initWith: rows by: cols with: m1];
        Matrix *matrix1 = [[Matrix alloc] initWithArray:m1 andRows:rows byColumns:cols];
        [matrix1 print];
        
        NSLog(@"\n");
        
        NSMutableArray *m2 = [[NSMutableArray alloc] initWithCapacity: rows];
        NSMutableArray *row2 = [[NSMutableArray alloc] initWithCapacity: cols];
        for (int c = 0; c < cols; c++)
            [row2 addObject: [NSNumber numberWithInt: c+2]];
        for (int i = 0; i < rows; i++)
            [m2 addObject: row2];
        
        Matrix *matrix2 = [[Matrix alloc] initWithArray:m2 andRows:rows byColumns:cols];
        [[[matrix2 matrix] objectAtIndex:1] replaceObjectAtIndex:2 withObject:[NSNumber numberWithDouble:16]];
        [matrix2 print];
        
        NSLog(@"\n");
        
        Matrix *matrix3 = [matrix2 transpose];
        [matrix3 print];
        
        NSLog(@"\n");
        
        //Matrix *matrix4 = [[Matrix alloc] initValue: 3 by: 2 value:[NSNumber numberWithInteger:2]];
        Matrix *matrix4 = [[Matrix alloc] initWithValue:[NSNumber numberWithInteger:2] andRows:3 byColumns:2];
        [matrix4 print];
        NSLog(@"\n");
        
        //Matrix *matrix5 = [[Matrix alloc] initValue: 2 by: 4 value:[NSNumber numberWithInteger:4]];
        Matrix *matrix5 = [[Matrix alloc] initWithValue:[NSNumber numberWithDouble:4] andRows:2 byColumns:4];
        [matrix5 print];
        NSLog(@"\n");
        
        Matrix *matrix6 = [matrix4 multiplyMatrix:matrix5];
        [matrix6 print];
        NSLog(@"\n");
        
        NSMutableArray *row = [NSMutableArray arrayWithCapacity:4];
        [row addObject:[NSNumber numberWithDouble:3]];
        [row addObject:[NSNumber numberWithDouble:4]];
        [row addObject:[NSNumber numberWithDouble:5]];
        [row addObject:[NSNumber numberWithDouble:6]];
        Matrix *matrix7 = [matrix6 insertRow:row atRowIndex:1];
        [matrix7 print];
        
        NSLog(@"\n");
        
        NSLog(@"%@\n",[matrix7 sumColumnAtIndex:0]);
        NSLog(@"%@\n",[matrix7 sumRowAtIndex:1]);
        NSLog(@"\n");
        
        [[matrix7 getColumnAtIndex:1] print];
        
        NSLog(@"\n");
        
        [[matrix7 getRowAtIndex:1] print];
        
        NSLog(@"\n");
        NSLog(@"%@", [matrix7 getElementAtRow:1 andColumn:2]);
        NSLog(@"\n");
        [[matrix7 getSubMatrixFromRow:1 toRow:3 andFromColumn:1 toColumn:3] print];
    }
    return 0;
}

