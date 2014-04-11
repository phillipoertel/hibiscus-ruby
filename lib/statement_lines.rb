class StatementLines < HibiscusResource

  PATHS = {
    search: '/umsaetze/query/{term}',
    latest: '/konto/{account-id}/umsaetze/days/{days}'
  }

  def search(term)
    get(PATHS[:search].gsub('{term}', term))
  end
  
  def latest(account_id, days = 30)
    get(PATHS[:latest].gsub('{account-id}', account_id.to_s).gsub('{days}', days.to_s))
  end

end