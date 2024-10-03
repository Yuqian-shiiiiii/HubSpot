
with daily_listing_calendar as (
   select
       *
   from
       {{ref('int_rental_listing_calendar')}}
)


select
   neighborhood
   , calendar_date
   , sum(case when reservation_id is not null then 1 else 0 end) as total_bookings
   , sum(case when is_available = true then 1 else null end) as total_available
   , total_bookings / total_available as book_rate
   , avg(booking_price) as avg_book_price
   , sum(upcoming_revenue ) as total_upcoming_revenue
   , avg(avg_review_score) as avg_review_score_across_listings
from
   daily_listing_calendar
group by 1,2
