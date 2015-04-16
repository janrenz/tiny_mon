class SendKeyStep < Step
  property :key, :string

  validates_presence_of :key

  def run!(session, check_run)
    body = session.find('body')
    body.native.send_key(self.key)
    session.log "send key #{key}"
  end
end