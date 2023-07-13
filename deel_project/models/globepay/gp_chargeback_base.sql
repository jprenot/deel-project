select 
    external_ref,
    status              as status,
    lower(source)       as source,
    chargeback
from pro-visitor-392620.deel.gp_chargeback_seed
