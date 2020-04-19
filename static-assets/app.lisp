; Custom-made utility library.
(load "cl-yautils")
(use-package :cl-yautils)

; Hunchentoot web server.
(require "hunchentoot")

; CL-WHO markup language for HTML.
(require "cl-who")
(use-package :cl-who)

(setf *prologue* "<!DOCTYPE html>")
(setf (html-mode) :HTML5)

; Create a new server instance.
(defvar *server*
  (make-instance 'hunchentoot:easy-acceptor :port 8080))

; Handle route to "/".
(hunchentoot:define-easy-handler (index :uri "/") ()
  (setf (hunchentoot:content-type*) "text/html")
  (with-html-output-to-string (s nil :prologue t)
    (:html :lang "en"
      (:head :title "Hunchentoot Website with Static Assets"
        (:meta :charset "utf8")
        (:meta :name "viewport"
               :content "width=device-width, initial-scale=1, shrink-to-fit=no")
        (:link :href "/vendor/css/bootstrap.min.css")
        (:script :src "/vendor/js/polyfill.min.js"))
      (:body
        (:div :class "container"
          (:h1 "Hello Hunchentoot"))
        (:script :src "/vendor/js/bootstrap-native-v4.min.js")))))

; Host vendor CSS sheets.
(push
  (hunchentoot:create-folder-dispatcher-and-handler
    "/vendor/css/"
    (make-pathname :directory '(:relative "vendor" "css"))
    "text/css")
  hunchentoot:*dispatch-table*)

; Host vendor JavaScritp scripts.
(push
  (hunchentoot:create-folder-dispatcher-and-handler
    "/vendor/js/"
    (make-pathname :directory '(:relative "vendor" "js"))
    "application/javascript")
  hunchentoot:*dispatch-table*)

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
