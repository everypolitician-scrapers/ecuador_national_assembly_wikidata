require 'wikidata/fetcher'
require 'pry'

def noko_for(url)
  Nokogiri::HTML(open(URI.escape(URI.unescape(url))).read) 
end

url = 'https://es.wikipedia.org/wiki/Segundo_período_legislativo_de_la_Asamblea_Nacional_de_Ecuador'
colname = 'Asambleísta'

noko = noko_for(url)
names = noko.xpath('//table[.//th[.="%s"]]' % colname).map do |table|
  table.css('th').map(&:text).map.with_index { |e, i| i if e == colname }.compact.map { |col|
    table.xpath('.//td[%s]//a[not(@class="new")]/@title' % (col+1).to_s) 
  }
end.flatten.map(&:text)

EveryPolitician::Wikidata.scrape_wikidata(names: { es: names.uniq }, output: false)
warn EveryPolitician::Wikidata.notify_rebuilder
