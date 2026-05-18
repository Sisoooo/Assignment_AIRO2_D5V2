(define (domain irrigation_domain_plus)

(:requirements :strips :typing :fluents :negative-preconditions :universal-preconditions :durative-actions :time)

(:types crop depot - location robot)

(:predicates 
    (at ?r - robot ?l - location)
    (is-priority ?c - crop)
    (unusable ?c - crop)
    (connected ?l1 ?l2 - location)
    (irrigating ?r - robot ?c - crop)
)

(:functions
    (moisture_level ?c - crop)
    (water_supply ?r - robot)
)

(:process evaporation
    :parameters (?c - crop)
    :precondition (and (>= (moisture_level ?c) 10))
    :effect (and
        (decrease (moisture_level ?c) (* 2 #t))
    )
)

(:process irrigating_crop
    :parameters (?r - robot ?c - crop)
    :precondition (and (irrigating ?r ?c))
    :effect (and
        (increase (moisture_level ?c) (* 5 #t))
        (decrease (water_supply ?r) (* 5 #t))
    )
)


(:event drought
    :parameters (?c - crop)
    :precondition (and
        (< (moisture_level ?c) 10)
    )
    :effect (and
        (assign (moisture_level ?c) 0)
        (unusable ?c)
    )
)

(:action move
    :parameters (?r - robot ?from - location ?to - location)
    :precondition (and (at ?r ?from) (connected ?from ?to))
    :effect (and (at ?r ?to) (not (at ?r ?from)))
)


(:durative-action irrigation_handling
    :parameters (?r - robot ?c - crop)
    :duration (= ?duration 3)
    :condition(and
        (at start (at ?r ?c))
        (at start (is-priority ?c))
        (at start (> (water_supply ?r) 0))
        (at start (not (unusable ?c)))
        (at start (not(irrigating ?r ?c)))
        (over all (at ?r ?c))
        (over all (> (water_supply ?r) 0))
        (over all (not (unusable ?c)))
    )
    :effect (and 
        (at start (irrigating ?r ?c))
        (at end (not (irrigating ?r ?c)))
        (at end (not (is-priority ?c)))
    )
)

(:action check_levels
    :parameters (?c - crop)
    :precondition (and
        (forall (?other - crop) (>= (moisture_level ?other) (moisture_level ?c)))
    )
    :effect (and (is-priority ?c))
)

)