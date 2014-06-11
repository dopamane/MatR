//
//  Matrix.m
//  MatR
//
//  Created by David Cox on 6/11/14.
//  Copyright (c) 2014 David Cox. All rights reserved.
//

#import "Matrix.h"

@implementation Matrix

@synthesize matrix, rows, columns;

-(id) initWith: (int) row by: (int) col with: (NSMutableArray *) m
{
    if (self = [super init])
    {
        rows = row;
        columns = col;
        matrix = [[NSMutableArray alloc] initWithCapacity: rows];
        for (int r = 0; r < rows; r++)
        {
            [matrix addObject: [NSMutableArray arrayWithCapacity:columns]];
            for (int c = 0; c < columns; c++)
                [[matrix objectAtIndex:r] addObject:[NSNumber numberWithDouble:[[[m objectAtIndex: r] objectAtIndex:c] doubleValue]]];
        }
        
    }
    return self;
}

-(id) initValue: (int) row by: (int) col value: (NSNumber *) number
{
    if (self = [super init])
    {
        rows = row;
        columns = col;
        matrix = [[NSMutableArray alloc] initWithCapacity:rows];
        for (int r = 0; r < rows; r++)
        {
            [matrix addObject:[NSMutableArray arrayWithCapacity:columns]];
            for (int c = 0; c < columns; c++)
                [[matrix objectAtIndex:r] addObject:[NSNumber numberWithDouble:[number doubleValue]]];
        }
    }
    return self;
}

-(void) print
{
    NSMutableString *row_string = [[NSMutableString alloc] initWithCapacity: columns];
    for (int r = 0; r < rows; r++)
    {
        [row_string setString:@""];
        for (int c = 0; c < columns; c++)
            [row_string appendFormat:@"%@ ", [self getElementAtRow:r andColumn:c]];
        NSLog(@"%@\n", row_string);
    }
}

-(Matrix *) insertColumn:(NSMutableArray *) column atColumnIndex:(int) index
{
    if (index <= columns)
    {
        Matrix *temp_mat = [[Matrix alloc] initValue: rows by:(columns+1) value:0];
        for (int r = 0; r < rows; r++)
        {
            for (int c = 0, t=0; c < columns+1; c++)
            {
                if (c == index)
                {
                    [[[temp_mat matrix] objectAtIndex:r] replaceObjectAtIndex:c
                                                                   withObject: [NSNumber numberWithDouble:[[column objectAtIndex:r]doubleValue]]];
                }
                else
                {
                    [[[temp_mat matrix] objectAtIndex:r] replaceObjectAtIndex:c
                                                                   withObject:[NSNumber numberWithDouble:[[[matrix objectAtIndex:r] objectAtIndex:t]doubleValue]]];
                    t++;
                }
            }
        }
        return temp_mat;
    }
    return nil;
    
}

-(Matrix *) insertRow: (NSMutableArray *) row atRowIndex:(int) index
{
    if (index <= rows)
    {
        Matrix *temp_mat = [[Matrix alloc] initValue: (rows+1) by: columns value:0];
        for (int r = 0, t = 0; r < rows+1; r++)
        {
            for (int c = 0; c < columns; c++)
            {
                if (r == index)
                {
                    NSNumber *num = [NSNumber numberWithDouble:[[row objectAtIndex:c]doubleValue]];
                    [[[temp_mat matrix] objectAtIndex:r] replaceObjectAtIndex:c withObject:num];
                }
                else
                {
                    if (r > index)
                    {
                        NSNumber *num = [NSNumber numberWithDouble:[[[matrix objectAtIndex:(r-1)] objectAtIndex:c] doubleValue]];
                        [[[temp_mat matrix] objectAtIndex:r] replaceObjectAtIndex:c withObject:num];
                    }
                    else
                    {
                        NSNumber *num = [NSNumber numberWithDouble:[[[matrix objectAtIndex:r] objectAtIndex:c] doubleValue]];
                        [[[temp_mat matrix] objectAtIndex:r] replaceObjectAtIndex:c withObject:num];
                    }
                    
                }
            }
        }
        return temp_mat;
    }
    return nil;
    
}

-(Matrix *) addMatrix:(Matrix *) m
{
    if (rows == [m rows] && columns == [m columns])
    {
        NSNumber *num1, *num2;
        NSMutableArray *temp_mat = [[NSMutableArray alloc] initWithCapacity:rows];
        for (int r = 0; r < rows; r++)
        {
            [temp_mat addObject:[NSMutableArray arrayWithCapacity:columns]];
            for (int c = 0; c < columns; c++)
            {
                num1 = [self getElementAtRow:r andColumn:c];
                num2 = [m getElementAtRow:r andColumn:c];
                [[temp_mat objectAtIndex:r] addObject:[NSNumber numberWithDouble:([num1 doubleValue] + [num2 doubleValue])]];
            }
        }
        return [[Matrix alloc] initWith: rows by: columns with:temp_mat];
    }
    return nil;
}

-(Matrix *) subtractMatrix:(Matrix *) mat
{
    return [self addMatrix:[mat multiplyScalar:[NSNumber numberWithDouble:(-1)]]];
}

-(Matrix *) addScalar:(NSNumber *) scalar
{
    return [self addMatrix:[[Matrix alloc] initValue: rows by: columns value:[NSNumber numberWithDouble:[scalar doubleValue]]]];
}

-(Matrix *) subtractScalar:(NSNumber *) scalar
{
    return [self addScalar:[NSNumber numberWithDouble:(-1 * [scalar doubleValue])]];
}

-(Matrix *) multiplyScalar:(NSNumber *) scalar
{
    NSMutableArray *temp_mat = [[NSMutableArray alloc] initWithCapacity:rows];
    for (int r = 0; r < rows; r++)
    {
        [temp_mat addObject:[NSMutableArray arrayWithCapacity:columns]];
        for (int c = 0; c < columns; c++)
        {
            NSNumber *num = [self getElementAtRow:r andColumn:c];
            NSNumber *result = [NSNumber numberWithDouble:([num doubleValue] * [scalar doubleValue])];
            [[temp_mat objectAtIndex:r] addObject:result];
        }
    }
    return [[Matrix alloc] initWith:rows by:columns with:temp_mat];
}

-(Matrix *) divideScalar:(NSNumber *) scalar
{
    return [self multiplyScalar:[NSNumber numberWithDouble:(1.0/[scalar doubleValue])]];
}

-(Matrix *) multiplyMatrix:(Matrix *) mat
{
    if (columns == [mat rows])
    {
        NSMutableArray *temp_mat = [NSMutableArray arrayWithCapacity:rows];
        for (int r = 0; r < rows; r++)
        {
            [temp_mat addObject:[NSMutableArray arrayWithCapacity:[mat columns]]];
            for (int c = 0; c < [mat columns]; c++)
            {
                NSNumber *sum = [NSNumber numberWithDouble:0];
                for (int i = 0; i < [mat rows]; i++)
                {
                    sum = [NSNumber numberWithDouble:([sum doubleValue] +
                                                      [[self getElementAtRow:r andColumn:i] doubleValue] *
                                                      [[mat getElementAtRow:i andColumn:c] doubleValue])];
                }
                [[temp_mat objectAtIndex:r]addObject:[NSNumber numberWithDouble:[sum doubleValue]]];
            }
        }
        return [[Matrix alloc] initWith: rows by:[mat columns] with: temp_mat];
    }
    return nil;
}

-(Matrix *) transpose
{
    NSMutableArray *temp_mat = [[NSMutableArray alloc] initWithCapacity:columns];
    for (int r = 0; r < columns; r++)
        [temp_mat addObject:[NSMutableArray arrayWithCapacity:rows]];
    
    for (int r = 0; r < rows; r++)
        for (int c = 0; c < columns; c++)
        {
            NSNumber *value = [NSNumber numberWithDouble:[[self getElementAtRow:r andColumn:c]doubleValue]];
            [[temp_mat objectAtIndex:c] insertObject:value atIndex:r];
        }
    return [[Matrix alloc] initWith: columns by: rows with: temp_mat];
}

-(Matrix *) getColumnAtIndex: (int) index
{
    if (index >= 0 && index < columns)
    {
        Matrix *temp_mat = [[Matrix alloc] initValue: rows by:1 value:0];
        for (int r = 0; r < rows; r++)
            [[[temp_mat matrix] objectAtIndex:r] replaceObjectAtIndex:0 withObject:[NSNumber numberWithDouble:[[self getElementAtRow:r andColumn:index]doubleValue]]];
        return temp_mat;
    }
    return nil;
}

-(Matrix *) getRowAtIndex: (int) index
{
    if (index >= 0 && index < rows)
    {
        Matrix *temp_mat = [[Matrix alloc] initValue: 1 by: columns value:0];
        for (int c = 0; c < columns; c++)
            [[[temp_mat matrix] objectAtIndex:0] replaceObjectAtIndex:c withObject:[NSNumber numberWithDouble:[[self getElementAtRow:index andColumn:c]doubleValue]]];
        return temp_mat;
    }
    return nil;
}

-(Matrix *) getSubMatrixFromRow:(int) r1 toRow:(int) r2 andFromColumn:(int) c1 toColumn:(int) c2
{
    if (r2 > r1 && c2 > c1)
    {
        Matrix *temp_mat = [[Matrix alloc] initValue:(r2-r1) by:(c2-c1) value:0];
        for (int r = r1; r < r2; r++)
            for (int c = c1; c < c2; c++)
                [temp_mat setElementAtRow:(r-r1) andColumn:(c-c1) withObject:[self getElementAtRow:r andColumn:c]];
        return temp_mat;
        
    }
    return nil;
}

-(NSNumber *) sumRowAtIndex: (int) index
{
    if (index < rows && index >= 0)
    {
        NSNumber *sum = [NSNumber numberWithDouble:0];
        for (int c = 0; c < columns; c++)
            sum = [NSNumber numberWithDouble:([sum doubleValue] + [[self getElementAtRow:index andColumn:c]doubleValue])];
        return sum;
    }
    return nil;
}

-(NSNumber *) sumColumnAtIndex: (int) index
{
    if (index >= 0 && index < columns)
    {
        NSNumber *sum = [NSNumber numberWithDouble:0];
        for (int r = 0; r < rows; r++)
            sum = [NSNumber numberWithDouble:([sum doubleValue] + [[self getElementAtRow:r andColumn:index]doubleValue])];
        return sum;
    }
    return nil;
}

-(NSNumber *) getElementAtRow:(int) row andColumn:(int) column
{
    if (row >= 0 && row < rows && column >= 0 && column < columns)
        return [[matrix objectAtIndex:row]objectAtIndex:column];
    return nil;
}

-(void) setElementAtRow:(int) row andColumn:(int) column withObject:(NSNumber *) number
{
    if (row >= 0 && row < rows && column >= 0 && column < columns)
        [[matrix objectAtIndex:row] replaceObjectAtIndex:column withObject:[NSNumber numberWithDouble:[number doubleValue]]];
}

@end

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
        
        Matrix *matrix1 = [[Matrix alloc] initWith: rows by: cols with: m1];
        [matrix1 print];
        
        NSLog(@"\n");
        
        NSMutableArray *m2 = [[NSMutableArray alloc] initWithCapacity: rows];
        NSMutableArray *row2 = [[NSMutableArray alloc] initWithCapacity: cols];
        for (int c = 0; c < cols; c++)
            [row2 addObject: [NSNumber numberWithInt: c+2]];
        for (int i = 0; i < rows; i++)
            [m2 addObject: row2];
        
        Matrix *matrix2 = [[Matrix alloc] initWith:rows by:cols with:m2];
        [[[matrix2 matrix] objectAtIndex:1] replaceObjectAtIndex:2 withObject:[NSNumber numberWithDouble:16]];
        [matrix2 print];
        
        NSLog(@"\n");
        
        Matrix *matrix3 = [matrix2 transpose];
        [matrix3 print];
        
        NSLog(@"\n");
        
        Matrix *matrix4 = [[Matrix alloc] initValue: 3 by: 2 value:[NSNumber numberWithInteger:2]];
        [matrix4 print];
        NSLog(@"\n");
        
        Matrix *matrix5 = [[Matrix alloc] initValue: 2 by: 4 value:[NSNumber numberWithInteger:4]];
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
