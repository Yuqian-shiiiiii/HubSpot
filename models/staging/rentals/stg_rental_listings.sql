with


source as (


   select * from {{ source('aa_rentals', 'rental_listings') }}


),


renamed as (
   select
       id as listing_id
       , name as listing_name
       , host_id
       , host_name


       -- convert to date since the the time portion is not generated
       , host_since::date


       -- need cleanup
       , host_location
       , host_verifications
       , neighborhood
       , property_type
       , room_type
       , accommodates


       -- need cleanup
       , bathrooms_text
       , ifnull(bedrooms,0) as number_of_bedrooms
       , beds as number_of_beds


        -- array
       , amenities
       , replace(price, '$', '')::float as current_listing_price
       , number_of_reviews
       , first_review::date as first_review_date
       , last_review::date as last_review_date


       -- need to confirm. this does not align with the generated reviews table?
       , review_scores_rating  as system_scores_rating
   from source
)


select * from renamed
