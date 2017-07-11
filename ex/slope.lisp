#!/usr/bin/sbcl --script

(load "../src/load")

(setf *print-pretty* t)
(setf *random-state* (make-random-state t))


(defun main (size fn)

  (let ((p1 (rnd:in-circ 100 :xy (list 800.0 200.0)))
        (p2 (rnd:in-circ 100 :xy (list 200.0 800.0))))
    (let ((va (math:add
                (math:scale
                   (math:norm
                     (math:mult (reverse (math:sub p1 p2)) (list -1.0 1.0)))
                   40.0)
                 (rnd:on-circ 20 :xy (list 0.0 0.0))))
         (repeat 10)
         (noise (random 4.0))
         (grains 70)
         (itt 6000)
         (sand (sandpaint:make size
                 :active (list 0 0 0 0.01)
                 :bg (list 1 1 1 1))))

      (loop for j from 1 to repeat
        do
          (print-every j 2)
          (let ((snk (snek:make)))
            (setf va (math:add va (rnd:in-circ noise :xy (list 0.0 0.0))))

            (loop for k from 1 to itt
              do
                (snek:with (snk)
                  (snek:add-vert? (rnd:on-line p1 p2))
                  (snek:with-rnd-vert (snk v)
                    (snek:append-edge? v va))
                  (snek:with-rnd-vert (snk v)
                    (snek:with-rnd-vert (snk w)
                      (snek:join-verts? w v)))))
              (snek:draw-edges snk sand grains)))


   (sandpaint:pixel-hack sand)
   (sandpaint:save sand fn))))


(time (main 1000 (second (cmd-args))))

