(define (problem irrigation_problem) 

(:domain irrigation_domain)

(:objects robot1 - robot
          c1 c2 c3 c4 c5 c6 c7 c8 c9 - crop
          start1 - depot
)

(:init
    (at robot1 start1)
    (connected start1 c8)
    (connected c8 start1)
    (connected c1 c2)
    (connected c2 c1)
    (connected c1 c4)
    (connected c4 c1)
    (connected c2 c3)
    (connected c3 c2)
    (connected c2 c5)
    (connected c5 c2)
    (connected c6 c3)
    (connected c3 c6)
    (connected c6 c5)
    (connected c5 c6)
    (connected c4 c5)
    (connected c5 c4)
    (connected c8 c5)
    (connected c5 c8)
    (connected c7 c4)
    (connected c4 c7)
    (connected c7 c8)
    (connected c8 c7)
    (connected c6 c9)
    (connected c9 c6)
    (connected c8 c9)
    (connected c9 c8)

    (= (moisture_level c1) 17)
    (= (moisture_level c2) 63)
    (= (moisture_level c3) 42)
    (= (moisture_level c4) 88)
    (= (moisture_level c5) 5)
    (= (moisture_level c6) 71)
    (= (moisture_level c7) 34)
    (= (moisture_level c8) 56)
    (= (moisture_level c9) 92)
)

(:goal (and
    (forall (?c - crop) (>= (moisture_level ?c) 50))
))

)
