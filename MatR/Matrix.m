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

-(id) initWithArray:(NSMutableArray *) m andRows:(int) row byColumns: (int) col
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

-(id) initWithValue:(NSNumber *) number andRows:(int)row byColumns:(int)col
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

-(id) initWithContentsFromFile:(NSString *)filePath
{
    if (self = [super init])
    {
        NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        NSArray *allLinedStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        NSLog(@"%@", fileContents);
        
        matrix = [[NSMutableArray alloc] initWithCapacity:[allLinedStrings count]];
        
        for (int i = 0; i < [allLinedStrings count]; i++)
        {
            NSString *line = [allLinedStrings objectAtIndex:i];
            NSArray *comps = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [matrix addObject:[NSMutableArray arrayWithCapacity:[comps count]]];
            for (int j = 0; j < [comps count]; j++)
            {
                [[matrix objectAtIndex:i] addObject:[NSNumber numberWithDouble:[[comps objectAtIndex:j] doubleValue]]];
            }
        }
        rows = (int) [matrix count];
        columns = (int) [[matrix objectAtIndex:0] count];
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
        Matrix *temp_mat = [[Matrix alloc] initWithValue:0 andRows:rows byColumns:(columns+1)];
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
        Matrix *temp_mat = [[Matrix alloc] initWithValue:0 andRows:(rows+1) byColumns:columns];
        for (int r = 0; r < rows+1; r++)
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
        return [[Matrix alloc] initWithArray:temp_mat andRows:rows byColumns:columns];
    }
    return nil;
}

-(Matrix *) subtractMatrix:(Matrix *) mat
{
    return [self addMatrix:[mat multiplyScalar:[NSNumber numberWithDouble:(-1)]]];
}

-(Matrix *) addScalar:(NSNumber *) scalar
{
    return [self addMatrix:[[Matrix alloc] initWithValue:[NSNumber numberWithDouble:[scalar doubleValue]] andRows:rows byColumns:columns]];
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
    //return [[Matrix alloc] initWith:rows by:columns with:temp_mat];
    return [[Matrix alloc] initWithArray:temp_mat andRows:rows byColumns:columns];
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
        return [[Matrix alloc] initWithArray:temp_mat andRows:rows byColumns:[mat columns]];
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
    return [[Matrix alloc] initWithArray:temp_mat andRows:columns byColumns:rows];
}

-(Matrix *) getColumnAtIndex: (int) index
{
    if (index >= 0 && index < columns)
    {
        Matrix *temp_mat = [[Matrix alloc] initWithValue:0 andRows:rows byColumns:1];
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
        Matrix *temp_mat = [[Matrix alloc] initWithValue:0 andRows:1 byColumns:columns];
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
        Matrix *temp_mat = [[Matrix alloc] initWithValue:0 andRows:(r2-r1) byColumns:(c2-c1)];
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


