#|
  This file is a part of audio-stream-server project.
  Copyright (c) 2019 carrotflakes (carrotflakes@gmail.com)
|#

#|
  Author: carrotflakes (carrotflakes@gmail.com)
|#

(defsystem "audio-stream-server"
  :version "0.1.0"
  :author "carrotflakes"
  :license "LLGPL"
  :depends-on ("clack"
               "hunchensocket"
               "bordeaux-threads")
  :components ((:module "src"
                :components
                ((:file "audio-stream-server" :depends-on ("socket"))
                 (:file "socket"))))
  :description ""
  :long-description
  #.(read-file-string
     (subpathname *load-pathname* "README.markdown"))
  :in-order-to ((test-op (test-op "audio-stream-server-test"))))
