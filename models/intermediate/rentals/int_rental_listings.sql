with reviews as (
   select
       listing_id
       , count(review_id) as number_of_reviews
       , min(review_date) as first_review_date
       , max(review_date) as last_review_date
       , min(review_score) as lowest_review_score
       , max(review_score) as highest_review_score
       , avg(review_score) as avg_review_score
   from
       {{ref('stg_rental_listing_reviews')}}
   group by 1
)


select
   listings.listing_id
   , listings.listing_name
   , listings.host_id
   , listings.host_name
   , listings.host_since
   , listings.host_location -- need to clean up
   , listings.host_verifications -- did not split out for exercise. need to evaluate
   , listings.neighborhood
   , listings.property_type
   , listings.room_type
   , listings.accommodates


   -- need to confirm logic to clean up bathrooms number. Prob can use the room type
   , case
       when listings.bathrooms_text is null then 0
       else REGEXP_SUBSTR(listings.bathrooms_text, '[0-9]+(\.[0-9]+)?')::float
       end as number_of_bathrooms
   , case
       when listings.bathrooms_text is null then 'NA'
       when listings.bathrooms_text ilike '%shared%' then 'Shared'
       when listings.bathrooms_text ilike '%private%' then 'Private'
       else 'NA'
       end as bathroom_type
   , listings.number_of_bedrooms
   , listings.number_of_beds
   -- , listings.amenity_list
   {{ parse_amenities('amenity_list') }} -- or we can join to the change log in the future. join should be less expensive with property keys


   , listings.current_listing_price -- this can be different from the price listed in the calendar view for future price


   -- confirmed align with listings table
   -- use reviews table as SoT
   , reviews.number_of_reviews
   , reviews.first_review_date
   , reviews.last_review_date
   , reviews.lowest_review_score as lowest_review_score
   , reviews.highest_review_score as highest_review_score
   , reviews.avg_review_score as avg_review_score
   --, listings.system_scores_rating


from {{ref('stg_rental_listings')}} listings
left join reviews on listings.listing_id = reviews.listing_id
