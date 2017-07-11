#!/usr/bin/sbcl --script

(load "../src/load")

(setf *print-pretty* t)
(setf *random-state* (make-random-state t))


(defun main (size fn)

  (let ((math:mid (half size))
        (repeat 15)
        (grains 3)
        (itt 1000)
        (sand (sandpaint:make size
                :active (list 0 0 0 0.01)
                :bg (list 1 1 1 1))))

    (loop for i in (math:linspace 100 900 repeat)
          for j from 1 to repeat do
      (print-every j 2)
      (let ((snk (snek:make))
            (va (list 0 0))
            (vb (list 0 0))
            (p1 (list 100 i))
            (p2 (list 900 i)))

        (loop for s in (math:linspace 0.0 1.0 itt) do
          (let ((v1 (snek:add-vert! snk (math:on-line s p1 p2)))
                (v2 (snek:add-vert! snk (math:add va (math:on-line s p1 p2)))))

            (setf va (math:add va (rnd:in-circ (* 0.7 j))))
            (setf vb (math:add vb (rnd:in-circ (* 0.001 j))))

            (snek:with (snk)
              (snek:itr-verts (snk v)
                (snek:move-vert? v (math:add (rnd:in-circ 0.1) vb)))
              (snek:join-verts? v1 v2))

            (snek:draw-edges snk sand grains)
            (snek:draw-verts snk sand)))))


    (sandpaint:pixel-hack sand)
    ;(sandpaint:chromatic-aberration sand (list mid mid) :s 100.0)
    (sandpaint:save sand fn)))


(time (main 1000 (second (cmd-args))))

