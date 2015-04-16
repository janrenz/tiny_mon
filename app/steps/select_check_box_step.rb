class SelectCheckBoxStep < ScopableStep
  property :name, :string
  
  validates_presence_of :name
  
  def run!(session, check_run)
    with_optional_scope(session) do
      session.check(self.name)
      session.log "checkbox selected"
    end
  end
end
