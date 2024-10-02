select
   calendar_listing_id
   , calendar_date
   , listing_id
   , is_available
   , reservation_id
   , booking_price
   , minimum_nights
   , maximum_nights


   , host_since
   , host_location
   , host_verifications


   , neighborhood
   , property_type
   , accommodates
   , number_of_bathrooms
   , bathroom_type
   , number_of_bedrooms
   , number_of_beds


   , has_tv
   , has_lockbox
   , has_wifi
   , has_air_conditioning
   , has_elevator
   , has_free_parking


   , current_listing_price
   , upcoming_revenue


   , number_of_reviews
   , lowest_review_score
   , highest_review_score
   , avg_review_score
from
   {{ref('int_rental_listing_calendar')}}
