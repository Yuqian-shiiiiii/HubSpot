with


source as (


   select * from {{ source('aa_rentals', 'rental_calendar') }}


),


renamed as (
   -- create surrogated_key as the PK
   -- this is easier to maintain overtime and speed up joins/look up
   select
       {{
           dbt_utils.generate_surrogate_key([
           'listing_id'
           , 'date'
               ])
       }} as calendar_listing_id
       , listing_id
       , date as calendar_date
       , case when available ='f' then false else true end as is_available
       , reservation_id
       , price


       -- this does not align with booking pattern. Need to confirm.
       , minimum_nights
      
       , maximum_nights
   from source
)


select * from renamed
