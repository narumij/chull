//
//  chull.h
//  chull
//
//  Created by narumij on 2021/10/02.
//

/*
 This code is described in "Computational Geometry in C" (Second Edition),
 Chapter 4.  It is not written to be comprehensible without the
 explanation in that book.
 
 Input: 3n integer coordinates for the points.
 Output: the 3D convex hull, in postscript with embedded comments
 showing the vertices and faces.
 
 Compile: gcc -o chull chull.c (or simply: make)
 
 Written by Joseph O'Rourke, with contributions by
 Kristy Anderson, John Kutcher, Catherine Schevon, Susan Weller.
 Last modified: May 2000
 Questions to orourke@cs.smith.edu.
 
 --------------------------------------------------------------------
 This code is Copyright 2000 by Joseph O'Rourke.  It may be freely
 redistributed in its entirety provided that this copyright notice is
 not removed.
 --------------------------------------------------------------------
 */

#import <Foundation/Foundation.h>
#import <simd/simd.h>

/* Define structures for vertices, edges and faces */
typedef struct tVertexStructure tsVertex;
typedef tsVertex *tVertex;

typedef struct tEdgeStructure tsEdge;
typedef tsEdge *tEdge;

typedef struct tFaceStructure tsFace;
typedef tsFace *tFace;

struct tVertexStructure {
    float      v[3];
    int        vnum;
    tEdge    duplicate;            /* pointer to incident cone edge (or NULL) */
    bool     onhull;        /* T iff point on hull. */
    bool        mark;        /* T iff point already processed. */
    tVertex  next, prev;
    
    const void *opaque;
};

struct tEdgeStructure {
    tFace    adjface[2];
    tVertex  endpts[2];
    tFace    newface;            /* pointer to incident cone face. */
    bool     delete;        /* T iff edge should be delete. */
    tEdge    next, prev;
};

struct tFaceStructure {
    tEdge    edge[3];
    tVertex  vertex[3];
    bool        visible;            /* T iff face visible from new point. */
    tFace    next, prev;
};

#if 0
extern tVertex vertices;
extern tEdge edges;
extern tFace faces;
extern bool debug;
extern bool check;
#endif

// MARK: -

typedef struct tsConvexHullStructure {
    tVertex vertices;
    tEdge edges;
    tFace faces;
    bool debug;
    bool check;
} tsConvexHull;

typedef tsConvexHull *tConvexHull;

// MARK: -


/* Function declarations */
tVertex MakeNullVertex( tConvexHull ) CF_REFINED_FOR_SWIFT;
void    ReadVertices( tConvexHull ) CF_REFINED_FOR_SWIFT;
void    Print( tConvexHull ) CF_SWIFT_NAME(tsConvexHull.print(self:)) CF_REFINED_FOR_SWIFT;
void    SubVec( int a[3], int b[3], int c[3]) CF_REFINED_FOR_SWIFT;
void    DoubleTriangle( tConvexHull ) CF_SWIFT_NAME(tsConvexHull.doubleTriangle(self:)) CF_REFINED_FOR_SWIFT;
void    ConstructHull( tConvexHull ) CF_SWIFT_NAME(tsConvexHull.constructHull(self:)) CF_REFINED_FOR_SWIFT;
bool    AddOne( tConvexHull, tVertex p ) CF_REFINED_FOR_SWIFT;
int     VolumeSign( tConvexHull, tFace f, tVertex p) CF_REFINED_FOR_SWIFT;
int     Volumei( tFace f, tVertex p ) CF_REFINED_FOR_SWIFT;
tFace    MakeConeFace( tConvexHull, tEdge e, tVertex p ) CF_REFINED_FOR_SWIFT;
void    MakeCcw( tConvexHull, tFace f, tEdge e, tVertex p ) CF_REFINED_FOR_SWIFT;
tEdge   MakeNullEdge( tConvexHull ) CF_REFINED_FOR_SWIFT;
tFace   MakeNullFace( tConvexHull ) CF_REFINED_FOR_SWIFT;
tFace   MakeFace( tConvexHull, tVertex v0, tVertex v1, tVertex v2, tFace f ) CF_REFINED_FOR_SWIFT;
void    CleanUp( tConvexHull, tVertex *pvnext ) CF_REFINED_FOR_SWIFT;
void    CleanEdges( tConvexHull ) CF_REFINED_FOR_SWIFT;
void    CleanFaces( tConvexHull ) CF_REFINED_FOR_SWIFT;
void    CleanVertices( tConvexHull, tVertex *pvnext ) CF_REFINED_FOR_SWIFT;
bool    Collinear( tVertex a, tVertex b, tVertex c ) CF_REFINED_FOR_SWIFT;
void    CheckEuler( tConvexHull, int V, int E, int F ) CF_REFINED_FOR_SWIFT;
void    PrintPoint( tConvexHull, tVertex p ) CF_REFINED_FOR_SWIFT;
void    Checks( tConvexHull ) CF_REFINED_FOR_SWIFT;
void    Consistency( tConvexHull ) CF_REFINED_FOR_SWIFT;
void    Convexity( tConvexHull ) CF_REFINED_FOR_SWIFT;
void    PrintOut( tConvexHull, tVertex v ) CF_REFINED_FOR_SWIFT;
void    PrintVertices( tConvexHull ) CF_REFINED_FOR_SWIFT;
void    PrintEdges( tConvexHull ) CF_REFINED_FOR_SWIFT;
void    PrintFaces( tConvexHull ) CF_REFINED_FOR_SWIFT;
void    CheckEndpts ( tConvexHull ) CF_REFINED_FOR_SWIFT;
void    EdgeOrderOnFaces ( tConvexHull ) CF_SWIFT_NAME(tsConvexHull.edgeOrderOnFaces(self:)) CF_REFINED_FOR_SWIFT;

// MARK: -

/// 頂点を追加する。
void AppendVertex( tConvexHull, int x, int y, int z, int vnum, const void *opaque ) CF_SWIFT_NAME(tsConvexHull.append(self:x:y:z:vnum:opaque:)) CF_REFINED_FOR_SWIFT;
/// 内部保持データを解放する。
void Free(tConvexHull) CF_SWIFT_NAME(tsConvexHull.free(self:)) CF_REFINED_FOR_SWIFT;
/// コマンドラインの場合に、本来の動作をする。
int CommandLineMain(tConvexHull chull, int argc, char *argv[] ) CF_SWIFT_NAME(tsConvexHull.main(self:argc:argv:)) CF_REFINED_FOR_SWIFT;

