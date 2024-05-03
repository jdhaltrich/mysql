use options;
delimiter //

create procedure instrument_filter_1 (in threshold int(9),
in fecha_vencimiento int(9)
)

begin

drop table if exists options.instruments_list_temp;

create table options.instruments_list_temp (
effective_date int(9) not null,
ric varchar(255) not null,
instrument_code varchar(255) not null,
price decimal(25,10) not null,
open_interest decimal(25,10) not null,

primary key (instrument_code, effective_date desc)
);

insert into options.instruments_list_temp
(

select

effective_date,
ric,
instrument_code,
price,
open_interest

from options.master_cboe_options

where instrument_code in

(

select

instrument_code

from

options.master_cboe_options

where
open_interest>threshold and expiration_date>fecha_vencimiento

group by
instrument_code

)

order by
instrument_code,
effective_date desc

)
;

end //

delimiter ;