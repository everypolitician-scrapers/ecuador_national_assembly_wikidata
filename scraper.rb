require 'everypolitician'
require 'wikidata/fetcher'
require 'pry'

existing = EveryPolitician::Index.new.country("Ecuador").lower_house.popolo.persons.map(&:wikidata).compact

names = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://es.wikipedia.org/wiki/Elecciones_legislativas_de_Ecuador_de_2013',
  after: '//span[@id="N.C3.B3mina_de_asamble.C3.ADstas_electos"]',
  before: '//span[@id="V.C3.A9ase_tambi.C3.A9n"]',
  xpath: './/a[not(@class="new")]/@title',
).reject { |n| n.start_with? 'Editar' }

# Find all P39s of the 2nd Assembly
query = <<EOS
  SELECT DISTINCT ?item
  WHERE
  {
    BIND(wd:Q21295982 AS ?membership)
    BIND(wd:Q16629825 AS ?term)

    ?item p:P39 ?position_statement .
    ?position_statement ps:P39 ?membership .
    ?position_statement pq:P2937 ?term .
  }
EOS
p39s = EveryPolitician::Wikidata.sparql(query)

EveryPolitician::Wikidata.scrape_wikidata(ids: p39s | existing, names: { es: names })
