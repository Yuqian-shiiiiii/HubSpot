
with listings as (
   select
       *
   from {{ref('int_rental_listings')}}
)




select
   calendar.calendar_listing_id
   , calendar.calendar_date
   , calendar.listing_id
   , calendar.is_available
   , calendar.reservation_id
   , calendar.price as booking_price
   , calendar.minimum_nights -- need to confirm
   , calendar.maximum_nights


   -- listing dimensions for future slicing


   , listings.host_since
   , listings.host_location 
   , listings.host_verifications
   , listings.neighborhood
   , listings.property_type
   , listings.room_type
   , listings.accommodates
   , listings.number_of_bathrooms
   , listings.bathroom_type
   , listings.number_of_bedrooms
   , listings.number_of_beds


   , listings.has_tv
   , listings.has_lockbox
   , listings.has_wifi
   , listings.has_air_conditioning
   , listings.has_elevator
   , listings.has_free_parking


   , listings.current_listing_price
   -- business logics widely used
   , case
       when reservation_id is not null then booking_price
       else 0
       end as upcoming_revenue
   , listings.number_of_reviews
   , listings.lowest_review_score
   , listings.highest_review_score
   , listings.avg_review_score
   -- , listings.system_scores_rating


from
   {{ref('stg_rental_calendar')}} as calendar
left join listings on calendar.listing_id = listings.listing_id
