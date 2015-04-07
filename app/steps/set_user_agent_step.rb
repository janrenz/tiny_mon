class SetUserAgentStep < Step
  property :user_agent, :string

  validates_presence_of :user_agent

  def run!(session, check_run)
    session.set_user_agent(self.user_agent)
  end

end