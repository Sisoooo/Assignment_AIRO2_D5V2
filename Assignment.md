## Assignment D5-V2: Agricultural Robotics – Irrigation Planning
# Scenario
- A robot is responsible for irrigating crops. 
- Each plot has a soil moisture level that decreases over time due to environmental conditions.
- The robot must:
    • monitor soil moisture,
    • apply water to maintain suitable conditions.
- Water supply is limited.

# Domain Characteristics
• Robot: single or multiple
• Resources: water supply
• Tasks: irrigation
• Constraints: resource management + environmental dynamics

# Modelling Guidelines
• Represent soil moisture explicitly.
• Avoid modelling irrigation as a binary action.
• Ensure that water constraints influence planning decisions.

# Q1 – Basic PDDL Model
You must:
• Model moisture levels discretely.
• Provide:
– one problem with abundant water
– one where water must be rationed
• Provide valid plans.

# Q2 – PDDL+ Model
You must:
• Introduce a process modelling continuous moisture evaporation.
• Introduce a process modelling irrigation effects.
• Introduce an event representing drought conditions.
• Show how continuous dynamics affect planning.

# Discussion
Discuss:
• modelling environmental processes
• trade-offs between resource allocation and crop health