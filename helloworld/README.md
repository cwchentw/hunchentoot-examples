# Hello World

Classic "Hello World" program as a Hunchentoot web application.

## System Requirements

* GNU/Linux
* Either
  * SBCL (Steel Bank Common Lisp)
  * CCL (Clozure CL)
* Quicklisp
* Hunchentoot

*quicklisp.lisp* is ready in this repo. Besides, our *build* script will install Hunchentoot automatically for you.

## Build

Just run our *build* script in the root path of the repo:

```
$ ./build
```

## Usage

Invoke `app` to run the server:

```
$ ./app
```

Visit http://localhost:8080/ to see its result.

Use C-c to stop the server.

## Known Issues and Bugs

* The web application compiled by Clozure CL cannot quit successfully.
* Hunchentoot and Clozure CL have name collision issues.

## Copyright

Copyright (c) 2020 Michael Chen. Licensed under MIT.
