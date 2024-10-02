SELECT
   change_log_id
   , listing_id
   , changed_at


   -- Macro to auto-populate seperate columns for amenities e.g. has_tv, has_wifi...
   {{ parse_amenities('amenities') }}


   -- , amenities as amentities_list
   -- array vs. columns considerations balancing storage query frequency
  
from {{ ref('stg_rental_amenities_change_log') }}
