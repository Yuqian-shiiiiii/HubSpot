with


source as (


   select * from {{ source('aa_rentals', 'rental_amenities_change_log') }}


),


renamed as (
   -- create surrogated_key as the PK
   -- this is easier to maintain overtime and speed up joins/look up


   select
   -- amenities can change multiple times for a listing in the same day but will not revert back. See assumptions.
       {{
           dbt_utils.generate_surrogate_key([
           'listing_id'
           , 'change_at'
           , 'amenities'
               ])
       }} as change_log_id
       , listing_id
       , change_at::date as changed_at -- convert to date since the time is always 00:00:00
       , amenities -- keep it as array
   from source


)


select * from renamed
