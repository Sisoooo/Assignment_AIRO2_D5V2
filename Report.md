 ## Assignment D5-V2: Agricultural Robotics - Irrigation Planning

# Introduction
This workspace aims to propose different solutions, done with PDDL, for an irrigation scenario in which a robot must monitor the soil mosture of a field (divided in crops) and water the singular crops to maintain them above a certain quality threshold. To do this, the robot is provided with a water supply, which can be limited or not depending on the examined case subscenario. The robot must also take into account environmental factors, such as passive moisture evaporation due to heat and consequential drought phenomena if one or more crops are left unwatered for too long.  

This problem is differently declined depending on the scenario and addressed in the domain-problem files couple contained in the specific directory:

• *Basic_PDDL*: simplest scenario. The robot is able to move around the field and irrigate the crops, following a priority logic for which the crop with the lowest moisture is targeted first. The water supply is assumed unlimited. Modeled in discrete time.

• *PDDL_Limited*: Extension of the basic scenario, in which the robot's water supply is assumed limited and modeled inside of the domain. The priority logic is the same as the basic scenario, but different actions are implemented in case the water supply is not sufficient to reach the threshold for all the crops. Modeled in discrete time.

• *PDDL+*: Scenario modeled in continuous time, created to approximate a realistic situation in which environmental factors are involved. The priority logic is modified by not making it computationally heavy in continuous time, while maintaining the same principle. Processes are introduced to represent situations that require time, such as the passive evaporation and the actual irrigation, while events are used to introduce triggers to certain situations, such as a crop entering drought state.

# Basic PDDL - Domain file

This scenario uses basic PDDL functionalities which are useful to both propose a solution to the irrigation problem and lay the groundwork for more complex situations. In the code files the basic tools to initialize the environment and grant the motion are therefore defined, while also following the basic modelling guidelines.

The scenario is defined in a couple of files, which are the following:
- *Domain file*: used to initialize predicates, actions and everything that is permitted in the environment;
- *Problem file*: used to define the environment and its initial state, along with its goal state.
In this problem, the domain file uses types, predicates, functions and actions to model the environment.

The defined types are *robot* and *location*, which is divided in crop and depot. Depot is the point where the robot will start everytime and is added to define a pseudo-realistic setting.

The predicates (connected ?l1 ?l2 - location) and (at ?r - robot ?l - location) are respectively used to define near crops and the robot's current location, forging a basic localization environment. Here below is a basic sketch of the environment:

The *connected* predicate only defines the connections between the field's sublocations, and stacking them as done in the problem file allows to form a precise and confined environment where the robot can move.  
Another peculiar predicate, (is-priority ?c -crop), is used to model a priority logic that lets the robot choose which crop to irrigate first based on how bad its moisture condition is. This logic is directly tied to the function (moisture_level ?c - crop), which assigns a number for the moisture level of every crop. This allows to both model moisture levels explicitly, as requested by modelling guidelines, and discretely, since it is done with a number association. In the problem file, this function will be repeated for every defined crop. 


    ---------
    | start1 |
    --------- --------- ---------
    |        |         |         |
    |   c1   |    c2   |   c3    |
    |        |         |         |
    --------- --------- ---------
    |        |         |         |
    |   c4   |    c5   |   c6    |
    |        |         |         |
    --------- --------- ---------


# Basic PDDL - Differences between abundant and limited scenarios


# PDDL+ - Domain functions 

PDDL+ introduces continuous time features that allow to model the problem as a closer approximation to a real life scenario. This includes both the introduction of passive factors to the environment itself and the conversion of existing instantaneous actions into time-based actions. The former includes evaporation of water in the soil over time and drought conditions given by mistreatment, respectively modeled through a process and an event. The code for both is shown below: 

```
(:process evaporation
    :parameters (?c - crop)
    :precondition (and (>= (moisture_level ?c) 10) (not (unusable ?c)))
    :effect (and
        (decrease (moisture_level ?c) (* 1 #t))
    )
)
```

```
(:event drought
    :parameters (?c - crop)
    :precondition (and
        (<= (moisture_level ?c) 10)
        (not (unusable ?c))
    )
    :effect (and
        (assign (moisture_level ?c) 0)
        (unusable ?c)
    )
)
```

The evaporation process passively drains the moisture level of every crop of 1 unit per second and is directly linked to the drought event due to its precondition. This happens because once a crop's moisture level drops below 10 through evaporation it immediately triggers the drought event, which flags the specific crop as unusable and modifies by 1 a counter used to penalize the planner for allowing droughts to happen.

The other design modification with respect to the basic PDDL scenario is that the actions that the robot decides to do must now be timed, since retaining them as instantaneous harms the current scenario's realism factor. This is done by modelling the actual actions (in this case, movement and irrigation) as processes which are controlled by two triggers that can be either actions or events, depending on the interrupting condition's structure. 
The logic remains the same in the beginning, with the difference being the predicate (idle ?r), which defines the robot's state at the current time: it is either idle or doing an action that involves a specific crop. The robot then chooses a target crop along the following logic: 

```
(:action choose_target
    :parameters (?r - robot ?c - crop)
    :precondition (and 
        (idle ?r) 
        (forall (?other - crop) (<= (moisture_level ?c) (moisture_level ?
        other))) 
        (not (unusable ?c)) 
        (> (moisture_level ?c) 10))
    :effect (and (not (idle ?r)) (targeted ?c))
)
```

It chooses the crop with the lowest moisture level that is not flagged as unusable and targets it, also exiting the idle state. The logic implements both the checks against the drought process, which can seem redundant, but is used for testing scenarios in which one or more crops are already unusable from the instant t=0, to prevent choose_target to target an unusable crop due to it also firing at t=0.

Once a crop is chosen, the robot must reach it and irrigate it. The irrigation process is very similar to the basic PDDL implementation, but the increase of the moisture level and opposite decrease of the water supply are now time-based. This means that, once the robot is located at the targeted crop and can supply water, it gives water to the crop for as much time as needed to fulfill the threshold. This process is controlled by two actions, one to start the irrigation and one to stop it:

- start_irrigation activates the (irrigating ?r ?c) flag once the robot is located at the targeted crop; this flag allows the robot to proceed with the irrigation;

```
(:action start_irrigation
    :parameters (?r - robot ?c - crop)
    :precondition (and (at ?r ?c) (not (irrigating ?r ?c)) (targeted ?c) (> (water_supply ?r) 0))
    :effect (and (irrigating ?r ?c))
)
```

- stop_irrigation gets the robot back to the idle state after the moisture level threshold is reached, ready to receive a new directive from choose_target.

```
(:action stop_irrigation
    :parameters (?r - robot ?c - crop)
    :precondition (and (at ?r ?c) (irrigating ?r ?c) (>= (moisture_level ?c) 50))
    :effect (and (not (irrigating ?r ?c)) (idle ?r) (not (targeted ?c)))
)
```

It is noteworthy to mention that the irrigating process is regulated by two actions and not by two events; this is done because both the conditions to start and stop the irrigation are discrete conditions, rather than time-based, therefore the robot must act as soon as the momentary objective is complete to not leave other endangered crops behind.

The movement is then administered with a moving process, an action called start_move and an event that triggers on arrival to the next location. When the movement starts, given two connected locations and that the robot is both not idle and located in the starting point of the predicate, the robot is removed from the starting position and the final position is assigned as the next location it is going to be in; a counter named move_progress is then set to 0 and the moving flag is activated. This flag activates the moving process, which increases move_progress by 1 every second, and after 1 second the arrival event triggers, since move_progress must be greater or equal to 1. On this trigger, the robot will be actually located on the final point of the moving pattern, deactivating both the moving flag and the next_location predicate in the process.
This implementation is done to simplify the modelling of the movement to crops that require "long" runs to reach by splitting the movement in steps between couples of connected crops. Moreover, by using the (at ?r ?c) predicate only when starting and finishing a move it is possible to simulate in real time the motion that the robot makes between crops without rendering it a discrete, and therefore instant, action. 

# PDDL+ - Problem definition and results

Once the domain file is defined, a problem must be created to check if the planner works correctly. The problem is set up similarly to the basic PDDL scenario, with num_drought_events and move_progress robot both initialized to 0 along with the water supply, here starting at 200. The moisture level are initialized in a permissive setting, with respective values being: 27, 63, 42, 88, 25, 71. Two crops are at decent risk to test the planner's priority logic. The goal is similar to the limited problem in allowing unusable crops, while also asking for the threshold to be respected.
A peculiar structure is presented in the form of:

```
(:metric minimize (+ (total-time) (* 1000 (num_drought_events))))
```

which is a composite metric that aims both to minimize the total time and to heavily penalize drought events.
In this setting, the planner's response is as follows:

```
Found Plan:
0: -----waiting---- [2.0]
2.0: (choose_target robot c5)
2.0: (start_move robot start1 c1)
2.0: -----waiting---- [3.0]
3.0: (start_move robot c1 c4)
3.0: -----waiting---- [4.0]
4.0: (start_move robot c4 c5)
4.0: -----waiting---- [5.0]
5.0: (start_irrigation robot c5)
5.0: -----waiting---- [11.0]
11.0: (stop_irrigation robot c5)
11.0: (choose_target robot c1)
11.0: (start_move robot c5 c4)
11.0: -----waiting---- [12.0]
12.0: (start_move robot c4 c1)
12.0: -----waiting---- [13.0]
13.0: (start_irrigation robot c1)
13.0: -----waiting---- [19.0]
19.0: (stop_irrigation robot c1)
19.0: (choose_target robot c3)
19.0: (start_move robot c1 c2)
19.0: -----waiting---- [20.0]
20.0: (start_move robot c2 c3)
20.0: -----waiting---- [21.0]
21.0: (start_irrigation robot c3)
21.0: -----waiting---- [25.0]
25.0: (stop_irrigation robot c3)
25.0: (choose_target robot c2)
25.0: (start_move robot c3 c2)
25.0: -----waiting---- [26.0]
26.0: (start_irrigation robot c2)
26.0: -----waiting---- [28.0]
28.0: (stop_irrigation robot c2)
28.0: (choose_target robot c6)
28.0: (start_move robot c2 c5)
28.0: -----waiting---- [29.0]
29.0: (start_move robot c5 c6)
29.0: -----waiting---- [30.0]
30.0: (start_irrigation robot c6)
30.0: -----waiting---- [31.0]
```

The priority logic works correctly, since c5 is the first to be chosen having the lowest moisture value, and it is possible to notice that continuous dynamics affect planning by looking at c2, which is chosen as a target after 25 seconds even though it was well over the acceptability threshold in the beginning of the plan.

This plan also highlights some trade-offs between water allocation and crop health, such as:

- water efficiency suboptimality due to drought avoidance, since guaranteeing safety for more endangered crops makes it so that the planner spends more water in total due to the continuous evaporation dynamics affecting safe crops at t=0, as already seen in c2 and also in c6's case;

- step-by-step movement defines a safe strategy, but adds up evaporation to all the crops by being a one-crop-at-a-time movement, since every step consumes 1 unit of moisture level for each crop without any water being dispensed;

- as a consequence, the water supply also becomes a hard constraint which could cause drought events in harder scenarios if not handled accordingly, i.e. using a more capient water supply or using a multi-robot collaborative system.
