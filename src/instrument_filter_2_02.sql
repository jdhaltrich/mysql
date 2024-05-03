use options;
delimiter //

create procedure instrument_filter_2_02 (in last_n_days int(9),
in price_cut_off decimal(25,10),
in second_threshold int(9),
in threshold int(9),
in fecha_vencimiento int(9)
)

begin

call instrument_filter_2(last_n_days,price_cut_off,second_threshold,threshold,fecha_vencimiento);

drop table if exists options.instruments_list_temp_2_02;


create table options.instruments_list_temp_2_02 (
ric varchar(255) not null,

primary key (ric asc)
);

insert into options.instruments_list_temp_2_02


select

ric

from

options.instruments_list_temp_2

group by

ric

;

end //

delimiter ;
