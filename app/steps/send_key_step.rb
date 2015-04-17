class SendKeyStep < Step
  property :key, :string

  validates_presence_of :key

  def run!(session, check_run)
    symbol = :key.intern
    body = session.find('body')
    body.native.send_key(symbol)
    session.log "send key #{key}"
  end
end