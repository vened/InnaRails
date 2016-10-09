require './search_offers'

# search = SearchOffers.new("2016-10-22   2016-10-30,   2016-10-29 2016-11-08", 1484, 6733)
search = SearchOffers.new(nil, 1484, 6733, 'tury-v-nyachang-iz-moskvy')

p search.offers