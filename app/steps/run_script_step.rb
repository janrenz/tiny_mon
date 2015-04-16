class RunScriptStep < Step
  property :code, :string
  
  def run!(session, check_run)
    session.execute_script(code)
    session.log "script executed"
  end
end
