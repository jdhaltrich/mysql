# *Instrument Filter*

## description

This MySQL Stored Procedure queries a master table master_cboe_options
and impacts a table instruments_list_temp_2_02 with information necessary
for an R program to pick up an individual option by its OCC option symbol
and perform thorough analysis, including valuations by Black-Scholes,
Binomial Option Trees and Montecarlo Simulation.

A short summary of these 3 MySQL procedures is described as the following:
1. Given 2 input filters (a. open interest, b. expiration date)
which are provided at runtime, then the instrument_filter_1 SP uses the
expiration date as a filter to cutoff any instrument code which has an
expirtion date previous to the cutoff date, as well as keeping in the query
output only those instruments which at the close traded with an open interest
greater than the cutoff filter.

2. The instrument_filter_2 SP uses 3 input values to further filter and sort
the final output as follows:
a. it assigns a value of 1 if the OCC is the first one encountered, otherwise
it adds 1 to the previous value, so that the result shows the last n trading
entries for that OCC up until it reaches the filter value given by the filter
last_n_days.
b. it filters out any OCC having a price greater than the filter price_cut_off
c. and finally it removes any OCC which might have passed the open interest
filter applied in the first SP but now it is removed as the re-applied filter
now also considers the price cutoff while complying with them in the last n
days of trading.

3. Finally the instrument_filter_2_02 SP grabs this output and selects only
the Reuters Instrument Code from the root underlying of each OCC and impacts
the table instruments_list_temp_2_02 table with the grouped RICs.

[source files] (./src)
