; Custom-made utility library.
(load "cl-yautils")
(use-package :cl-yautils)

; Hunchentoot web server.
(require "hunchentoot")

; Create a new server instance.
(defvar *server*
  (make-instance 'hunchentoot:easy-acceptor :port 8080))

; Handle route to "/".
(hunchentoot:define-easy-handler (index :uri "/") ()
  (setf (hunchentoot:content-type*) "text/plain")
  "Hello World")

(defun main ()
  (hunchentoot:start *server*)
  (format *error-output* "Start a web server at http://localhost:8080~%")
  (handler-case
    ; Wait for all threads emitted by Hunchentoot.
    (bt:join-thread
      (find-if (lambda (th)
                 (search "hunchentoot" (bt:thread-name th)))
      (bt:all-threads)))

    ; Capture and handle interactive interrupt
    ; i.e. C-c invoked by a user.
    (#+sbcl sb-sys:interactive-interrupt
     #+ccl  ccl:interrupt-signal-condition
     #+clisp system::simple-interrupt-condition
     #+ecl ext:interactive-interrupt
     #+allegro excl:interrupt-signal
     () (progn
          (hunchentoot:stop *server*)
          (format *error-output* "~%")
          (quit-with-status)))
    (error (e) (format *error-output* "Error: ~a~%" e))))
