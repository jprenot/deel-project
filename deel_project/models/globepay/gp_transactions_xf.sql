select 
  acceptance.external_ref                   as external_ref,
  acceptance.status                         as status,
  acceptance.source                         as source,
  acceptance.ref                            as ref,
  acceptance.transaction_at                 as transaction_at,
  acceptance.state                          as state,
  acceptance.cvv_provided                   as cvv_provided,
  acceptance.amount                         as amount_local,
  acceptance.country                        as two_letter_country,
  acceptance.currency                       as currency,
  acceptance.rates                          as rates,
  1/gp_rates.conv_rate * acceptance.amount  as amount_USD,
  chargeback.chargeback                     as is_chargeback,
  chargeback.external_ref is not null       as has_chargeback_data

FROM {{ ref('gp_acceptance_base') }} acceptance
left join {{ ref('gp_rates_base') }} gp_rates on acceptance.ref = gp_rates.ref
left join {{ ref('gp_chargeback_base') }} chargeback on acceptance.external_ref = chargeback.external_ref
