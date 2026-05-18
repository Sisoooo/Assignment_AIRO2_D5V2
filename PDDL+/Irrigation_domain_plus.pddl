(define (domain irrigation_domain_plus)

(:requirements :strips :typing :fluents :negative-preconditions :universal-preconditions :time)

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


(:action start_irrigation
    :parameters (?r - robot ?c - crop)
    :precondition (and (at ?r ?c) (not (irrigating ?r ?c)) (is-priority ?c) (> (water_supply ?r) 0))
    :effect (and (irrigating ?r ?c))
)

(:action stop_irrigation
    :parameters (?r - robot ?c - crop)
    :precondition (and (at ?r ?c) (irrigating ?r ?c) (not (is-priority ?c)) (> (water_supply ?r) 0))
    :effect (and (not (irrigating ?r ?c)))
)



(:action check_levels
    :parameters (?c - crop)
    :precondition (and
        (forall (?other - crop) (>= (moisture_level ?other) (moisture_level ?c)))
    )
    :effect (and (is-priority ?c))
)

)