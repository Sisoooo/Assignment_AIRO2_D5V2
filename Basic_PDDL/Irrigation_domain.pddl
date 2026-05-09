(define (domain irrigation_domain)

(:requirements :strips :typing :fluents :negative-preconditions :universal-preconditions)

(:types robot crop)

(:predicates 
    (at ?r - robot ?c - crop)
    (is-priority ?c - crop)
    (connected ?c1 ?c2 - crop)       
)

(:functions
    (moisture_level ?c - crop)
)

(:action reach
    :parameters (?r - robot ?c - crop)
    :precondition (and (is-priority ?c))
    :effect (and (at ?r ?c))
)


(:action irrigate
    :parameters (?r - robot ?c - crop)
    :precondition (and (at ?r ?c) (is-priority ?c))
    :effect (and (increase (moisture_level ?c) 10))
)

(:action check_levels
    :parameters (?c - crop)
    :precondition (and
        (forall (?other - crop) (>= (moisture_level ?other) (moisture_level ?c)))
    )
    :effect (and (is-priority ?c))
)


)