select 
  acceptance.*,
  1/gp_rates.conv_rate * acceptance.amount  as amount_USD,
  chargeback.chargeback                     as is_chargeback,
  chargeback.external_ref is not null       as has_chargeback_data

FROM `pro-visitor-392620.deel.gp_acceptance` acceptance
left join {{ ref('gp_rates') }} on acceptance.ref = gp_rates.ref
left join {{ ref('gp_chargeback_base') }} chargeback on acceptance.external_ref = chargeback.external_ref