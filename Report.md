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


# PDDL+ - Files structure 

PDDL+ introduces continuous time features that allow to model the problem as a closer approximation to a real life scenario. 