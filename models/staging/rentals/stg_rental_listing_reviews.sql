with


source as (


   select * from {{ source('aa_rentals', 'rental_generated_reviews') }}


),


renamed as (
   select
       id as review_id
       , listing_id
       , review_date
       , review_score
   from source
)


select * from renamed

