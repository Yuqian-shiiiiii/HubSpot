with availability_block as (
   select
       listing_id
       , calendar_date
       , rank() over (partition by listing_id order by calendar_date) as date_rank
       , dateadd(day,-date_rank+1,calendar_date) as availability_block_start_date
       , rank() over (partition by listing_id order by calendar_date desc) as date_rank_desc
       , dateadd(day,date_rank_desc,calendar_date) as availability_block_end_date
   from {{ref('int_rental_listing_calendar')}}
   where is_available = true
)


, booking_block as (
   select
       listing_id
       , calendar_date
       , rank() over (partition by listing_id order by calendar_date) as date_rank
       , dateadd(day,-date_rank+1,calendar_date) as booking_block_start_date
       , rank() over (partition by listing_id order by calendar_date desc) as date_rank_desc
       , dateadd(day,date_rank_desc,calendar_date) as booking_block_end_date
   from {{ref('int_rental_listing_calendar')}}
   where is_available = false
)


select
   listing_calendar.listing_id
   , listing_calendar.calendar_date
   , listing_calendar.is_available
   , listing_calendar.reservation_id
   , listing_calendar.booking_price
   , listing_calendar.upcoming_revenue
   , listing_calendar.minimum_nights
   , listing_calendar.maximum_nights


   , coalesce(availability_block.availability_block_start_date, booking_block.booking_block_start_date) as block_start_date
   , coalesce(availability_block.availability_block_end_date, booking_block.booking_block_end_date) as block_end_date
   , datediff('day',block_end_date, block_start_date) as block_length


   , listing_calendar.neighborhood
   , listing_calendar.property_type
   , listing_calendar.accommodates
   , listing_calendar.number_of_bathrooms
   , listing_calendar.bathroom_type
   , listing_calendar.number_of_bedrooms
   , listing_calendar.number_of_beds


   , listing_calendar.has_tv
   , listing_calendar.has_lockbox
   , listing_calendar.has_wifi
   , listing_calendar.has_air_conditioning
   , listing_calendar.has_elevator
   , listing_calendar.has_free_parking


from {{ref('int_rental_listing_calendar')}} listing_calendar
left join availability_block
   on listing_calendar.listing_id = availability_block.listing_id and listing_calendar.calendar_date = availability_block.calendar_date
left join booking_block
   on listing_calendar.listing_id = booking_block.listing_id and listing_calendar.calendar_date = booking_block.calendar_date
