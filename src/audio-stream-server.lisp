(defpackage audio-stream-server
  (:use :cl)
  (:import-from :audio-stream-server.socket))
(in-package :audio-stream-server)

(defvar *app*
  (lambda (env)
    (declare (ignore env))
    '(200 (:content-type "text/plain") ("Hello"))))

(clack:clackup
 (lack.builder:builder
  (:backtrace
   :result-on-error `(500 (:content-type "text/plain") ("Internal Server Error")))
  (:static :path "/public/"
           :root #P"public/")
  *app*)
 :port 3000
 :server :woo
 :use-default-middlewares nil)
