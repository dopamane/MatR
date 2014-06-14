//
//  Matrix.h
//  MatR
//
//  Created by David Cox on 6/11/14.
//  Copyright (c) 2014 David Cox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Matrix : NSObject

@property (readonly) NSMutableArray *matrix;
@property (readonly) int rows, columns;

-(id) initWithArray:(NSMutableArray *) m andRows:(int) row byColumns:(int) col;
-(id) initWithValue:(NSNumber *) number andRows:(int) row byColumns:(int) col;
-(id) initWithContentsFromFile:(NSString *) filePath;

-(void) print;

-(Matrix *) insertColumn: (NSMutableArray *) column atColumnIndex:(int) index;
-(Matrix *) insertRow: (NSMutableArray *) row atRowIndex:(int) index;

-(Matrix *) addScalar: (NSNumber *) scalar;
-(Matrix *) subtractScalar: (NSNumber *) scalar;
-(Matrix *) multiplyScalar: (NSNumber *) scalar;
-(Matrix *) divideScalar:(NSNumber *) scalar;

-(Matrix *) addMatrix: (Matrix *) mat;
-(Matrix *) subtractMatrix: (Matrix *) mat;
-(Matrix *) multiplyMatrix: (Matrix *) mat;

-(Matrix *) transpose;
-(Matrix *) getColumnAtIndex:(int) index;
-(Matrix *) getRowAtIndex:(int) index;
-(Matrix *) getSubMatrixFromRow:(int) r1 toRow:(int)r2 andFromColumn:(int) c1 toColumn:(int) c2;

-(NSNumber *) sumRowAtIndex:(int) index;
-(NSNumber *) sumColumnAtIndex:(int) index;
-(NSNumber *) getElementAtRow: (int) row andColumn: (int) column;

-(void) setElementAtRow:(int) row andColumn: (int) column withObject:(NSNumber *) number;

@end