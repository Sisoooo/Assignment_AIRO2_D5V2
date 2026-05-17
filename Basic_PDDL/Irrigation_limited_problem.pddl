(define (problem irrigation_problem) 

(:domain irrigation_domain)

(:objects robot1 - robot
          c1 c2 c3 c4 c5 c6 - crop
          start1 - depot
)

(:init

    (= (water_supply robot1) 50)

    (at robot1 start1)
    (connected start1 c1)
    (connected c1 start1)
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

    (= (moisture_level c1) 17)
    (= (moisture_level c2) 63)
    (= (moisture_level c3) 42)
    (= (moisture_level c4) 88)
    (= (moisture_level c5) 5)
    (= (moisture_level c6) 71)

)

(:goal (and
    (forall (?c - crop) (>= (moisture_level ?c) 50)) (= (water_supply robot1) 0)
))

)
