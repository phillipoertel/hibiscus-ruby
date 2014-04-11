class Account < HibiscusResource
  
  PATHS = {
    all: '/konto/list'
  }

  def all
    get(PATHS[:all])
  end

  #def info
  #def transfers
  #statement_lines

end