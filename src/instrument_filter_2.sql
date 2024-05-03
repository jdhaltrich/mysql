use options;
delimiter //

#set collation_connection = 'utf8mb4_unicode_ci';
#set collation_database='utf8mb4_unicode_ci';
#set collation_server = 'utf8mb4_unicode_ci';

create procedure instrument_filter_2 (in last_n_days int(9),
in price_cut_off decimal(25,10),
in second_threshold int(9),
in threshold int(9),
in fecha_vencimiento int(9)
)

begin

call instrument_filter_1(threshold,fecha_vencimiento);

drop table if exists options.instruments_list_temp_2;


create table options.instruments_list_temp_2 (
ric varchar(255) not null,
instrument_code varchar(255) not null,

primary key (ric, instrument_code)
);

insert into options.instruments_list_temp_2

(
select

n.ric,
n.instrument_code

from

(
select

SE.effective_date,
SE.ric,
SE.instrument_code,
SE.price,
SE.open_interest,
SE.last_n_rank

from

(select @current_instrument:='',@last_10_rank:=0) init

join

(
select

r.effective_date,
r.ric,
r.instrument_code,
r.price,
r.open_interest,
@last_n_rank := if(@current_instrument=r.instrument_code,@last_n_rank+1,1) as last_n_rank,
@current_instrument := r.instrument_code as instrument_2


from

(

select

effective_date,
ric,
instrument_code,
price,
open_interest

from options.instruments_list_temp

) r
) SE

where SE.last_n_rank<=last_n_days and SE.price<price_cut_off and SE.open_interest>second_threshold

) n

group by
n.ric,
n.instrument_code

)
;

end //

delimiter ;
