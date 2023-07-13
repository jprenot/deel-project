with rates as (
select
    ref,
    json_value(rates, '$.CAD')         as CAD_rate,
    json_value(rates, '$.EUR')         as EUR_rate,
    json_value(rates, '$.MXN')         as MXN_rate,
    json_value(rates, '$.USD')         as USD_rate,
    json_value(rates, '$.SGD')         as SGD_rate,
    json_value(rates, '$.AUD')         as AUD_rate,
    json_value(rates, '$.GBP')         as GPB_rate

FROM {{ ref('gp_acceptance_base') }})

select 
    rates.ref,
    cast(case 
        when acceptance.currency = 'CAD' then CAD_rate
        when acceptance.currency = 'EUR' then EUR_rate
        when acceptance.currency = 'MXN' then MXN_rate
        when acceptance.currency = 'USD' then USD_rate
        when acceptance.currency = 'SGD' then SGD_rate
        when acceptance.currency = 'AUD' then AUD_rate
        when acceptance.currency = 'GPB' then GPB_rate
    end as numeric)                                                 as conv_rate

FROM `pro-visitor-392620.deel.gp_acceptance` acceptance
left join rates on acceptance.ref = rates.ref