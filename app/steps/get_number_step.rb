class GetNumberStep < Step
  class GetNumberFailed < CheckFailed; end
  property :scope, :string

  validates_presence_of :scope

  def run!(session, check_run)
    if session.has_css?(scope)
      code = "parseInt(document.querySelector('#{scope}').firstChild.nodeValue.match(/\\d+/)[0]);"
      #TODO find better regex
      temp = session.evaluate_script(code)
      if (!temp.is_a? Integer) then
        session.fail GetNumberFailed, "Expected  #{scope} to contain number (#{temp})"
      else
        session.value1 = temp
      end
    else
      session.fail GetNumberFailed, "Expected page to contain #{scope} but was not found"
    end
  end
end