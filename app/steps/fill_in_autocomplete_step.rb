class FillInAutocompleteStep < FillInStep
  property :field, :string
  property :value, :string

  validates_presence_of :field

  def run!(session, check_run)
    session.execute_script %Q{ $('##{field}').focus().typeahead('val', '').focus().typeahead('val', '#{value}'); }

    session.find(".tt-dataset")
    session.execute_script %Q{ $(".tt-suggestion:contains('#{value} '):first").click();}

    session.log "field filled with #{value}"
  end
end
