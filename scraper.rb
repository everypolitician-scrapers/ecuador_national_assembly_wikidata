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

ids = %w(Q29051867)

EveryPolitician::Wikidata.scrape_wikidata(ids: ids | existing, names: { es: names })
