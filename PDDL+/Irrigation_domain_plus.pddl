(define (domain irrigation_domain_plus)

(:requirements :strips :typing :fluents :negative-preconditions :universal-preconditions :time)

(:types crop depot - location robot)

(:predicates 
    (at ?r - robot ?l - location)
    (unusable ?c - crop)
    (connected ?l1 ?l2 - location)
    (irrigating ?r - robot ?c - crop)
    (idle ?r - robot)
    (targeted ?c - crop)
)

(:functions
    (moisture_level ?c - crop)
    (water_supply ?r - robot)
    (num_drought_events)
)

(:process evaporation
    :parameters (?c - crop)
    :precondition (and (>= (moisture_level ?c) 10))
    :effect (and
        (decrease (moisture_level ?c) (* 1 #t))
    )
)

(:process irrigating_crop
    :parameters (?r - robot ?c - crop)
    :precondition (and (irrigating ?r ?c) (at ?r ?c) (> (water_supply ?r) 0))
    :effect (and
        (increase (moisture_level ?c) (* 10 #t))
        (decrease (water_supply ?r) (* 10 #t))
    )
)


(:event drought
    :parameters (?c - crop)
    :precondition (and
        (<= (moisture_level ?c) 10)
        (not (unusable ?c))
    )
    :effect (and
        (assign (moisture_level ?c) 0)
        (unusable ?c)
        (increase (num_drought_events) 1)
    )
)

(:action move
    :parameters (?r - robot ?from - location ?to - location)
    :precondition (and (at ?r ?from) (connected ?from ?to))
    :effect (and (at ?r ?to) (not (at ?r ?from)))
)

(:action choose_target
    :parameters (?r - robot ?c - crop)
    :precondition (and (idle ?r) (< (moisture_level ?c) 50) (not (unusable ?c)))
    :effect (and (not (idle ?r)) (targeted ?c))
)



(:action start_irrigation
    :parameters (?r - robot ?c - crop)
    :precondition (and (at ?r ?c) (not (irrigating ?r ?c)) (targeted ?c) (> (water_supply ?r) 0))
    :effect (and (irrigating ?r ?c))
)

(:action stop_irrigation
    :parameters (?r - robot ?c - crop)
    :precondition (and (at ?r ?c) (irrigating ?r ?c) (>= (moisture_level ?c) 50))
    :effect (and (not (irrigating ?r ?c)) (idle ?r) (not (targeted ?c)))
)

)