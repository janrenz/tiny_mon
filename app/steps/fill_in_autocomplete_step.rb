class FillInAutocompleteStep < FillInStep
  property :field, :string
  property :value, :string
  
  validates_presence_of :field
  
  def run!(session, check_run)
    session.fill_in(self.field, :with => self.value)
    session.execute_script %Q{ $('##{field}').trigger("focus") }

    session.execute_script %Q{ $('##{field}').trigger("keydown") }
    selector = ".tt-suggestions > div:nth-child(1)"

    #page.should have_selector selector
    session.execute_script "$(\"#{selector}\").mouseenter().click()"
    session.log "field filled with #{value}"
  end
end
