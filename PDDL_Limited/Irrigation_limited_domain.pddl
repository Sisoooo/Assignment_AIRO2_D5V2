(define (domain irrigation_domain)

(:requirements :strips :typing :fluents :negative-preconditions :universal-preconditions)

(:types crop depot - location robot)

(:predicates 
    (at ?r - robot ?l - location)
    (is-priority ?c - crop)
    (connected ?l1 ?l2 - location)
)

(:functions
    (moisture_level ?c - crop)
    (water_supply ?r - robot)
)

(:action move
    :parameters (?r - robot ?from - location ?to - location)
    :precondition (and (at ?r ?from) (connected ?from ?to))
    :effect (and (at ?r ?to) (not (at ?r ?from)))
)


(:action irrigate
    :parameters (?r - robot ?c - crop)
    :precondition (and (at ?r ?c) (is-priority ?c) (> (water_supply ?r) 0))
    :effect (and (increase (moisture_level ?c) 10) (decrease (water_supply ?r) 10))
)

(:action check_levels
    :parameters (?c - crop)
    :precondition (and
        (forall (?other - crop) (>= (moisture_level ?other) (moisture_level ?c)))
    )
    :effect (and (is-priority ?c))
)


)