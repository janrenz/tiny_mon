class SetUserAgentStep < Step
  property :user_agent, :string

  validates_presence_of :user_agent

  def run!(session, check_run)
    session.driver.add_headers("User-Agent" => self.user_agent)
  end

end