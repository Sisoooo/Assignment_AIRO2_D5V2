(define (domain irrigation_basic_domain)

(:requirements :strips :typing :fluents :negative-preconditions :universal-preconditions 
    :disjunctive-preconditions :conditional-effects :equality)

(:types crop depot - location robot)

(:predicates 
    (at ?r - robot ?l - location)
    (is-priority ?c - crop)
    (connected ?l1 ?l2 - location)
    (sacrificed ?c - crop)
)

(:functions
    (moisture_level ?c - crop)
    (water_supply ?r - robot)
    (num_sacrificed)
)

(:action move
    :parameters (?r - robot ?from - location ?to - location)
    :precondition (and (at ?r ?from) (connected ?from ?to))
    :effect (and (at ?r ?to) (not (at ?r ?from)))
)


(:action irrigate
    :parameters (?r - robot ?c - crop)
    :precondition (and (at ?r ?c) (is-priority ?c) (> (water_supply ?r) 0) (< (moisture_level ?c) 50))
    :effect (and (increase (moisture_level ?c) 10) (decrease (water_supply ?r) 10))
)

(:action check_levels
    :parameters (?c - crop)
    :precondition (and
        (forall (?other - crop) (>= (moisture_level ?other) (moisture_level ?c)))
    )
    :effect (and
        (is-priority ?c)
        (forall (?other - crop)
            (when (not (= ?other ?c)) (not (is-priority ?other)))
        )
    )
)


(:action sacrifice
    :parameters (?c - crop ?r - robot)
    :precondition (and (at ?r ?c) (= (water_supply ?r) 0) (not (sacrificed ?c)))
    :effect (and (sacrificed ?c) (increase (num_sacrificed) 1))
)

)