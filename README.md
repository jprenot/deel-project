# deel-project

## Part 1
This dataset contains 2 raw sources: acceptance, and chargebacks. Both models contain various data about transactions, and we can get a more complete look by doing some transformations. The fields ref and external_ref seem to be unique IDs, and they are in fact unique and non null. 

Ingesting the data was pretty challenging - I'm familiar with making new dbt seeds with a dbt-snowflake project that's already set up, but getting dbt-bigquery installed and then putting the tables into my free BQ account took me quite a while. I think one of them ended up getting correctly uploaded from my dbt seed command, and the other was a manual csv upload.

I kept the modeling simple - the _base models just rename and cast some fields, or pull data out of JSON into columns, and the _xf model joins together the base models. Things I decided not to do include:
  - adding an int layer where we delete bad records (in this case it would probably be status = false)
  - add date fields to transactions_xf like quarter, fiscal quarter, month, etc. This can be helpful in Tableau/Looker later on, but is probably outside the scope of what's necessary here
  - create macros or tests. Unique and non-null tests for the id fields would be best practice in production, as well as a custom test to see if globepay has added any new currencies. I would not have been able to turn this in today if I tried to come up with a clever macro to dynamically parse the rates field.
  - make gp_source.yml and gp_models.yml files, create a source macro, and use the models yml for documentation. 

## Part 2
1. The acceptance rate hangs right around 70% for the most part, spiking up to 75% in some weeks, and down to as low as 63% in others.

with base as (
select 
  cast(date_trunc(transaction_at, week) as date)          as transaction_week,
  count(case when state = 'accepted' then ref end)        as accepted_transactions,
  count(ref)                                              as total_transactions,
from `deel.gp_transactions_xf`
group by 1)

select 
        base.transaction_week,
        accepted_transactions / total_transactions        as acceptance_rate
from base
order by 1

2. FR, AE, and US have more than $25M in declined transactions, CA and MX have less, and UK has $0.
   
select
  two_letter_country,
  sum(amount_USD) as declined_amt
from `deel.gp_transactions_xf`
where state = 'declined'
group by 1
order by 2 desc nulls last

3. I don't see any transactions that lack chargeback data currently - I can join the acceptance table to the chargeback table and everything matches 1:1, with no chargeback statuses other than true and false. However, if this is something we're concerned about, we can make a flag called "has_chargeback_data", and write a dbt test that will warn when a transaction comes through without it.

select *
from `deel.gp_acceptance_base` 
where external_ref not in (select external_ref from deel.gp_chargeback_base)
