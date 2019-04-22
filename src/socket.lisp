(defpackage audio-stream-server.socket
  (:use :cl))
(in-package :audio-stream-server.socket)

(defun make-sine-wave (sample-rate &aux (phase 0.0))
  (lambda (&aux (array (make-array sample-rate :element-type 'single-float)))
    (loop
      with dphase = (/ 440 sample-rate)
      for i below sample-rate
      do (setf (aref array i) (sin (* 2 (float pi 0.0) (incf phase dphase)))))
    array))

(defun start-streaming (user sample-rate &aux (sine-wave (make-sine-wave sample-rate)))
  (bt:make-thread
   (lambda ()
     (loop
       with buffer-duration = 1000 ; 1 sec
       with time = (get-internal-real-time)
       until (eq (slot-value user 'hunchensocket::state) :closed)
       when (< time (get-internal-real-time))
       do (hunchensocket:send-binary-message
           user
           (encode (funcall sine-wave)))
          (incf time buffer-duration)
       do (sleep 0.2)))))

(defun encode (buffer)
  (let ((array (make-array (* (length buffer) 4) :element-type '(unsigned-byte 8))))
    (loop
      for i below (length buffer)
      for value = (max (min (round (* (aref buffer i) (ash 1 31)))
                            (1- (ash 1 31)))
                       (1+ (ash -1 31)))
      do (when (minusp value)
           (setf value (+ (ash 1 32) value)))
         (setf (aref array (+ (* i 4) 0)) (logand (ash value 0) #xff)
               (aref array (+ (* i 4) 1)) (logand (ash value -8) #xff)
               (aref array (+ (* i 4) 2)) (logand (ash value -16) #xff)
               (aref array (+ (* i 4) 3)) (logand (ash value -24) #xff)))
    array))


(defclass session (hunchensocket:websocket-resource)
  ()
  (:default-initargs :client-class 'user))

(defclass user (hunchensocket:websocket-client)
  ())

(defun dispatch (request)
  (make-instance 'session))

(pushnew #'dispatch hunchensocket:*websocket-dispatch-table*)

(defmethod hunchensocket:text-message-received ((session session) user message)
  (when (equal message "start")
    (start-streaming user 48000)))

(defmethod hunchensocket:client-connected ((session session) user)
  (format t "joined~%"))

(defmethod hunchensocket:client-disconnected ((session session) user)
  (format t "left~%"))

(defvar socket
  (make-instance 'hunchensocket:websocket-acceptor
                 :port 3001
                 :websocket-timeout 30
                 :message-log-destination *standard-output*))

(hunchentoot:start socket)
