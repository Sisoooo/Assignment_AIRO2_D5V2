(define (domain irrigation_domain_plus)

(:requirements :strips :typing :fluents :negative-preconditions :universal-preconditions :time :disjunctive-preconditions)

(:types crop depot - location robot)

(:predicates 
    (at ?r - robot ?l - location)
    (unusable ?c - crop)
    (connected ?l1 ?l2 - location)
    (irrigating ?r - robot ?c - crop)
    (idle ?r - robot)
    (targeted ?c - crop)
    (moving ?r - robot)
    (next_location ?r - robot ?l - location)
)

(:functions
    (moisture_level ?c - crop)
    (water_supply ?r - robot)
    (move_progress ?r - robot)
    (num_drought_events)
)

(:process evaporation
    :parameters (?c - crop)
    :precondition (and (>= (moisture_level ?c) 10) (not (unusable ?c)))
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
        (< (moisture_level ?c) 10)
        (not (unusable ?c))
    )
    :effect (and
        (assign (moisture_level ?c) 0)
        (unusable ?c)
        (increase (num_drought_events) 1)
    )
)

(:action start_move
    :parameters (?r - robot ?from - location ?to - location)
    :precondition (and (at ?r ?from) (connected ?from ?to) (not (idle ?r)) (not (moving ?r)))
    :effect (and
        (not (at ?r ?from))
        (moving ?r)
        (next_location ?r ?to)
        (assign (move_progress ?r) 0)
    )
)

(:process moving
    :parameters (?r - robot)
    :precondition (and (moving ?r))
    :effect (and
        (increase (move_progress ?r) (* 1 #t))
    )
)

(:event arrive
    :parameters (?r - robot ?to - location)
    :precondition (and
        (moving ?r)
        (next_location ?r ?to)
        (>= (move_progress ?r) 1)
    )
    :effect (and
        (not (moving ?r))
        (at ?r ?to)
        (not (next_location ?r ?to))
    )
)

(:action choose_target
    :parameters (?r - robot ?c - crop)
    :precondition (and (idle ?r) (forall (?other - crop) (<= (moisture_level ?c) (moisture_level ?other))) (not (unusable ?c)) (> (moisture_level ?c) 10))
    :effect (and (not (idle ?r)) (targeted ?c))
)



(:action start_irrigation
    :parameters (?r - robot ?c - crop)
    :precondition (and (at ?r ?c) (not (irrigating ?r ?c)) (targeted ?c) (> (water_supply ?r) 0))
    :effect (and (irrigating ?r ?c))
)

(:action stop_irrigation
    :parameters (?r - robot ?c - crop)
    :precondition (and (at ?r ?c) (irrigating ?r ?c) (> (moisture_level ?c) 50))
    :effect (and (not (irrigating ?r ?c)) (idle ?r) (not (targeted ?c)))
)

)