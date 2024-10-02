-- update to incremental model



WITH available_consecutive_dates as (
   select
       listing_id
       , calendar_date
       , is_available
       , case
           when lag(calendar_date) over (partition by listing_id order by calendar_date) is null then calendar_date
           when datediff('day', lag(calendar_date) over (partition by listing_id order by calendar_date),calendar_date) > 1 then calendar_date
           else null
       end as block_start_flag
       , case
           when lag(calendar_date) over (partition by listing_id order by calendar_date desc) is null then calendar_date
           when datediff('day', lag(calendar_date) over (partition by listing_id order by calendar_date desc),calendar_date) < -1 then calendar_date
           else null
       end as block_end_flag
   from {{ref('int_rental_listing_calendar')}}
   where reservation_id is null
)


, booked_consecutive_dates as (
   select
       listing_id
       , calendar_date
       , is_available
       , case
           when lag(calendar_date) over (partition by listing_id order by calendar_date) is null then calendar_date
           when datediff('day', lag(calendar_date) over (partition by listing_id order by calendar_date),calendar_date) > 1 then calendar_date
           else null
       end as block_start_flag
       , case
           when lag(calendar_date) over (partition by listing_id order by calendar_date desc) is null then calendar_date
           when datediff('day', lag(calendar_date) over (partition by listing_id order by calendar_date desc),calendar_date) < -1 then calendar_date
           else null
       end as block_end_flag
   from {{ref('int_rental_listing_calendar')}}
   where reservation_id is not null
)


, blocks as (
   select
       listing_id
       , calendar_date
       , is_available
       -- Carry forward the last block start date for each group of consecutive dates
       , coalesce(block_start_flag, max(block_start_flag) over (partition by listing_id order by calendar_date rows between unbounded preceding and current row)) as block_start_date
       , coalesce(block_end_flag, min(block_end_flag) over (partition by listing_id order by calendar_date desc rows between unbounded preceding and current row)) as block_end_date
   from available_consecutive_dates


   union


   select
       listing_id
       , calendar_date
       , is_available
       -- Carry forward the last block start date for each group of consecutive dates
       , coalesce(block_start_flag, max(block_start_flag) over (partition by listing_id order by calendar_date rows between unbounded preceding and current row)) as block_start_date
       , coalesce(block_end_flag, min(block_end_flag) over (partition by listing_id order by calendar_date desc rows between unbounded preceding and current row)) as block_end_date
   from booked_consecutive_dates


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


   , block_start_date
   , block_end_date
   , datediff('day', block_start_date,block_end_date)+1 as block_length


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
   , listing_calendar.has_first_aid_kit


from {{ref('int_rental_listing_calendar')}} listing_calendar
left join blocks
   on listing_calendar.listing_id = blocks.listing_id and listing_calendar.calendar_date = blocks.calendar_date



