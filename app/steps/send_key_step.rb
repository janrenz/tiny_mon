class SendKeyStep < Step
  property :key, :string
  property :scope, :string

  validates_presence_of :key

  def run!(session, check_run)
    symbol = :key.intern
    #(:scope.present?) ? element = session.find(:scope) : element = session.find('body')
puts(:scope)
    element = session.find(:scope)

  rescue
    element = session.find('body')
  ensure
    element.native.send_key(symbol)
    session.log "send key #{:key}"
  end
end