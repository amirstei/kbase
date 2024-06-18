create masking policy obfuscation_string as (val string) returns string ->
    case
    when system$get_tag_on_current_column('tags.obfuscation_string') = 'random_uuid' then uuid_string()
    when system$get_tag_on_current_column('tags.obfuscation_string') = 'hash'        then hash(val)
    when system$get_tag_on_current_column('tags.obfuscation_string') = 'md5_hex'     then md5_hex(val::string)
    when system$get_tag_on_current_column('tags.obfuscation_string') = 'random_first_name'      then public.random_first_name()
    when system$get_tag_on_current_column('tags.obfuscation_string') = 'random_last_name'       then public.random_last_name()
    when system$get_tag_on_current_column('tags.obfuscation_string') = 'random_city'            then public.random_city()
    when system$get_tag_on_current_column('tags.obfuscation_string') = 'random_street'          then public.random_street()
    when system$get_tag_on_current_column('tags.obfuscation_string') = 'random_house_number'    then public.random_house_number()
    when system$get_tag_on_current_column('tags.obfuscation_string') = 'random_phone_number'    then public.random_phone_number(TRUE, TRUE)
    when system$get_tag_on_current_column('tags.obfuscation_string') = 'random_landline_number' then public.random_phone_number(FALSE, TRUE)
    when system$get_tag_on_current_column('tags.obfuscation_string') = 'random_mobile_number'   then public.random_phone_number(TRUE, FALSE)
    when system$get_tag_on_current_column('tags.obfuscation_string') = 'random_israeli_id'      then public.random_israeli_id()
    when system$get_tag_on_current_column('tags.obfuscation_string') = 'random_ip'    then public.random_ip(TRUE, TRUE)
    when system$get_tag_on_current_column('tags.obfuscation_string') = 'random_ip_v4' then public.random_ip(TRUE, FALSE)
    when system$get_tag_on_current_column('tags.obfuscation_string') = 'random_ip_v6' then public.random_ip(FALSE, TRUE)
    -- note that the zip method also appears in the obfuscate number policy (depending on data type)
    when system$get_tag_on_current_column('tags.obfuscation_string') = 'random_zip'   then public.random_zip()::string
    else val
    end;

create masking policy obfuscation_date as (val date) returns date ->
    case
    -- the date shift threshold is 1000 days (hard coded)
    when system$get_tag_on_current_column('tags.obfuscation_date') = 'random_date_shift' then dateadd(days, -(abs(random()) % 1000), val)
    when system$get_tag_on_current_column('tags.obfuscation_date') = 'random_date' then dateadd(days, -(abs(random()) % 1000), current_timestamp())::date
    else val
    end;

-- SAME AS DATE
create masking policy obfuscation_timestamp as (val timestamp) returns timestamp ->
    case
    -- the date shift threshold is 1000 days (hard coded)
    when system$get_tag_on_current_column('tags.obfuscation_date') = 'random_date_shift' then dateadd(days, -(abs(random()) % 1000), val)::timestamp
    when system$get_tag_on_current_column('tags.obfuscation_date') = 'random_date' then dateadd(days, -(abs(random()) % 1000), current_timestamp())::timestamp
    else val
    end;

create masking policy obfuscation_number as (val number) returns number ->
    case
    when system$get_tag_on_current_column('tags.obfuscation_date') = 'random_decimal_number' then uniform(sqrt(val), square(val), random())
    when system$get_tag_on_current_column('tags.obfuscation_date') = 'random_int'            then uniform(1, square(val)::int, random())
    when system$get_tag_on_current_column('tags.obfuscation_date') = 'random_zip'            then public.random_zip()
    else val
    end;