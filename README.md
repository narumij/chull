# chull.framework

## Overview

A Swift Package for macOS and iOS platforms that generates 3D convex hulls.
The chull.c file has been customized and wrapped for ease of use in Swift.

## Command Line Tool

To use like original chull.c, you need build up macOS command line project.
You can use below code for this purpose.

main.swift
```
import Foundation
import ConvexHull

extension SIMD3: VertexItem where Scalar == Float {
    public var position: Self { self }
}

_ = ConvexHull<SIMD3<Float>>.main(argc: CommandLine.argc, argv: CommandLine.unsafeArgv)
```

### License

This is free software; you can redistribute it and/or modify it under MIT License.

Please note that the release contains chull.c. They have their own copyright and license.

- chull.c Copyright (C) 2000, Joseph O'Rourke.

### Reference

O'Rourke,J. (1998). [Computational Geometry in C](http://www.science.smith.edu/~jorourke/books/compgeom.html), 2nd edn, Cambridge: Cambridge University Press.

