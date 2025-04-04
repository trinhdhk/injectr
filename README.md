# Small silly package to inject function into another package

Sometimes you find an unexpected behaviour in your code but you don't know why.

Sometimes you want to check the intermediate results of an unexported function but when you copy the code, it does not run.

Sometimes you want to extend the functionality of a method inside another package but you are not ready to clone the whole github and 
prepare you C++ toolchain?

Then this package is for you.

This package includes 3 functions:

- `eject` to eject a function/method content to a file, ready for you to mess it up.

- `inject` to inject you own version into a loaded package namespace

- `cure` to recover the function into its original state[^ require setting curable to TRUE]

This package should work with S3 methods. For S4 method, I don't know how to infuse them since they are infused within the constructor.
For R6, it is inside the object so things are complicated. 

Open for contribution.

(c) 2025 Trinh Dong.

