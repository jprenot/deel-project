SELECT 
  external_ref      as external_ref,
  status            as status,
  lower(source)     as source,
  ref               as ref,
  date_time         as transaction_at,
  lower(state)      as state,
  cvv_provided      as cvv_provided,
  amount            as amount,
  country           as country,
  currency          as currency,
  rates             as rates


FROM `pro-visitor-392620.deel.gp_acceptance`

