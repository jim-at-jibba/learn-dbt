{{
  config(
    materialized = 'incremental',
    on_schema_change = 'fail'
  )
}}

WITH src_reviews AS (
  SELECT * FROM {{ ref('src_reviews') }}
)

SELECT * FROM src_reviews
WHERE review_text is not null
-- This onl happens if its an incremental materialized view
{% if is_incremental() %}
 AND review_date > (SELECT MAX(review_date) FROM {{ this }})
{% endif %}
