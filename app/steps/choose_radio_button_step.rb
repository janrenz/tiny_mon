class ChooseRadioButtonStep < ScopableStep
  property :name, :string
  
  validates_presence_of :name
  
  def run!(session, check_run)
    with_optional_scope(session) do
      session.choose(self.name)
      session.log "radiobutton chosen"
    end
  end
end
