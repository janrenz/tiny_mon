class SendKeyStep < Step
  property :key, :string

  validates_presence_of :key

  def run!(session, check_run)
    session.send_key(self.key)
    session.log "send key #{key}"
  end
end