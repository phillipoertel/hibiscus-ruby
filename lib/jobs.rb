class Jobs < HibiscusResource

  PATHS = {
    pending: '/jobs/list'
  }

  def pending
    get(PATHS[:pending])
  end

end