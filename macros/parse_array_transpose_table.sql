{% macro parse_amenities(amenities_array) %}


-- Complete list of amenities values in the current array array_distinct
-- too messy to parse out and transpose to unique columns
-- for demonstration purposes, we will manually parse out amenities we focus on


--   "Free street parking",
--   "Beach essentials",
--   "Pack ’n Play/travel crib",
--   "Conditioner",
--   "Outdoor dining area",
--   "Laundromat nearby",
--   "Refrigerator",
--   "Coffee maker",
--   "Cable TV",
--   "Lockbox",
--   "Carbon monoxide alarm",
--   "Elevator",
--   "Air conditioning",
--   "Paid parking off premises",
--   "Stove",
--   "Paid parking on premises",
--   "65 inch HDTV with Netflix, HBO Max, Amazon Prime Video, standard cable",
--   "Building staff",
--   "Heating",
--   "Wifi",
--   "Dedicated workspace",
--   "Host greets you",
--   "TV with standard cable",
--   "Lake access",
--   "Portable fans",
--   "Electric stove",
--   "Baking sheet",
--   "Security cameras on property",
--   "Essentials",
--   "First aid kit",
--   "Backyard",
--   "Long term stays allowed",
--   "Bathtub",
--   "Wine glasses",
--   "Board games",
--   "Extra pillows and blankets",
--   "Hair dryer",
--   "Dining table",
--   "Children’s books and toys",
--   "Washer",
--   "Hot water",
--   "Oven",
--   "Dryer",
--   "Luggage dropoff allowed",
--   "Private entrance",
--   "Breakfast",
--   "Bed linens",
--   "Freezer",
--   "Hangers",
--   "Sound system",
--   "Baby safety gates",
--   "Ethernet connection",
--   "BBQ grill",
--   "Crib",
--   "TV",
--   "Iron",
--   "Kitchen",
--   "Lock on bedroom door",
--   "Shampoo",
--   "Body soap",
--   "Keypad",
--   "Fire extinguisher",
--   "Indoor fireplace",
--   "Cooking basics",
--   "Hot tub",
--   "Cleaning products",
--   "Dishwasher",
--   "Smoke alarm",
--   "Microwave",
--   "Clothing storage: closet and dresser",
--   "Room-darkening shades",
--   "Keurig coffee machine",
--   "Free parking on premises",
--   "Shower gel",
--   "Patio or balcony",
--   "Outdoor furniture",
--   "Toaster",
--   "Barbecue utensils",
--   "Dishes and silverware",
--   "Babysitter recommendations",
--   "Ceiling fan"
 -- List of Amenities hardcoded for demonstration purposes
-- we might need to clean up the product and platform value to automate this process
 {% set amenities_list = [
    "TV",
    "Air conditioning",
    "Wifi",
    "Lockbox",
    "Elevator",
    "Free parking",
    "Stove"
]
 %}


 -- Loop through the list and create a CASE statement for each amenity
 {% for amenity in amenities_list %}
   , case
       -- when array_contains( amenity::variant ,amenities)
       when array_to_string( {{ amenities_array }} , ',' ) ilike '%{{ amenity }}%' then true
       else false
     end as has_{{ amenity|lower|replace(' ', '_') }}
 {% endfor %}
{% endmacro %}
