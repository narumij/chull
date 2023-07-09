//
//  Modified.c
//  ConvexHull
//
//  Created by narumij on 2021/10/10.
//

#import "PublicHeader.h"
#import "Constants.h"
#import "macros.h"

void AppendVertex(tConvexHull chull, int x, int y, int z, int vnum, const void *opaque) {
    tVertex  v;
    v = MakeNullVertex(chull);
    v->v[X] = x;
    v->v[Y] = y;
    v->v[Z] = z;
    v->vnum = vnum;
    if ( ( abs(x) > SAFE ) || ( abs(y) > SAFE ) || ( abs(z) > SAFE ) ) {
        printf("Coordinate of vertex below might be too large: run with -d flag\n");
        PrintPoint(chull, v);
    }
}

void Free(tConvexHull chull)
{
    while (chull->faces != NULL) {
        DELETE(chull->faces, chull->faces);
    }

    while (chull->edges != NULL) {
        DELETE(chull->edges, chull->edges);
    }

    while (chull->vertices != NULL) {
        DELETE(chull->vertices, chull->vertices);
    }
    
}

int CommandLineMain(tConvexHull chull, int argc, char *argv[] )
{
    
    if ( argc > 1 && argv[1][0] == '-' ) {
        if( argv[1][1] ==  'd' ) {
            chull->debug = TRUE;
            chull->check = TRUE;
            fprintf( stderr, "Debug and check mode\n");
        }
        if( argv[1][1] == 'c' ) {
            chull->check = TRUE;
            fprintf( stderr, "Check mode\n");
        }
    }
    else if ( argc > 1 && argv[1][0] != '-' ) {
        printf ("Usage:  %s -d[ebug] c[heck]\n", *argv );
        printf ("x y z coords of vertices from stdin\n");
        exit(1);
    }
    
    ReadVertices(chull);
    DoubleTriangle(chull);
    ConstructHull(chull);
    EdgeOrderOnFaces(chull);
    Print(chull);
    
    return 0;
}

