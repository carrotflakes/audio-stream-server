#|
  This file is a part of audio-stream-server project.
  Copyright (c) 2019 carrotflakes (carrotflakes@gmail.com)
|#

(defsystem "audio-stream-server-test"
  :defsystem-depends-on ("prove-asdf")
  :author "carrotflakes"
  :license "LLGPL"
  :depends-on ("audio-stream-server"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "audio-stream-server"))))
  :description "Test system for audio-stream-server"

  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
