class CompareNumberStep < Step
  class CompareNumberFailed < CheckFailed; end
  class GetNumberFailed < CheckFailed; end
  property :scope, :string
  property :delta, :string

  validates_presence_of :scope

  def run!(session, check_run)
    if session.has_css?(scope)
      code = "parseInt(document.querySelector('#{scope}').firstChild.nodeValue.match(/\\d+/)[0]);"
      #TODO find better regex
      value2 = session.evaluate_script(code)
      if !value2.is_a? Integer
        session.fail GetNumberFailed, "Expected  #{scope} to contain number"
      elsif session.value1 == nil
        session.fail GetNumberFailed, "Nothing to compare"
      else
        session.log "extracted #{value2} from page"
        if (session.value1 - value2.to_i).abs > value2.to_i * delta.to_i / 100
          session.fail CompareNumberFailed, "Difference between #{session.value1} and #{value2} too large"
        else
          session.log "#{session.value1} and #{value2} are in range of #{delta}%"
        end
      end
    else
      session.fail GetNumberFailed, "Expected page to contain #{scope} but was not found"
    end
  end
end