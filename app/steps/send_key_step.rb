class SendKeyStep < Step
  property :key, :string
  property :scope, :string

  validates_presence_of :key

  def run!(session, check_run)
    symbol = :key.intern
    if :scope.present?
      element = session.find(:scope)
    else
      element = session.find('body')
    end

    element.native.send_key(symbol)
    session.log "send key #{key}"
  end
end